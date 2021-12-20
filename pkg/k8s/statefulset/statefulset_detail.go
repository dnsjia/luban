package statefulset

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/event"
	"github.com/dnsjia/luban/pkg/k8s/service"
	apps "k8s.io/api/apps/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

// StatefulSetDetail is a presentation layer view of Kubernetes Stateful Set resource. This means it is Stateful
type StatefulSetDetail struct {
	// Extends list item structure.
	StatefulSet `json:",inline"`

	Events *k8scommon.EventList `json:"events"`

	PodList *PodList `json:"podList"`

	SvcList *service.ServiceList `json:"svcList"`
}

// GetStatefulSetDetail gets Stateful Set details.
func GetStatefulSetDetail(client *kubernetes.Clientset, dsQuery *dataselect.DataSelectQuery, namespace, name string) (*StatefulSetDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s statefulset in %s namespace", name, namespace))

	ss, err := client.AppsV1().StatefulSets(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	podInfo, err := getStatefulSetPodInfo(client, ss)
	if err != nil {
		return nil, err
	}
	events, err := event.GetResourceEvents(client, dsQuery, namespace, name)
	if err != nil {
		return nil, err
	}

	serviceList, _ := service.GetToService(client, namespace, name)
	ssDetail := getStatefulSetDetail(ss, podInfo, events, serviceList, client)
	return &ssDetail, nil
}

func getStatefulSetDetail(statefulSet *apps.StatefulSet, podInfo *k8scommon.PodInfo,
	events *k8scommon.EventList, svc *service.ServiceList, client *kubernetes.Clientset) StatefulSetDetail {

	return StatefulSetDetail{
		StatefulSet: toStatefulSet(statefulSet, podInfo),
		Events:      events,
		PodList:     getStatefulSetToPod(client, statefulSet),
		SvcList:     svc,
	}
}
