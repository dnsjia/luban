package cloudvendor

import (
	"fmt"
	"github.com/aliyun/alibaba-cloud-sdk-go/sdk/requests"
	"github.com/aliyun/alibaba-cloud-sdk-go/services/ecs"
	"github.com/dnsjia/luban/models/cmdb"
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
	MinPageSize requests.Integer = "1"
	MaxPageSize requests.Integer = "100"
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
	client, err := ecs.NewClientWithAccessKey("cn-hangzhou", a.secretID, a.secretKey)
	if err != nil {
		return nil, err
	}

	request := ecs.CreateDescribeRegionsRequest()
	request.Scheme = "https"

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
	return regionSet, nil
}

// getInstanceIP 获取实例IP
func getInstanceIP(ip []string) string {
	if len(ip) == 0 {
		return ""
	} else {
		return ip[0]
	}
}

// GetInstances 获取实例列表
// API文档：https://help.aliyun.com/document_detail/25506.html
func (a *aliClient) GetInstances(region string) ([]cmdb.VirtualMachine, error) {
	client, err := ecs.NewClientWithAccessKey(region, a.secretID, a.secretKey)

	if err != nil {
		fmt.Printf("创建客户端连接失败，%v", err.Error())
		return nil, err
	}

	request := ecs.CreateDescribeInstancesRequest()
	request.PageSize = MinPageSize

	response, err := client.DescribeInstances(request)
	if err != nil {
		fmt.Printf("查询ECS实例列表失败，%v", err.Error())
		return nil, err
	}

	var (
		ecsList       []ecs.Instance
		instancesInfo []cmdb.VirtualMachine
	)

	// 设置分页请求参数
	if response.TotalCount > 0 {
		for i := 0; i < response.TotalCount/100+1; i++ {
			request.PageSize = MaxPageSize
			r, err := client.DescribeInstances(request)
			if err != nil {
				fmt.Printf("查询ECS实例列表失败，%v", err)
				return nil, err
			}
			ecsList = append(ecsList, r.Instances.Instance...)
		}
	}

	// 同步的云资产放到默认的Default分组
	for _, e := range ecsList {
		var tree []*cmdb.TreeMenu
		group := append(tree, &cmdb.TreeMenu{ID: 1})

		if e.InstanceNetworkType == "vpc" {
			instancesInfo = append(instancesInfo, cmdb.VirtualMachine{
				Groups:        group,
				UUID:          e.InstanceId,
				HostName:      e.InstanceName,
				CPU:           e.Cpu,
				Mem:           e.Memory,
				OS:            e.OSNameEn,
				OSType:        e.OSType,
				PrivateAddr:   getInstanceIP(e.VpcAttributes.PrivateIpAddress.IpAddress),
				PublicAddr:    getInstanceIP(e.PublicIpAddress.IpAddress),
				SN:            e.SerialNumber,
				BandWidth:     e.InternetMaxBandwidthOut,
				Status:        e.Status,
				Region:        e.ZoneId,
				VmCreatedTime: e.CreationTime,
				VmExpiredTime: e.ExpiredTime,
				Source:        "aliyun",
			})
		} else {
			instancesInfo = append(instancesInfo, cmdb.VirtualMachine{
				Groups:        group,
				UUID:          e.InstanceId,
				HostName:      e.InstanceName,
				CPU:           e.Cpu,
				Mem:           e.Memory,
				OS:            e.OSNameEn,
				OSType:        e.OSType,
				PrivateAddr:   getInstanceIP(e.InnerIpAddress.IpAddress),
				PublicAddr:    getInstanceIP(e.PublicIpAddress.IpAddress),
				SN:            e.SerialNumber,
				BandWidth:     e.InternetMaxBandwidthOut,
				Status:        e.Status,
				Region:        e.ZoneId,
				VmCreatedTime: e.CreationTime,
				VmExpiredTime: e.ExpiredTime,
				Source:        "aliyun",
			})
		}

	}

	return instancesInfo, nil

}
