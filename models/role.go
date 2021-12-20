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

type Role struct {
	GModel
	Name  string `gorm:"column:name;comment:'角色名称';size:128" json:"name"`
	Desc  string `gorm:"column:desc;comment:'角色描述';size:128" json:"desc"`
	Menus []Menu `gorm:"many2many:relation_role_menu" json:"menus"`
	Users []User `gorm:"foreignkey:RoleId"`
}

func (m Role) TableName() string {
	return m.GModel.TableName("role")
}
