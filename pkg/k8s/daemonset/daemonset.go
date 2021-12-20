/*
Copyright 2021 The DnsJia Authors.
WebSite:  https://github.com/dnsjia/luban
Email:    OpenSource@dnsjia.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package daemonset

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/k8s"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/event"
	"go.uber.org/zap"
	apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/kubernetes"
	"time"
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
	ObjectMeta k8s.ObjectMeta               `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta                 `json:"typeMeta"`
	Pods       k8scommon.PodInfo            `json:"podInfo"`
	Strategy   apps.DaemonSetUpdateStrategy `json:"strategy"`
	// Status information on the statefulSet
	StatusInfo          `json:"statusInfo"`
	ContainerImages     []string `json:"containerImages"`
	InitContainerImages []string `json:"initContainerImages"`
}

// StatusInfo is the status information of the daemonset
type StatusInfo struct {

	// readyReplicas is the number of Pods created by the DaemonSet controller that have a Ready Condition.
	Ready int32 `json:"ready,omitempty"`

	// currentReplicas is the number of Pods created by the DaemonSet controller from the DaemonSet version
	// indicated by currentRevision.
	Current int32 `json:"current,omitempty"`

	// updatedReplicas is the number of Pods created by the DaemonSet controller from the DaemonSet version
	// indicated by updateRevision.
	Updated int32 `json:"updated,omitempty"`
	// Total number of available pods (ready for at least minReadySeconds) targeted by this daemonset.
	// This is an alpha field and requires enabling DaemonSetMinReadySeconds feature gate.
	// Remove omitempty when graduating to beta
	// +optional
	Available int32 `json:"available,omitempty"`

	Unavailable int32 `json:"unavailable"`
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
		Strategy:            daemonSet.Spec.UpdateStrategy,
		StatusInfo:          GetStatusInfo(&daemonSet.Status),
		ContainerImages:     k8scommon.GetContainerImages(&daemonSet.Spec.Template.Spec),
		InitContainerImages: k8scommon.GetInitContainerImages(&daemonSet.Spec.Template.Spec),
	}
}

// GetStatusInfo is used to get the status information from the *apps.DaemonSetStatus
func GetStatusInfo(daemonSetStatus *apps.DaemonSetStatus) StatusInfo {
	return StatusInfo{
		Updated:     daemonSetStatus.UpdatedNumberScheduled,
		Available:   daemonSetStatus.NumberAvailable,
		Ready:       daemonSetStatus.NumberReady,
		Current:     daemonSetStatus.CurrentNumberScheduled,
		Unavailable: daemonSetStatus.NumberUnavailable,
	}
}

func DeleteCollectionDaemonSet(client *kubernetes.Clientset, daemonSetList []k8s.DaemonSetData) (err error) {
	common.LOG.Info("批量删除daemonset开始")
	for _, v := range daemonSetList {
		common.LOG.Info(fmt.Sprintf("delete statefulset：%v, ns: %v", v.Name, v.Namespace))
		err := client.AppsV1().DaemonSets(v.Namespace).Delete(
			context.TODO(),
			v.Name,
			metav1.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除daemonset已完成")
	return nil
}

func DeleteDaemonSet(client *kubernetes.Clientset, namespace, name string) (err error) {
	common.LOG.Info(fmt.Sprintf("请求删除单个daemonset：%v, namespace: %v", name, namespace))
	return client.AppsV1().DaemonSets(namespace).Delete(
		context.TODO(),
		name,
		metav1.DeleteOptions{},
	)
}

func RestartDaemonSet(client *kubernetes.Clientset, namespace, name string) (err error) {
	common.LOG.Info(fmt.Sprintf("下发应用重启指令, 名称空间：%v, 守护进程集：%v", namespace, name))
	data := fmt.Sprintf(`{"spec":{"template":{"metadata":{"annotations":{"kubectl.kubernetes.io/restartedAt":"%s"}}}}}`, time.Now().String())
	_, err = client.AppsV1().DaemonSets(namespace).Patch(
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
