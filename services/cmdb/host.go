package cmdb

import (
	"fmt"
	"pigs/common"
	"pigs/models"
	"pigs/models/cmdb"
	"strconv"
)

func ListVirtualMachine(tree string, p *models.PaginationQ) (host []cmdb.VirtualMachine, err error) {
	var total int64

	if p.Page < 1 {
		p.Page = 1
	}
	if p.Size < 1 {
		p.Size = 10
	}

	offset := p.Size * (p.Page - 1)

	tx := common.DB
	// 判断是否传递资产分组id
	if tree != "" {
		id, err1 := strconv.Atoi(tree)
		if err1 != nil {
			return nil, err1
		}
		// 根据分组id获取资产
		QueryTreeId := cmdb.TreeMenu{ID: id}
		fmt.Println(QueryTreeId)
		n := common.DB.Model(&QueryTreeId).Preload("Groups").Limit(p.Size).Offset(offset).Association("VirtualMachines")
		total = n.Count()

		err := n.Find(&host)
		if err != nil {
			return nil, err
		}
	} else {
		tx = common.DB.Model(&host).Limit(p.Size).Offset(offset).Find(&host)
		tx.Count(&total)
	}

	p.Total = total
	if err := tx.Error; err != nil {
		return nil, err
	}

	return host, nil
}
