package secret

import (
	api "k8s.io/api/core/v1"
	"pigs/pkg/k8s/dataselect"
)

// The code below allows to perform complex data section on []api.Secret

type SecretCell api.Secret

func (self SecretCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
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

func toCells(std []api.Secret) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = SecretCell(std[i])
	}
	return cells
}

func fromCells(cells []dataselect.DataCell) []api.Secret {
	std := make([]api.Secret, len(cells))
	for i := range std {
		std[i] = api.Secret(cells[i].(SecretCell))
	}
	return std
}
