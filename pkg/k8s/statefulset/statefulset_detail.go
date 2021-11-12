package statefulset

import (
	"context"
	"fmt"
	apps "k8s.io/api/apps/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	k8scommon "pigs/pkg/k8s/common"
)

// StatefulSetDetail is a presentation layer view of Kubernetes Stateful Set resource. This means it is Stateful
type StatefulSetDetail struct {
	// Extends list item structure.
	StatefulSet `json:",inline"`
}

// GetStatefulSetDetail gets Stateful Set details.
func GetStatefulSetDetail(client *kubernetes.Clientset, namespace, name string) (*StatefulSetDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s statefulset in %s namespace", name, namespace))

	ss, err := client.AppsV1().StatefulSets(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	podInfo, err := getStatefulSetPodInfo(client, ss)
	if err != nil {
		return nil, err
	}

	ssDetail := getStatefulSetDetail(ss, podInfo)
	return &ssDetail, nil
}

func getStatefulSetDetail(statefulSet *apps.StatefulSet, podInfo *k8scommon.PodInfo) StatefulSetDetail {
	return StatefulSetDetail{
		StatefulSet: toStatefulSet(statefulSet, podInfo),
	}
}
