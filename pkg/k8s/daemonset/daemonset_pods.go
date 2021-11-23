package daemonset

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

func getDaemonSetToPod(client *kubernetes.Clientset, daemonSet apps.DaemonSet) (po *PodList) {

	selector, err := metaV1.LabelSelectorAsSelector(daemonSet.Spec.Selector)
	if err != nil {
		return nil
	}
	options := metaV1.ListOptions{LabelSelector: selector.String()}

	podData, err := client.CoreV1().Pods(daemonSet.Namespace).List(context.TODO(), options)
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
