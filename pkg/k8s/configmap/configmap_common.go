package configmap

import (
	api "k8s.io/api/core/v1"
	"pigs/pkg/k8s/dataselect"
)

// The code below allows to perform complex data section on []api.ConfigMap

type ConfigMapCell api.ConfigMap

func (self ConfigMapCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
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

func toCells(std []api.ConfigMap) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = ConfigMapCell(std[i])
	}
	return cells
}

func fromCells(cells []dataselect.DataCell) []api.ConfigMap {
	std := make([]api.ConfigMap, len(cells))
	for i := range std {
		std[i] = api.ConfigMap(cells[i].(ConfigMapCell))
	}
	return std
}
