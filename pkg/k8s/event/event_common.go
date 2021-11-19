package event

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/fields"
	"k8s.io/apimachinery/pkg/labels"
	"k8s.io/client-go/kubernetes"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
)

// EmptyEventList is a empty list of events.
var EmptyEventList = &k8scommon.EventList{
	Events: make([]k8scommon.Event, 0),
	ListMeta: k8s.ListMeta{
		TotalItems: 0,
	},
}

// ToEvent converts event api Event to Event model object.
func ToEvent(event v1.Event) k8scommon.Event {
	result := k8scommon.Event{
		ObjectMeta:         k8s.NewObjectMeta(event.ObjectMeta),
		TypeMeta:           k8s.NewTypeMeta(k8s.ResourceKindEvent),
		Message:            event.Message,
		SourceComponent:    event.Source.Component,
		SourceHost:         event.Source.Host,
		SubObject:          event.InvolvedObject.FieldPath,
		SubObjectKind:      event.InvolvedObject.Kind,
		SubObjectName:      event.InvolvedObject.Name,
		SubObjectNamespace: event.InvolvedObject.Namespace,
		Count:              event.Count,
		FirstSeen:          event.FirstTimestamp,
		LastSeen:           event.LastTimestamp,
		Reason:             event.Reason,
		Type:               event.Type,
	}

	return result
}

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

// GetResourceEvents gets events associated to specified resource.
func GetResourceEvents(client *kubernetes.Clientset, dsQuery *dataselect.DataSelectQuery, namespace, name string) (*k8scommon.EventList, error) {
	resourceEvents, err := GetEvents(client, namespace, name)

	if err != nil {
		return EmptyEventList, err
	}

	events := CreateEventList(resourceEvents, dsQuery)
	return &events, nil
}

// CreateEventList converts array of api events to common EventList structure
func CreateEventList(events []v1.Event, dsQuery *dataselect.DataSelectQuery) k8scommon.EventList {
	eventList := k8scommon.EventList{
		Events:   make([]k8scommon.Event, 0),
		ListMeta: k8s.ListMeta{TotalItems: len(events)},
	}

	events = fromCells(dataselect.GenericDataSelect(toCells(events), dsQuery))
	for _, event := range events {
		eventDetail := ToEvent(event)
		eventList.Events = append(eventList.Events, eventDetail)
	}

	return eventList
}

// The code below allows to perform complex data section on []api.Event

type EventCell v1.Event

func (self EventCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
	switch name {
	case dataselect.NameProperty:
		return dataselect.StdComparableString(self.ObjectMeta.Name)
	case dataselect.CreationTimestampProperty:
		return dataselect.StdComparableTime(self.ObjectMeta.CreationTimestamp.Time)
	case dataselect.FirstSeenProperty:
		return dataselect.StdComparableTime(self.FirstTimestamp.Time)
	case dataselect.LastSeenProperty:
		return dataselect.StdComparableTime(self.LastTimestamp.Time)
	case dataselect.NamespaceProperty:
		return dataselect.StdComparableString(self.ObjectMeta.Namespace)
	case dataselect.ReasonProperty:
		return dataselect.StdComparableString(self.Reason)
	default:
		// if name is not supported then just return a constant dummy value, sort will have no effect.
		return nil
	}
}

func toCells(std []v1.Event) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = EventCell(std[i])
	}
	return cells
}

func fromCells(cells []dataselect.DataCell) []v1.Event {
	std := make([]v1.Event, len(cells))
	for i := range std {
		std[i] = v1.Event(cells[i].(EventCell))
	}
	return std
}

// GetEvents gets events associated to resource with given name.
func GetEvents(client *kubernetes.Clientset, namespace, resourceName string) ([]v1.Event, error) {
	fieldSelector, err := fields.ParseSelector("involvedObject.name" + "=" + resourceName)

	if err != nil {
		return nil, err
	}

	channels := &k8scommon.ResourceChannels{
		EventList: k8scommon.GetEventListChannelWithOptions(client, k8scommon.NewSameNamespaceQuery(namespace),
			metaV1.ListOptions{
				LabelSelector: labels.Everything().String(),
				FieldSelector: fieldSelector.String(),
			},
			1),
	}

	eventList := <-channels.EventList.List
	if err := <-channels.EventList.Error; err != nil {
		return nil, err
	}

	return FillEventsType(eventList.Items), nil
}

// GetPodEvents gets pods events associated to pod name and namespace
func GetPodEvents(client *kubernetes.Clientset, namespace, podName string) ([]v1.Event, error) {

	channels := &k8scommon.ResourceChannels{
		PodList:   k8scommon.GetPodListChannel(client, k8scommon.NewSameNamespaceQuery(namespace), 1),
		EventList: k8scommon.GetEventListChannel(client, k8scommon.NewSameNamespaceQuery(namespace), 1),
	}

	podList := <-channels.PodList.List
	if err := <-channels.PodList.Error; err != nil {
		return nil, err
	}

	eventList := <-channels.EventList.List
	if err := <-channels.EventList.Error; err != nil {
		return nil, err
	}

	l := make([]v1.Pod, 0)
	for _, pi := range podList.Items {
		if pi.Name == podName {
			l = append(l, pi)
		}
	}

	events := filterEventsByPodsUID(eventList.Items, l)
	return FillEventsType(events), nil
}

// GetPodsEvents gets events targeting given list of pods.
func GetPodsEvents(client *kubernetes.Clientset, namespace string, pods []v1.Pod) ([]v1.Event, error) {

	nsQuery := k8scommon.NewSameNamespaceQuery(namespace)
	if namespace == v1.NamespaceAll {
		nsQuery = k8scommon.NewNamespaceQuery([]string{})
	}

	channels := &k8scommon.ResourceChannels{
		EventList: k8scommon.GetEventListChannel(client, nsQuery, 1),
	}

	eventList := <-channels.EventList.List
	if err := <-channels.EventList.Error; err != nil {
		return nil, err
	}

	events := filterEventsByPodsUID(eventList.Items, pods)

	return events, nil
}
