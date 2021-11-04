package pods

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
)

// PodList contains a list of Pods in the cluster.
type PodList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// Basic information about resources status on the list.
	Status k8scommon.ResourceStatus `json:"status"`

	// Unordered list of Pods.
	Pods []Pod `json:"pods"`

	// List of non-critical errors, that occurred during resource retrieval.
	Errors []error `json:"errors"`
}

type PodStatus struct {
	Status          string              `json:"status"`
	PodPhase        v1.PodPhase         `json:"podPhase"`
	ContainerStates []v1.ContainerState `json:"containerStates"`
}

// Pod is a presentation layer view of Kubernetes Pod resource. This means it is Pod plus additional augmented data
// we can get from other sources (like services that target it).
type Pod struct {
	ObjectMeta k8s.ObjectMeta `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta   `json:"typeMeta"`

	// Status determined based on the same logic as kubectl.
	Status string `json:"status"`

	// RestartCount of containers restarts.
	RestartCount int32 `json:"restartCount"`

	// Pod warning events
	Warnings []k8scommon.Event `json:"warnings"`

	// NodeName of the Node this Pod runs on.
	NodeName string `json:"nodeName"`

	// ContainerImages holds a list of the Pod images.
	ContainerImages []string `json:"containerImages"`

	// Pod ip address
	PodIP string `json:"podIP"`
}

var EmptyPodList = &PodList{
	Pods:   make([]Pod, 0),
	Errors: make([]error, 0),
	ListMeta: k8s.ListMeta{
		TotalItems: 0,
	},
}

func GetPodsList(client *kubernetes.Clientset, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*PodList, error) {
	common.LOG.Info("Getting list of all pods in the cluster")
	channels := &k8scommon.ResourceChannels{
		PodList:   k8scommon.GetPodListChannelWithOptions(client, nsQuery, metav1.ListOptions{}, 1),
		EventList: k8scommon.GetEventListChannel(client, nsQuery, 1),
	}

	return GetPodListFromChannels(channels, dsQuery)

}

// GetPodListFromChannels returns a list of all Pods in the cluster
// reading required resource list once from the channels.
func GetPodListFromChannels(channels *k8scommon.ResourceChannels, dsQuery *dataselect.DataSelectQuery) (*PodList, error) {

	pods := <-channels.PodList.List
	err := <-channels.PodList.Error
	if err != nil {
		return nil, err
	}

	eventList := <-channels.EventList.List
	err = <-channels.EventList.Error
	if err != nil {
		return nil, err
	}

	podList := ToPodList(pods.Items, eventList.Items, dsQuery)
	podList.Status = getStatus(pods, eventList.Items)
	return &podList, nil
}
func ToPodList(pods []v1.Pod, events []v1.Event, dsQuery *dataselect.DataSelectQuery) PodList {
	podList := PodList{
		Pods: make([]Pod, 0),
	}

	podCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(pods), dsQuery)
	pods = fromCells(podCells)
	podList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, pod := range pods {
		warnings := event.GetPodsEventWarnings(events, []v1.Pod{pod})
		podDetail := toPod(&pod, warnings)
		podList.Pods = append(podList.Pods, podDetail)
	}

	return podList
}

func toPod(pod *v1.Pod, warnings []k8scommon.Event) Pod {
	podDetail := Pod{
		ObjectMeta:      k8s.NewObjectMeta(pod.ObjectMeta),
		TypeMeta:        k8s.NewTypeMeta(k8s.ResourceKindPod),
		Warnings:        warnings,
		Status:          getPodStatus(*pod),
		RestartCount:    getRestartCount(*pod),
		NodeName:        pod.Spec.NodeName,
		ContainerImages: k8scommon.GetContainerImages(&pod.Spec),
		PodIP:           pod.Status.PodIP,
	}

	return podDetail
}

func DeleteCollectionPods(client *kubernetes.Clientset, podList []k8s.RemovePodsData) (err error) {
	common.LOG.Info("批量删除容器组开始")
	for _, v := range podList {
		common.LOG.Info(fmt.Sprintf("delete pods：%v, ns: %v", v.PodName, v.Namespace))
		err := client.CoreV1().Pods(v.Namespace).Delete(
			context.TODO(),
			v.PodName,
			metav1.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除容器组已完成")
	return nil
}

func DeletePod(client *kubernetes.Clientset, namespace string, podName string) (err error) {
	common.LOG.Info(fmt.Sprintf("请求删除单个pod：%v, namespace: %v", podName, namespace))
	return client.CoreV1().Pods(namespace).Delete(
		context.TODO(),
		podName,
		metav1.DeleteOptions{},
	)
}
