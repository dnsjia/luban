package cloudvendor

import (
	"fmt"
	"github.com/aliyun/alibaba-cloud-sdk-go/services/ecs"
	"pigs/models/cmdb"
)

func init() {
	Register(cmdb.AliYun, &aliClient{vendorName: cmdb.AliYun})
}

type aliClient struct {
	vendorName string
	secretID   string
	secretKey  string
}

const (
	MinPageSize int64 = 1
	MaxPageSize int64 = 100
)

// NewVendorClient 创建云厂商客户端
func (a *aliClient) NewVendorClient(secretID, secretKey string) VendorClient {
	return &aliClient{
		vendorName: cmdb.AliYun,
		secretID:   secretID,
		secretKey:  secretKey,
	}
}

// GetRegions 获取地域列表
// API文档：https://help.aliyun.com/document_detail/25609.html
func (a *aliClient) GetRegions() ([]*cmdb.Region, error) {
	client, err := ecs.NewClientWithAccessKey("hangzhou", a.secretID, a.secretKey)
	if err != nil {
		return nil, err
	}

	request := ecs.CreateDescribeRegionsRequest()
	resp, err := client.DescribeRegions(request)
	if err != nil {
		return nil, err
	}

	regionSet := make([]*cmdb.Region, 0)
	for _, region := range resp.Regions.Region {
		regionSet = append(regionSet, &cmdb.Region{
			RegionId:   region.RegionId,
			RegionName: region.LocalName,
		})
	}
	fmt.Println(regionSet)
	return regionSet, nil
}
