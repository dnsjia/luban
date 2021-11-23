package daemonset

import (
	"context"
	"fmt"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/service"
)

// DaemonSetDetail represents detailed information about a Daemon Set.
type DaemonSetDetail struct {
	// Extends list item structure.
	DaemonSet `json:",inline"`

	LabelSelector *v1.LabelSelector `json:"labelSelector,omitempty"`

	PodList *PodList `json:"podList"`

	SvcList *service.ServiceList `json:"svcList"`
}

// GetDaemonSetDetail Returns detailed information about the given daemon set in the given namespace.
func GetDaemonSetDetail(client *kubernetes.Clientset, namespace, name string) (*DaemonSetDetail, error) {

	common.LOG.Info(fmt.Sprintf("Getting details of %s daemon set in %s namespace", name, namespace))
	daemonSet, err := client.AppsV1().DaemonSets(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	channels := &k8scommon.ResourceChannels{
		EventList: k8scommon.GetEventListChannel(client, k8scommon.NewSameNamespaceQuery(namespace), 1),
		PodList:   k8scommon.GetPodListChannel(client, k8scommon.NewSameNamespaceQuery(namespace), 1),
	}

	eventList := <-channels.EventList.List
	if err := <-channels.EventList.Error; err != nil {
		return nil, err
	}

	podList := <-channels.PodList.List
	if err := <-channels.PodList.Error; err != nil {
		return nil, err
	}
	serviceList, _ := service.GetToService(client, namespace, name)
	return &DaemonSetDetail{
		DaemonSet:     toDaemonSet(*daemonSet, podList.Items, eventList.Items),
		LabelSelector: daemonSet.Spec.Selector,
		PodList:       getDaemonSetToPod(client, *daemonSet),
		SvcList:       serviceList,
	}, nil
}
