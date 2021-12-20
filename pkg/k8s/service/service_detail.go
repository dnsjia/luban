package service

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/endpoint"
	"github.com/dnsjia/luban/pkg/k8s/pods"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

// ServiceDetail is a representation of a service.
type ServiceDetail struct {
	// Extends list item structure.
	Service `json:",inline"`

	// List of Endpoint obj. that are endpoints of this Service.
	EndpointList endpoint.EndpointList `json:"endpointList"`

	// Show the value of the SessionAffinity of the Service.
	SessionAffinity v1.ServiceAffinity `json:"sessionAffinity"`

	EventList *k8scommon.EventList `json:"eventList"`

	PodList *pods.PodList `json:"podList"`
}

// GetServiceDetail gets service details.
func GetServiceDetail(client *kubernetes.Clientset, namespace, name string, dsQuery *dataselect.DataSelectQuery) (*ServiceDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s service in %s namespace", name, namespace))
	serviceData, err := client.CoreV1().Services(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	endpointList, err := endpoint.GetServiceEndpoints(client, namespace, name)
	if err != nil {
		return nil, err
	}
	podList, err := GetServicePods(client, namespace, name, dsQuery)
	if err != nil {
		return nil, err
	}

	eventList, err := GetServiceEvents(client, dataselect.DefaultDataSelect, namespace, name)
	if err != nil {
		return nil, err
	}

	service := toServiceDetail(serviceData, *endpointList, podList, eventList)
	return &service, nil
}

func toServiceDetail(service *v1.Service, endpointList endpoint.EndpointList, podList *pods.PodList, eventList *k8scommon.EventList) ServiceDetail {
	return ServiceDetail{
		Service:         ToService(service),
		EndpointList:    endpointList,
		PodList:         podList,
		EventList:       eventList,
		SessionAffinity: service.Spec.SessionAffinity,
	}
}
