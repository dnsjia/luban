package storageclass

import (
	storage "k8s.io/api/storage/v1"
	"pigs/pkg/k8s/dataselect"
)

// The code below allows to perform complex data section on []storage.StorageClass

type StorageClassCell storage.StorageClass

func (self StorageClassCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
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

func toCells(std []storage.StorageClass) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = StorageClassCell(std[i])
	}
	return cells
}

func fromCells(cells []dataselect.DataCell) []storage.StorageClass {
	std := make([]storage.StorageClass, len(cells))
	for i := range std {
		std[i] = storage.StorageClass(cells[i].(StorageClassCell))
	}
	return std
}
