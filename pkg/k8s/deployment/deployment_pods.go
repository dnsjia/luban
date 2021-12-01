package deployment

import (
	"context"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/k8s"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/event"
	"github.com/dnsjia/luban/pkg/k8s/pods"
	"go.uber.org/zap"
	apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

type PodList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// Basic information about resources status on the list.
	Status k8scommon.ResourceStatus `json:"status"`

	// Unordered list of Pods.
	Pods []pods.Pod `json:"pods"`
}

func getDeploymentToPod(client *kubernetes.Clientset, deployment *apps.Deployment) (po *PodList) {

	selector, err := metav1.LabelSelectorAsSelector(deployment.Spec.Selector)
	if err != nil {
		return nil
	}
	options := metav1.ListOptions{LabelSelector: selector.String()}

	podData, err := client.CoreV1().Pods(deployment.Namespace).List(context.TODO(), options)
	if err != nil {
		common.LOG.Error("Get a pod exception from the deployment", zap.Any("err", err))
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
