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

package models

type Dept struct {
	GModel
	Name     string `gorm:"comment:'部门名称';size:64" json:"name"`
	Sort     int    `gorm:"default:0;type:int(3);comment:'排序'" json:"sort"`
	ParentId uint   `gorm:"default:0;comment:'父级部门(编号为0时表示根)'" json:"parent_id"`
	Children []Dept `gorm:"-" json:"children"` // 下属部门集合
	Users    []User `gorm:"foreignkey:DeptId"` // 一个部门有多个user
}

func (m Dept) TableName() string {
	return m.GModel.TableName("dept")
}
