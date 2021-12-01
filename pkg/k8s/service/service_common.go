package service

import (
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	v1 "k8s.io/api/core/v1"
)

// The code below allows to perform complex data section on []api.Service

type ServiceCell v1.Service

func (self ServiceCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
	switch name {
	case dataselect.NameProperty:
		return dataselect.StdComparableString(self.ObjectMeta.Name)
	case dataselect.CreationTimestampProperty:
		return dataselect.StdComparableTime(self.ObjectMeta.CreationTimestamp.Time)
	case dataselect.NamespaceProperty:
		return dataselect.StdComparableString(self.ObjectMeta.Namespace)
	case dataselect.TypeProperty:
		return dataselect.StdComparableString(self.Spec.Type)
	default:
		// if name is not supported then just return a constant dummy value, sort will have no effect.
		return nil
	}
}

func toCells(std []v1.Service) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = ServiceCell(std[i])
	}
	return cells
}

func fromCells(cells []dataselect.DataCell) []v1.Service {
	std := make([]v1.Service, len(cells))
	for i := range std {
		std[i] = v1.Service(cells[i].(ServiceCell))
	}
	return std
}
