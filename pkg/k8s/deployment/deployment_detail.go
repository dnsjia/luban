package deployment

import (
	"context"
	"fmt"
	apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/event"
	"pigs/pkg/k8s/service"
	"pigs/tools"
	"sort"
)

// RollingUpdateStrategy is behavior of a rolling update. See RollingUpdateDeployment K8s object.
type RollingUpdateStrategy struct {
	MaxSurge       *intstr.IntOrString `json:"maxSurge"`
	MaxUnavailable *intstr.IntOrString `json:"maxUnavailable"`
}

// StatusInfo is the status information of the deployment
type StatusInfo struct {
	// Total number of desired replicas on the deployment
	Replicas int32 `json:"replicas"`

	// Number of non-terminated pods that have the desired template spec
	Updated int32 `json:"updated"`

	// Number of available pods (ready for at least minReadySeconds)
	// targeted by this deployment
	Available int32 `json:"available"`

	// Total number of unavailable pods targeted by this deployment.
	Unavailable int32 `json:"unavailable"`
}

// DeploymentDetail is a presentation layer view of Kubernetes Deployment resource.
type DeploymentDetail struct {
	// Extends list item structure.
	Deployment `json:",inline"`

	// Label selector of the service.
	Selector map[string]string `json:"selector"`

	// Status information on the deployment
	StatusInfo `json:"statusInfo"`

	// Conditions describe the state of a deployment at a certain point.
	Conditions []k8scommon.Condition `json:"conditions"`

	// The deployment strategy to use to replace existing pods with new ones.
	// Valid options: Recreate, RollingUpdate
	Strategy apps.DeploymentStrategyType `json:"strategy"`

	// Min ready seconds
	MinReadySeconds int32 `json:"minReadySeconds"`

	// Rolling update strategy containing maxSurge and maxUnavailable
	RollingUpdateStrategy *RollingUpdateStrategy `json:"rollingUpdateStrategy,omitempty"`

	// Optional field that specifies the number of old Replica Sets to retain to allow rollback.
	RevisionHistoryLimit *int32 `json:"revisionHistoryLimit"`

	// Events Info
	Events []v1.Event `json:"events"`

	// Deployment history image version
	HistoryVersion []HistoryVersion `json:"historyVersion"`

	PodList *PodList `json:"podList"`

	SvcList *service.ServiceList `json:"svcList"`
}

// GetDeploymentDetail returns model object of deployment and error, if any.
func GetDeploymentDetail(client *kubernetes.Clientset, namespace string, deploymentName string) (*DeploymentDetail, error) {

	common.LOG.Info(fmt.Sprintf("Getting details of %s deployment in %s namespace", deploymentName, namespace))

	deployment, err := client.AppsV1().Deployments(namespace).Get(context.TODO(), deploymentName, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	selector, err := metaV1.LabelSelectorAsSelector(deployment.Spec.Selector)
	if err != nil {
		return nil, err
	}
	options := metaV1.ListOptions{LabelSelector: selector.String()}

	channels := &k8scommon.ResourceChannels{
		ReplicaSetList: k8scommon.GetReplicaSetListChannelWithOptions(client,
			k8scommon.NewSameNamespaceQuery(namespace), options, 1),
		PodList: k8scommon.GetPodListChannelWithOptions(client,
			k8scommon.NewSameNamespaceQuery(namespace), options, 1),
		EventList: k8scommon.GetEventListChannelWithOptions(client,
			k8scommon.NewSameNamespaceQuery(namespace), options, 1),
	}

	rawRs := <-channels.ReplicaSetList.List
	err = <-channels.ReplicaSetList.Error
	if err != nil {
		return nil, err
	}

	rawPods := <-channels.PodList.List
	err = <-channels.PodList.Error
	if err != nil {
		return nil, err
	}

	rawEvents := <-channels.EventList.List
	err = <-channels.EventList.Error
	if err != nil {
		return nil, err
	}

	// Extra Info
	var rollingUpdateStrategy *RollingUpdateStrategy
	if deployment.Spec.Strategy.RollingUpdate != nil {
		rollingUpdateStrategy = &RollingUpdateStrategy{
			MaxSurge:       deployment.Spec.Strategy.RollingUpdate.MaxSurge,
			MaxUnavailable: deployment.Spec.Strategy.RollingUpdate.MaxUnavailable,
		}
	}
	events, _ := event.GetEvents(client, namespace, fmt.Sprintf("involvedObject.name=%v", deploymentName))
	serviceList, _ := service.GetToService(client, namespace, deploymentName)

	return &DeploymentDetail{
		Deployment:            toDeployment(deployment, rawRs.Items, rawPods.Items, rawEvents.Items),
		Selector:              deployment.Spec.Selector.MatchLabels,
		StatusInfo:            GetStatusInfo(&deployment.Status),
		Conditions:            getConditions(deployment.Status.Conditions),
		Strategy:              deployment.Spec.Strategy.Type,
		MinReadySeconds:       deployment.Spec.MinReadySeconds,
		RollingUpdateStrategy: rollingUpdateStrategy,
		RevisionHistoryLimit:  deployment.Spec.RevisionHistoryLimit,
		Events:                events,
		PodList:               getDeploymentToPod(client, deployment),
		SvcList:               serviceList,
		HistoryVersion:        getDeploymentHistory(namespace, deploymentName, rawRs.Items),
	}, nil
}

// GetStatusInfo is used to get the status information from the *apps.DeploymentStatus
func GetStatusInfo(deploymentStatus *apps.DeploymentStatus) StatusInfo {
	return StatusInfo{
		Replicas:    deploymentStatus.Replicas,
		Updated:     deploymentStatus.UpdatedReplicas,
		Available:   deploymentStatus.AvailableReplicas,
		Unavailable: deploymentStatus.UnavailableReplicas,
	}
}

type HistoryVersion struct {
	CreateTime metaV1.Time `json:"create_time"`
	Image      string      `json:"image"`
	Version    int64       `json:"version"`
	Namespace  string      `json:"namespace"`
	Name       string      `json:"name"`
}

func getDeploymentHistory(namespace string, deploymentName string, rs []apps.ReplicaSet) []HistoryVersion {

	var historyVersion []HistoryVersion

	for _, v := range rs {
		if namespace == v.Namespace && deploymentName == v.OwnerReferences[0].Name {
			history := HistoryVersion{
				CreateTime: v.CreationTimestamp,
				Image:      v.Spec.Template.Spec.Containers[0].Image,
				Version:    tools.ParseStringToInt64(v.Annotations["deployment.kubernetes.io/revision"]),
				Namespace:  v.Namespace,
				Name:       v.OwnerReferences[0].Name,
			}
			historyVersion = append(historyVersion, history)

		}
	}
	// Sort the map by date
	//sort.Slice(historyVersion, func(i, j int) bool {
	//	return historyVersion[j].CreateTime.Before(&historyVersion[i].CreateTime)
	//})
	// Sort the map by version
	sort.Sort(historiesByRevision(historyVersion))

	return historyVersion
}

type historiesByRevision []HistoryVersion

func (h historiesByRevision) Len() int {
	return len(h)
}
func (h historiesByRevision) Swap(i, j int) {
	h[i], h[j] = h[j], h[i]
}
func (h historiesByRevision) Less(i, j int) bool {
	return h[j].Version < h[i].Version
}
