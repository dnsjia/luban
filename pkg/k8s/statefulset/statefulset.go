package statefulset

import (
	"context"
	"fmt"
	"go.uber.org/zap"
	apps "k8s.io/api/apps/v1"
	autoscalingv1 "k8s.io/api/autoscaling/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
	"time"
)

// StatefulSetList contains a list of Stateful Sets in the cluster.
type StatefulSetList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	Status       k8scommon.ResourceStatus `json:"status"`
	StatefulSets []StatefulSet            `json:"statefulSets"`
}

// StatusInfo is the status information of the statefulSet
type StatusInfo struct {
	// replicas is the number of Pods created by the StatefulSet controller.
	Replicas int32 `json:"replicas"`

	// Number of non-terminated pods that have the desired template spec
	Updated int32 `json:"updated"`

	// readyReplicas is the number of Pods created by the StatefulSet controller that have a Ready Condition.
	ReadyReplicas int32 `json:"readyReplicas,omitempty"`

	// currentReplicas is the number of Pods created by the StatefulSet controller from the StatefulSet version
	// indicated by currentRevision.
	CurrentReplicas int32 `json:"currentReplicas,omitempty"`

	// updatedReplicas is the number of Pods created by the StatefulSet controller from the StatefulSet version
	// indicated by updateRevision.
	UpdatedReplicas int32 `json:"updatedReplicas,omitempty"`
	// Total number of available pods (ready for at least minReadySeconds) targeted by this statefulset.
	// This is an alpha field and requires enabling StatefulSetMinReadySeconds feature gate.
	// Remove omitempty when graduating to beta
	// +optional
	AvailableReplicas int32 `json:"availableReplicas,omitempty"`
}

// StatefulSet is a presentation layer view of Kubernetes Stateful Set resource.
type StatefulSet struct {
	ObjectMeta k8s.ObjectMeta    `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta      `json:"typeMeta"`
	Pods       k8scommon.PodInfo `json:"podInfo"`

	// Status information on the statefulSet
	StatusInfo `json:"statusInfo"`

	// Label selector
	Selector *metav1.LabelSelector `json:"selector"`
	// The statefulset strategy to use to replace existing pods with new ones.
	// Valid options: Recreate, RollingUpdate
	Strategy apps.StatefulSetUpdateStrategy `json:"strategy"`

	ContainerImages     []string `json:"containerImages"`
	InitContainerImages []string `json:"initContainerImages"`
}

// GetStatefulSetList returns a list of all Stateful Sets in the cluster.
func GetStatefulSetList(client *kubernetes.Clientset, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*StatefulSetList, error) {
	common.LOG.Info("Getting list of all pet sets in the cluster")

	channels := &k8scommon.ResourceChannels{
		StatefulSetList: k8scommon.GetStatefulSetListChannel(client, nsQuery, 1),
		PodList:         k8scommon.GetPodListChannel(client, nsQuery, 1),
		EventList:       k8scommon.GetEventListChannel(client, nsQuery, 1),
	}

	return GetStatefulSetListFromChannels(channels, dsQuery)
}

// GetStatefulSetListFromChannels returns a list of all Stateful Sets in the cluster reading
// required resource list once from the channels.
func GetStatefulSetListFromChannels(channels *k8scommon.ResourceChannels, dsQuery *dataselect.DataSelectQuery) (*StatefulSetList, error) {

	statefulSets := <-channels.StatefulSetList.List
	err := <-channels.StatefulSetList.Error
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

	ssList := toStatefulSetList(statefulSets.Items, pods.Items, events.Items, dsQuery)
	ssList.Status = getStatus(statefulSets, pods.Items, events.Items)
	return ssList, nil
}

func toStatefulSetList(statefulSets []apps.StatefulSet, pods []v1.Pod, events []v1.Event, dsQuery *dataselect.DataSelectQuery) *StatefulSetList {

	statefulSetList := &StatefulSetList{
		StatefulSets: make([]StatefulSet, 0),
		ListMeta:     k8s.ListMeta{TotalItems: len(statefulSets)},
	}

	ssCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(statefulSets), dsQuery)
	statefulSets = fromCells(ssCells)
	statefulSetList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, statefulSet := range statefulSets {
		matchingPods := k8scommon.FilterPodsByControllerRef(&statefulSet, pods)
		podInfo := k8scommon.GetPodInfo(statefulSet.Status.Replicas, statefulSet.Spec.Replicas, matchingPods)
		podInfo.Warnings = event.GetPodsEventWarnings(events, matchingPods)
		statefulSetList.StatefulSets = append(statefulSetList.StatefulSets, toStatefulSet(&statefulSet, &podInfo))
	}

	return statefulSetList
}

func toStatefulSet(statefulSet *apps.StatefulSet, podInfo *k8scommon.PodInfo) StatefulSet {

	return StatefulSet{
		ObjectMeta:          k8s.NewObjectMeta(statefulSet.ObjectMeta),
		TypeMeta:            k8s.NewTypeMeta(k8s.ResourceKindStatefulSet),
		StatusInfo:          GetStatusInfo(&statefulSet.Status),
		Selector:            statefulSet.Spec.Selector,
		Strategy:            statefulSet.Spec.UpdateStrategy,
		ContainerImages:     k8scommon.GetContainerImages(&statefulSet.Spec.Template.Spec),
		InitContainerImages: k8scommon.GetInitContainerImages(&statefulSet.Spec.Template.Spec),
		Pods:                *podInfo,
	}
}

func DeleteCollectionStatefulSet(client *kubernetes.Clientset, statefulSetList []k8s.StatefulSetData) (err error) {
	common.LOG.Info("批量删除statefulset开始")
	for _, v := range statefulSetList {
		common.LOG.Info(fmt.Sprintf("delete statefulset：%v, ns: %v", v.Name, v.Namespace))
		err := client.AppsV1().StatefulSets(v.Namespace).Delete(
			context.TODO(),
			v.Name,
			metav1.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除statefulset已完成")
	return nil
}

func DeleteStatefulSet(client *kubernetes.Clientset, ns string, name string) (err error) {
	common.LOG.Info(fmt.Sprintf("请求删除单个statefulset：%v, namespace: %v", name, ns))
	return client.AppsV1().StatefulSets(ns).Delete(
		context.TODO(),
		name,
		metav1.DeleteOptions{},
	)
}

func RestartStatefulSet(client *kubernetes.Clientset, name string, namespace string) (err error) {
	common.LOG.Info(fmt.Sprintf("下发应用重启指令, 名称空间：%v, 有状态应用：%v", namespace, name))
	data := fmt.Sprintf(`{"spec":{"template":{"metadata":{"annotations":{"kubectl.kubernetes.io/restartedAt":"%s"}}}}}`, time.Now().String())
	_, err = client.AppsV1().StatefulSets(namespace).Patch(
		context.Background(),
		name,
		types.StrategicMergePatchType,
		[]byte(data),
		metav1.PatchOptions{
			FieldManager: "kubectl-rollout",
		})

	if err != nil {
		common.LOG.Error("应用重启失败", zap.Any("err: ", err))
		return err
	}
	return nil
}

func ScaleStatefulSet(client *kubernetes.Clientset, ns string, name string, scaleNumber int32) (err error) {

	common.LOG.Info(fmt.Sprintf("start scale of %v statefulset in %v namespace", name, ns))

	scaleData, err := client.AppsV1().StatefulSets(ns).GetScale(
		context.TODO(),
		name,
		metav1.GetOptions{},
	)

	common.LOG.Info(fmt.Sprintf("The statefulset has changed from %v to %v", scaleData.Spec.Replicas, scaleNumber))

	scale := autoscalingv1.Scale{
		TypeMeta:   scaleData.TypeMeta,
		ObjectMeta: scaleData.ObjectMeta,
		Spec:       autoscalingv1.ScaleSpec{Replicas: scaleNumber},
		Status:     scaleData.Status,
	}
	_, err = client.AppsV1().StatefulSets(ns).UpdateScale(
		context.TODO(),
		name,
		&scale,
		metav1.UpdateOptions{},
	)

	if err != nil {
		common.LOG.Error("扩缩容出现异常", zap.Any("err: ", err))
		return err
	}
	return nil
}

// GetStatusInfo is used to get the status information from the *apps.StatefulSetStatus
func GetStatusInfo(statefulSetStatus *apps.StatefulSetStatus) StatusInfo {
	return StatusInfo{
		Replicas:          statefulSetStatus.Replicas,
		Updated:           statefulSetStatus.UpdatedReplicas,
		AvailableReplicas: statefulSetStatus.AvailableReplicas,
		ReadyReplicas:     statefulSetStatus.ReadyReplicas,
		CurrentReplicas:   statefulSetStatus.CurrentReplicas,
	}
}
