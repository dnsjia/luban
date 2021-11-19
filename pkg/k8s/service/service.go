package service

import (
	"context"
	"fmt"
	"go.uber.org/zap"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/deployment"
)

// Service is a representation of a service.
type Service struct {
	ObjectMeta k8s.ObjectMeta `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta   `json:"typeMeta"`

	// InternalEndpoint of all Kubernetes services that have the same label selector as connected Replication
	// Controller. Endpoint is DNS name merged with ports.
	InternalEndpoint k8scommon.Endpoint `json:"internalEndpoint"`

	// ExternalEndpoints of all Kubernetes services that have the same label selector as connected Replication
	// Controller. Endpoint is external IP address name merged with ports.
	ExternalEndpoints []k8scommon.Endpoint `json:"externalEndpoints"`

	// Label selector of the service.
	Selector map[string]string `json:"selector"`

	// Type determines how the service will be exposed.  Valid options: ClusterIP, NodePort, LoadBalancer, ExternalName
	Type v1.ServiceType `json:"type"`

	// ClusterIP is usually assigned by the master. Valid values are None, empty string (""), or
	// a valid IP address. None can be specified for headless services when proxying is not required
	ClusterIP string `json:"clusterIP"`
}

// ServiceList contains a list of services in the cluster.
type ServiceList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// Unordered list of services.
	Services []Service `json:"services"`

	// List of non-critical errors, that occurred during resource retrieval.
	Errors []error `json:"errors"`
}

// GetServiceList returns a list of all services in the cluster.
func GetServiceList(client *kubernetes.Clientset, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*ServiceList, error) {
	common.LOG.Info("Getting list of all services in the cluster")

	channels := &k8scommon.ResourceChannels{
		ServiceList: k8scommon.GetServiceListChannel(client, nsQuery, 1),
	}

	return GetServiceListFromChannels(channels, dsQuery)
}

// GetServiceListFromChannels returns a list of all services in the cluster.
func GetServiceListFromChannels(channels *k8scommon.ResourceChannels,
	dsQuery *dataselect.DataSelectQuery) (*ServiceList, error) {
	services := <-channels.ServiceList.List
	err := <-channels.ServiceList.Error
	if err != nil {
		return nil, err
	}

	return CreateServiceList(services.Items, dsQuery), nil
}

func toService(service *v1.Service) Service {
	return Service{
		ObjectMeta:        k8s.NewObjectMeta(service.ObjectMeta),
		TypeMeta:          k8s.NewTypeMeta(k8s.ResourceKindService),
		InternalEndpoint:  k8scommon.GetInternalEndpoint(service.Name, service.Namespace, service.Spec.Ports),
		ExternalEndpoints: k8scommon.GetExternalEndpoints(service),
		Selector:          service.Spec.Selector,
		ClusterIP:         service.Spec.ClusterIP,
		Type:              service.Spec.Type,
	}
}

// CreateServiceList returns paginated service list based on given service array and pagination query.
func CreateServiceList(services []v1.Service, dsQuery *dataselect.DataSelectQuery) *ServiceList {
	serviceList := &ServiceList{
		Services: make([]Service, 0),
		ListMeta: k8s.ListMeta{TotalItems: len(services)},
	}

	serviceCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(services), dsQuery)
	services = fromCells(serviceCells)
	serviceList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, service := range services {
		serviceList.Services = append(serviceList.Services, toService(&service))
	}

	return serviceList
}

func GetDeploymentToService(client *kubernetes.Clientset, ns string, deploymentName string) (*v1.ServiceList, error) {

	deploymentData, err := deployment.GetDeploymentDetail(client, ns, deploymentName)
	if err != nil {
		common.LOG.Error("获取deployment详情异常", zap.Any("err: ", err))
		return nil, err
	}
	for k, v := range deploymentData.Selector {
		selector := fmt.Sprintf("%v=%v", k, v)
		common.LOG.Info(fmt.Sprintf("根据label过滤service: %v", selector))
		svc, err := client.CoreV1().Services(ns).List(context.TODO(), metav1.ListOptions{
			LabelSelector: selector,
		})
		if err != nil {
			common.LOG.Error("根据deployment获取service异常", zap.Any("err: ", err))
			return nil, err
		}
		return svc, nil
	}

	return nil, err
}

func DeleteService(client *kubernetes.Clientset, ns string, serviceName string) error {
	common.LOG.Info(fmt.Sprintf("请求删除Service: %v, namespace: %v", serviceName, ns))
	return client.CoreV1().Services(ns).Delete(
		context.TODO(),
		serviceName,
		metav1.DeleteOptions{},
	)
}

func DeleteCollectionService(client *kubernetes.Clientset, serviceList []k8s.ServiceData) (err error) {
	common.LOG.Info("批量删除service开始")
	for _, v := range serviceList {
		common.LOG.Info(fmt.Sprintf("delete service：%v, ns: %v", v.Name, v.Namespace))
		err := client.CoreV1().Services(v.Namespace).Delete(
			context.TODO(),
			v.Name,
			metav1.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除service已完成")
	return nil
}
