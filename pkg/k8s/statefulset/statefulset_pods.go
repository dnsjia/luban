package statefulset

import (
	"context"
	apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	k8scommon "pigs/pkg/k8s/common"
)

// Returns simple info about pods(running, desired, failing, etc.) related to given pet set.
func getStatefulSetPodInfo(client kubernetes.Interface, statefulSet *apps.StatefulSet) (*k8scommon.PodInfo, error) {
	pods, err := getRawStatefulSetPods(client, statefulSet.Name, statefulSet.Namespace)
	if err != nil {
		return nil, err
	}

	podInfo := k8scommon.GetPodInfo(statefulSet.Status.Replicas, statefulSet.Spec.Replicas, pods)
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
