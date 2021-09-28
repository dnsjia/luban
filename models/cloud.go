package models

import (
	"gorm.io/gorm"
	"time"
)

type CloudPlatform struct {
	ID              int               `json:"id" gorm:"not null;primary_key"`
	Name            string            `json:"name"`
	Type            string            `json:"type"`
	Addr            string            `json:"addr"`
	AccessKey       string            `json:"access_key"`
	SecrectKey      string            `json:"secrect_key"`
	Region          string            `json:"region"`
	Remark          string            `json:"remark"`
	Status          int               `json:"status"`
	Msg             string            `json:"msg"`
	CreatedAt       LocalTime         `json:"created_at"`
	DeletedAt       gorm.DeletedAt    `json:"-"`
	UpdatedAt       LocalTime         `json:"updated_at"`
	SyncTime        *time.Time        `json:"sync_time"`
	VirtualMachines []*VirtualMachine `gorm:"many2many:cloud_virtual_machines;"`
}

func (c CloudPlatform) TableName() string {
	var k GModel
	return k.TableName("cloudplatform")
}

type VirtualMachine struct {
	ID            int            `json:"id" gorm:"not null;primary_key"`
	Platform      CloudPlatform  `gorm:"-" json:"platform"`
	UUID          string         `json:"uuid"`
	Name          string         `json:"name"`
	CPU           int            `json:"cpu"`
	Mem           int64          `json:"mem"` // MB
	OS            string         `json:"os"`
	PrivateAddrs  string         `json:"private_addrs"`
	PublicAddrs   string         `json:"public_addrs"`
	Status        string         `json:"status"`
	VmCreatedTime string         `json:"vm_created_time"`
	VmExpiredTime string         `json:"vm_expired_time"`
	CreatedAt     LocalTime      `json:"created_at"`
	DeletedAt     gorm.DeletedAt `json:"-"`
	UpdatedAt     LocalTime      `json:"updated_at"`
}

func (v VirtualMachine) TableName() string {
	var k GModel
	return k.TableName("cloud_virtualmachine")
}
