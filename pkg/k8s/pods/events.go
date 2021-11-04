package pods

import (
	"k8s.io/client-go/kubernetes"
	"pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
)

// GetEventsForPod gets events that are associated with this pod.
func GetEventsForPod(client *kubernetes.Clientset, dsQuery *dataselect.DataSelectQuery, namespace, podName string) (*common.EventList, error) {
	return event.GetResourceEvents(client, dsQuery, namespace, podName)
}
