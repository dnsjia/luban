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
	"github.com/dnsjia/luban/models"
	"gorm.io/gorm"
)

type SSHRecord struct {
	gorm.Model
	ConnectID   string           `gorm:"comment:'连接标识';size:64" json:"connect_id"`
	UserName    string           `gorm:"comment:'系统用户名';size:128" json:"user_name"`
	HostName    string           `gorm:"comment:'主机名';size:128" json:"host_name"`
	ConnectTime models.LocalTime `gorm:"index;comment:'接入时间'" json:"connect_time"`
	LogoutTime  models.LocalTime `gorm:"index;comment:'注销时间'" json:"logout_time"`
	Records     []byte           `json:"records" gorm:"type:longblob;comment:'操作记录(二进制存储)';size:128"`
	HostId      uint             `gorm:"comment:'主机Id外键'" json:"host_id"`
	Host        VirtualMachine   `gorm:"foreignkey:HostId" json:"host"`
}

func (s SSHRecord) TableName() string {
	return "ssh_record"
}
