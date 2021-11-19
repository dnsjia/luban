package ingress

import (
	v1 "k8s.io/api/extensions/v1beta1"
	"pigs/pkg/k8s/dataselect"
)

// The code below allows to perform complex data section on []extensions.Ingress

type IngressCell v1.Ingress

func (self IngressCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
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

func toCells(std []v1.Ingress) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = IngressCell(std[i])
	}
	return cells
}

func fromCells(cells []dataselect.DataCell) []v1.Ingress {
	std := make([]v1.Ingress, len(cells))
	for i := range std {
		std[i] = v1.Ingress(cells[i].(IngressCell))
	}
	return std
}
