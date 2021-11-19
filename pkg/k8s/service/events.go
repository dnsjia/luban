package service

import (
	"fmt"
	client "k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
)

// GetServiceEvents returns model events for a service with the given name in the given namespace.
func GetServiceEvents(client *client.Clientset, dsQuery *dataselect.DataSelectQuery, namespace, name string) (*k8scommon.EventList, error) {
	eventList := k8scommon.EventList{
		Events:   make([]k8scommon.Event, 0),
		ListMeta: k8s.ListMeta{TotalItems: 0},
	}

	serviceEvents, err := event.GetEvents(client, namespace, name)
	if err != nil {
		return &eventList, err
	}

	eventList = event.CreateEventList(event.FillEventsType(serviceEvents), dsQuery)
	common.LOG.Info(fmt.Sprintf("Found %d events related to %s service in %s namespace", len(eventList.Events), name, namespace))
	return &eventList, nil
}
