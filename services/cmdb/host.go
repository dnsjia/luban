package cmdb

import (
	"pigs/common"
	scmdb "pigs/models/cmdb"
)

type v2 struct {
	v3 scmdb.VirtualMachine
}

func (v *v2) CreateOrUpdate(h []scmdb.VirtualMachine) error {
	if common.DB.First(v).RowsAffected == 0 {
		if err := common.DB.Create(&v); err != nil {
			return err.Error
		}
		return nil
	}
	if err := common.DB.Save(&v); err != nil {
		return err.Error
	}
	return nil
}
