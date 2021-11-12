package statefulset

import (
	"context"
	"fmt"
	apps "k8s.io/api/apps/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
)

// StatefulSetDetail is a presentation layer view of Kubernetes Stateful Set resource. This means it is Stateful
type StatefulSetDetail struct {
	// Extends list item structure.
	StatefulSet `json:",inline"`
	Events      *k8scommon.EventList `json:"events"`
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

	ssDetail := getStatefulSetDetail(ss, podInfo, events)
	return &ssDetail, nil
}

func getStatefulSetDetail(statefulSet *apps.StatefulSet, podInfo *k8scommon.PodInfo, events *k8scommon.EventList) StatefulSetDetail {
	return StatefulSetDetail{
		StatefulSet: toStatefulSet(statefulSet, podInfo),
		Events:      events,
	}
}
