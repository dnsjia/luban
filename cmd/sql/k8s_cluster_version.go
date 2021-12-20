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

package sql

import (
	"github.com/dnsjia/luban/models"
	"github.com/gookit/color"
	"gorm.io/gorm"
	"os"
)

var t models.LocalTime

var Version = []models.ClusterVersion{
	{GModel: models.GModel{ID: 1, CreatedAt: t, UpdatedAt: t}, Version: "v1.18.11"},
	{GModel: models.GModel{ID: 2, CreatedAt: t, UpdatedAt: t}, Version: "v1.18.12"},
}

func InitK8sClusterVersion(db *gorm.DB) {
	if err := db.Transaction(func(tx *gorm.DB) error {
		if tx.Where("id IN ?", []int{1, 2}).Find(&[]models.ClusterVersion{}).RowsAffected == 2 {
			color.Danger.Println("k8s_cluster_version表初始数据已存在!")
			return nil
		}
		if err := tx.Create(&Version).Error; err != nil { // 遇到错误时回滚事务
			return err
		}
		return nil
	}); err != nil {
		color.Warn.Printf("[mysql]--> k8s_cluster_version 表的初始数据失败,err: %v\n", err)
		os.Exit(0)
	}
}
