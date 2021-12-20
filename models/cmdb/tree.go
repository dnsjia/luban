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

type TreeMenu struct {
	ID              int               `gorm:"not null;primary_key; AUTO_INCREMENT" json:"id"`
	Name            string            `gorm:"type:varchar(32); not null" json:"name"`
	ParentId        int64             `gorm:"default:0" json:"parent_id"`
	Hide            int               `gorm:"default:0" json:"hide"`
	SortId          int               `json:"sort_id"`
	VirtualMachines []*VirtualMachine `gorm:"many2many:hosts_group_virtual_machines" json:"cloud_virtual_machine"`
}

func (t TreeMenu) TableName() string {
	return "hosts_group"
}

type TreeData struct {
	Key      string      `json:"key"`
	Value    string      `json:"value"`
	Title    string      `json:"title"`
	Name     string      `json:"name"`
	Children interface{} `json:"children"`
}
