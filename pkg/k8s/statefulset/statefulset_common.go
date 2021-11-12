package statefulset

import (
	apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	"pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
)

// The code below allows to perform complex data section on []apps.StatefulSet

type StatefulSetCell apps.StatefulSet

func (self StatefulSetCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
	switch name {
	case dataselect.NameProperty:
		return dataselect.StdComparableString(self.ObjectMeta.Name)
	case dataselect.CreationTimestampProperty:
		return dataselect.StdComparableTime(self.ObjectMeta.CreationTimestamp.Time)
	case dataselect.NamespaceProperty:
		return dataselect.StdComparableString(self.ObjectMeta.Namespace)
	default:
		// if name is not supported then just return a constant dummy value, sort will have no effect.
		return nil
	}
}

func toCells(std []apps.StatefulSet) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = StatefulSetCell(std[i])
	}
	return cells
}

func fromCells(cells []dataselect.DataCell) []apps.StatefulSet {
	std := make([]apps.StatefulSet, len(cells))
	for i := range std {
		std[i] = apps.StatefulSet(cells[i].(StatefulSetCell))
	}
	return std
}

func getStatus(list *apps.StatefulSetList, pods []v1.Pod, events []v1.Event) common.ResourceStatus {
	info := common.ResourceStatus{}
	if list == nil {
		return info
	}

	for _, ss := range list.Items {
		matchingPods := common.FilterPodsByControllerRef(&ss, pods)
		podInfo := common.GetPodInfo(ss.Status.Replicas, ss.Spec.Replicas, matchingPods)
		warnings := event.GetPodsEventWarnings(events, matchingPods)

		if len(warnings) > 0 {
			info.Failed++
		} else if podInfo.Pending > 0 {
			info.Pending++
		} else {
			info.Running++
		}
	}

	return info
}
