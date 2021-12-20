package cloudvendor

import (
	"fmt"
	"github.com/dnsjia/luban/models/cmdb"
)

var vendorClients = make(map[string]VendorClient, 0)

type VendorClient interface {
	// NewVendorClient 创建云厂商客户端
	NewVendorClient(secretID, secretKey string) VendorClient
	// GetRegions 获取地域列表
	GetRegions() ([]*cmdb.Region, error)
	// GetInstances 获取实例列表
	GetInstances(region string) ([]cmdb.VirtualMachine, error)
}

// Register 注册云厂商客户端
func Register(vendorName string, client VendorClient) {
	vendorClients[vendorName] = client
}

// GetVendorClient 获取云厂商客户端
func GetVendorClient(conf *cmdb.CloudPlatform) (VendorClient, error) {
	var client VendorClient
	var ok bool
	if client, ok = vendorClients[conf.Type]; !ok {
		return nil, fmt.Errorf("vendor %s is not supported", conf.Type)
	}
	cli := client.NewVendorClient(conf.AccessKey, conf.SecretKey)
	return cli, nil
}
