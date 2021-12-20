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
	"time"
)

//
const (
	AliYun  string = "aliyun"
	Tencent string = "tencent"
	HuaWei  string = "huawei"
	AWS     string = "aws"
)

// SupportedCloudVendors 实现了相应的云厂商插件
var SupportedCloudVendors = []string{AliYun, Tencent, HuaWei, AWS}

// 云同步任务同步状态
const (
	CloudSyncSuccess    string = "cloud_sync_success"
	CloudSyncFail       string = "cloud_sync_fail"
	CloudSyncInProgress string = "cloud_sync_in_progress"
)

// Region 云资产地域信息
type Region struct {
	RegionId   string `json:"region"`
	RegionName string `json:"region_name"`
	Type       string `json:"type"`
	Enable     bool   `json:"enable"`
}

type CloudPlatform struct {
	ID        int              `json:"id" gorm:"column:id;AUTO_INCREMENT;comment:主键"`
	Name      string           `json:"name"`
	Type      string           `json:"type"`
	AccessKey string           `json:"access_key"`
	SecretKey string           `json:"secret_key"`
	Region    string           `json:"region"`
	Remark    string           `json:"remark"`
	Status    int              `json:"status"`
	Msg       string           `json:"msg"`
	Enable    bool             `json:"enable"`
	CreatedAt models.LocalTime `json:"created_at"`
	DeletedAt gorm.DeletedAt   `json:"-"`
	UpdatedAt models.LocalTime `json:"updated_at"`
	SyncTime  *time.Time       `json:"sync_time"`
	//VirtualMachines []*VirtualMachine `gorm:"many2many:cloud_platform_virtual_machines;"`
}

func (c CloudPlatform) TableName() string {
	return "cloud_platform"
}

type VirtualMachine struct {
	ID int `json:"id" gorm:"not null;primary_key"`
	//Platform      CloudPlatform    `gorm:"-" json:"platform"`
	Groups        []*TreeMenu      `gorm:"many2many:hosts_group_virtual_machines" json:"groups"`
	UUID          string           `json:"uuid"`
	HostName      string           `gorm:"comment:'主机名';column:hostname" json:"hostname"`
	CPU           int              `gorm:"comment:'CPU'" json:"cpu"`
	Mem           int              `gorm:"comment:'内存'" json:"memory"` // MB
	OS            string           `gorm:"comment:'操作系统'" json:"os"`
	OSType        string           `gorm:"comment:'系统类型'" json:"os_type"`
	MacAddr       string           `gorm:"comment:'物理地址'" json:"mac_addr"`
	PrivateAddr   string           `gorm:"comment:'私网地址'" json:"private_addr"`
	PublicAddr    string           `gorm:"comment:'公网地址'" json:"public_addr"`
	SN            string           `gorm:"comment:'SN序列号'" json:"sn"`
	BandWidth     int              `gorm:"comment:'带宽';column:bandwidth" json:"bandwidth"` // MB
	Status        string           `json:"status"`
	Region        string           `gorm:"comment:'机房'" json:"region"`
	Source        string           `json:"source"`
	VmCreatedTime string           `json:"vm_created_time"`
	VmExpiredTime string           `json:"vm_expired_time"`
	CreatedAt     models.LocalTime `json:"created_at"`
	DeletedAt     gorm.DeletedAt   `json:"-"`
	UpdatedAt     models.LocalTime `json:"updated_at"`
}

func (v VirtualMachine) TableName() string {
	return "cloud_virtual_machine"
}
