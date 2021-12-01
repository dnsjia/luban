package pods

import (
	"github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/event"
	"k8s.io/client-go/kubernetes"
)

// GetEventsForPod gets events that are associated with this pod.
func GetEventsForPod(client *kubernetes.Clientset, dsQuery *dataselect.DataSelectQuery, namespace, podName string) (*common.EventList, error) {
	return event.GetResourceEvents(client, dsQuery, namespace, podName)
}
