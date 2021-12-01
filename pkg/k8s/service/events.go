package service

import (
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/k8s"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/event"
	client "k8s.io/client-go/kubernetes"
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
