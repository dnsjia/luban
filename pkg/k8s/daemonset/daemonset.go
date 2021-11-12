package daemonset

import (
	apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
)

// DaemonSetList contains a list of Daemon Sets in the cluster.
type DaemonSetList struct {
	ListMeta   k8s.ListMeta             `json:"listMeta"`
	DaemonSets []DaemonSet              `json:"daemonSets"`
	Status     k8scommon.ResourceStatus `json:"status"`

	// List of non-critical errors, that occurred during resource retrieval.
	Errors []error `json:"errors"`
}

// DaemonSet plus zero or more Kubernetes services that target the Daemon Set.
type DaemonSet struct {
	ObjectMeta          k8s.ObjectMeta    `json:"objectMeta"`
	TypeMeta            k8s.TypeMeta      `json:"typeMeta"`
	Pods                k8scommon.PodInfo `json:"podInfo"`
	ContainerImages     []string          `json:"containerImages"`
	InitContainerImages []string          `json:"initContainerImages"`
}

func GetDaemonSetList(client *kubernetes.Clientset, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*DaemonSetList, error) {
	channels := &k8scommon.ResourceChannels{
		DaemonSetList: k8scommon.GetDaemonSetListChannel(client, nsQuery, 1),
		ServiceList:   k8scommon.GetServiceListChannel(client, nsQuery, 1),
		PodList:       k8scommon.GetPodListChannel(client, nsQuery, 1),
		EventList:     k8scommon.GetEventListChannel(client, nsQuery, 1),
	}

	return GetDaemonSetListFromChannels(channels, dsQuery)
}

// GetDaemonSetListFromChannels returns a list of all Daemon Set in the cluster
// reading required resource list once from the channels.
func GetDaemonSetListFromChannels(channels *k8scommon.ResourceChannels, dsQuery *dataselect.DataSelectQuery) (*DaemonSetList, error) {

	daemonSets := <-channels.DaemonSetList.List
	err := <-channels.DaemonSetList.Error
	if err != nil {
		return nil, err
	}

	pods := <-channels.PodList.List
	err = <-channels.PodList.Error
	if err != nil {
		return nil, err
	}

	events := <-channels.EventList.List
	err = <-channels.EventList.Error
	if err != nil {
		return nil, err
	}

	dsList := toDaemonSetList(daemonSets.Items, pods.Items, events.Items, dsQuery)
	dsList.Status = getStatus(daemonSets, pods.Items, events.Items)
	return dsList, nil
}

func toDaemonSetList(daemonSets []apps.DaemonSet, pods []v1.Pod, events []v1.Event, dsQuery *dataselect.DataSelectQuery) *DaemonSetList {

	daemonSetList := &DaemonSetList{
		DaemonSets: make([]DaemonSet, 0),
		ListMeta:   k8s.ListMeta{TotalItems: len(daemonSets)},
	}

	dsCells, filteredTotal := dataselect.GenericDataSelectWithFilter(ToCells(daemonSets), dsQuery)
	daemonSets = FromCells(dsCells)
	daemonSetList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, daemonSet := range daemonSets {
		daemonSetList.DaemonSets = append(daemonSetList.DaemonSets, toDaemonSet(daemonSet, pods, events))
	}

	return daemonSetList
}

func toDaemonSet(daemonSet apps.DaemonSet, pods []v1.Pod, events []v1.Event) DaemonSet {
	matchingPods := k8scommon.FilterPodsByControllerRef(&daemonSet, pods)
	podInfo := k8scommon.GetPodInfo(daemonSet.Status.CurrentNumberScheduled, &daemonSet.Status.DesiredNumberScheduled, matchingPods)
	podInfo.Warnings = event.GetPodsEventWarnings(events, matchingPods)

	return DaemonSet{
		ObjectMeta:          k8s.NewObjectMeta(daemonSet.ObjectMeta),
		TypeMeta:            k8s.NewTypeMeta(k8s.ResourceKindDaemonSet),
		Pods:                podInfo,
		ContainerImages:     k8scommon.GetContainerImages(&daemonSet.Spec.Template.Spec),
		InitContainerImages: k8scommon.GetInitContainerImages(&daemonSet.Spec.Template.Spec),
	}
}
