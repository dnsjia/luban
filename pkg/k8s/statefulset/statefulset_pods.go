package statefulset

import (
	"context"
	"go.uber.org/zap"
	apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/event"
	"pigs/pkg/k8s/pods"
)

type PodList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// Basic information about resources status on the list.
	Status k8scommon.ResourceStatus `json:"status"`

	// Unordered list of Pods.
	Pods []pods.Pod `json:"pods"`
}

// Returns simple info about pods(running, desired, failing, etc.) related to given pet set.
func getStatefulSetPodInfo(client kubernetes.Interface, statefulSet *apps.StatefulSet) (*k8scommon.PodInfo, error) {
	podList, err := getRawStatefulSetPods(client, statefulSet.Name, statefulSet.Namespace)
	if err != nil {
		return nil, err
	}

	podInfo := k8scommon.GetPodInfo(statefulSet.Status.Replicas, statefulSet.Spec.Replicas, podList)
	return &podInfo, nil
}

// getRawStatefulSetPods return array of api pods targeting pet set with given name.
func getRawStatefulSetPods(client kubernetes.Interface, name, namespace string) ([]v1.Pod, error) {
	statefulSet, err := client.AppsV1().StatefulSets(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	channels := &k8scommon.ResourceChannels{
		PodList: k8scommon.GetPodListChannel(client, k8scommon.NewSameNamespaceQuery(namespace), 1),
	}

	podList := <-channels.PodList.List
	if err := <-channels.PodList.Error; err != nil {
		return nil, err
	}

	return k8scommon.FilterPodsByControllerRef(statefulSet, podList.Items), nil
}

func getStatefulSetToPod(client *kubernetes.Clientset, stateful *apps.StatefulSet) (po *PodList) {

	selector, err := metaV1.LabelSelectorAsSelector(stateful.Spec.Selector)
	if err != nil {
		return nil
	}
	options := metaV1.ListOptions{LabelSelector: selector.String()}

	podData, err := client.CoreV1().Pods(stateful.Namespace).List(context.TODO(), options)
	if err != nil {
		common.LOG.Error("Get a pod exception from the statefulSet", zap.Any("err", err))
	}
	podList := PodList{
		Pods: make([]pods.Pod, 0),
	}
	podList.ListMeta = k8s.ListMeta{TotalItems: len(podData.Items)}
	for _, pod := range podData.Items {
		warnings := event.GetPodsEventWarnings(nil, []v1.Pod{pod})
		podDetail := pods.ToPod(&pod, warnings)
		podList.Pods = append(podList.Pods, podDetail)
	}
	return &podList
}
