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

type Menu struct {
	GModel
	Name     string `gorm:"comment:'菜单名称';size:64" json:"name"`
	Icon     string `gorm:"comment:'菜单图标';size:64" json:"icon"`
	Path     string `gorm:"comment:'菜单访问路径';size:64" json:"path"`
	Sort     int    `gorm:"default:0;type:int(3);comment:'菜单顺序(同级菜单, 从0开始, 越小显示越靠前)'" json:"sort"`
	ParentId uint   `gorm:"default:0;comment:'父菜单编号(编号为0时表示根菜单)'" json:"parent_id"`
	Creator  string `gorm:"comment:'创建人';size:64" json:"creator"`
	Children []Menu `gorm:"-" json:"children"`
	Roles    []Role `gorm:"many2many:relation_role_menu;" json:"roles"`
}

func (m Menu) TableName() string {
	return m.GModel.TableName("menu")
}
