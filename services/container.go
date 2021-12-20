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

package services

import (
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models"
)

func CreateK8SCluster(cluster models.K8SCluster) (err error) {
	err = common.DB.Create(&cluster).Error
	return
}

func ListK8SCluster(p *models.PaginationQ, k *[]models.K8SCluster) (err error) {

	if p.Page < 1 {
		p.Page = 1
	}
	if p.Size < 1 {
		p.Size = 10
	}

	offset := p.Size * (p.Page - 1)
	tx := common.DB
	if p.Keyword != "" {
		tx = common.DB.Where("cluster_name like ?", "%"+p.Keyword+"%").Limit(p.Size).Offset(offset).Find(&k)
	} else {
		tx = common.DB.Limit(p.Size).Offset(offset).Find(&k)

	}

	var total int64
	tx.Count(&total)
	//p.Total = tx.RowsAffected
	p.Total = total
	if err := tx.Error; err != nil {
		return err
	}

	return nil
}

func GetK8sCluster(id uint) (K8sCluster models.K8SCluster, err error) {
	err = common.DB.Where("id = ?", id).First(&K8sCluster).Error
	if err != nil {
		return K8sCluster, err
	}
	return K8sCluster, nil
}

func DelCluster(ids models.ClusterIds) (err error) {
	var k models.K8SCluster

	//if reflect.TypeOf(id.Data).Kind() == reflect.Slice {
	//	s := reflect.ValueOf(id.Data)
	//	for i := 0; i < s.Len(); i++ {
	//		err := common.GVA_DB.Where("id = ?", s.Index(i)).Delete(&models.K8SCluster{})
	//		if err.Error != nil {
	//			fmt.Println("删除出错", err.Error)
	//		}
	//	}
	//}

	err2 := common.DB.Delete(&k, ids.Data)
	if err2.Error != nil {
		return err2.Error
	}
	return nil

}
