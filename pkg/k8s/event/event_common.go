package event

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

// FailedReasonPartials  is an array of partial strings to correctly filter warning events.
// Have to be lower case for correct case insensitive comparison.
// Based on k8s official events reason file:
// https://github.com/kubernetes/kubernetes/blob/886e04f1fffbb04faf8a9f9ee141143b2684ae68/pkg/kubelet/events/event.go
// Partial strings that are not in event.go file are added in order to support
// older versions of k8s which contained additional event reason messages.
var FailedReasonPartials = []string{"failed", "err", "exceeded", "invalid", "unhealthy",
	"mismatch", "insufficient", "conflict", "outof", "nil", "backoff"}

// GetNodeEvents gets events associated to node with given name.
func GetNodeEvents(client *kubernetes.Clientset, nodeName string) (*v1.EventList, error) {

	//scheme := runtime.NewScheme()
	//groupVersion := schema.GroupVersion{Group: "", Version: "v1"}
	//scheme.AddKnownTypes(groupVersion, &v1.Node{})
	//
	//node, err := client.CoreV1().Nodes().Get(context.TODO(), nodeName, metaV1.GetOptions{})
	//
	//if err != nil {
	//	return nil, err
	//}
	events, err := client.CoreV1().Events(v1.NamespaceAll).List(context.TODO(),
		metaV1.ListOptions{FieldSelector: fmt.Sprintf("involvedObject.name=%v", nodeName)})

	//events, err := client.CoreV1().Events(v1.NamespaceAll).Search(scheme, node)

	if err != nil {
		return nil, err
	}

	return events, nil
}

// FillEventsType is based on event Reason fills event Type in order to allow correct filtering by Type.
func FillEventsType(events []v1.Event) []v1.Event {
	for i := range events {
		// Fill in only events with empty type.
		if len(events[i].Type) == 0 {
			if isFailedReason(events[i].Reason, FailedReasonPartials...) {
				events[i].Type = v1.EventTypeWarning
			} else {
				events[i].Type = v1.EventTypeNormal
			}
		}
	}

	return events
}
