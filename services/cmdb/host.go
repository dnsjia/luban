/*
Copyright 2021 The DnsJia Authors.
WebSite:  https://github.com/dnsjia/luban
Email:    OpenSource@dnsjia.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package cmdb

import (
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models"
	"github.com/dnsjia/luban/models/cmdb"
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
