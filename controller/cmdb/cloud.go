package cmdb

import (
	"encoding/json"
	"fmt"
	"github.com/aliyun/alibaba-cloud-sdk-go/services/ecs"
	"pigs/common"
	"pigs/models/cmdb"
)

var (
	ecsList  []ecs.Instance
	dataList []cmdb.VirtualMachine
)

func CloudECS() (err error) {

	client, err := ecs.NewClientWithAccessKey("cn-hangzhou", "", "")

	if err != nil {
		fmt.Printf("创建客户端连接失败，%v", err)
		return
	}

	request := ecs.CreateDescribeInstancesRequest()
	request.PageSize = "1"

	response, err := client.DescribeInstances(request)
	if err != nil {
		fmt.Printf("查询ECS实例列表失败，%v", err)
		return
	}

	if response.TotalCount > 0 {
		for i := 0; i < response.TotalCount/100+1; i++ {
			request.PageSize = "100"
			r, err := client.DescribeInstances(request)
			if err != nil {
				fmt.Printf("查询ECS实例列表失败，%v", err)
				return err
			}
			ecsList = append(ecsList, r.Instances.Instance...)
		}
	}

	// 格式化数据
	for _, v := range ecsList {
		_, err := json.Marshal(v)
		if err != nil {
			fmt.Printf("序列化ecs数据失败，%v", err)
			return err
		}

		var tree []*cmdb.TreeMenu
		group := append(tree, &cmdb.TreeMenu{ID: 1})
		InstanceData(group, v)
	}

	if err := common.DB.Create(&dataList).Error; err != nil {
		fmt.Println("插入失败", err)
		return err
	}
	return

}

// getInstanceIP 获取实例IP
func getInstanceIP(ip []string) string {
	if len(ip) == 0 {
		return ""
	} else {
		return ip[0]
	}
}

func InstanceData(group []*cmdb.TreeMenu, e ecs.Instance) {
	if e.InstanceNetworkType == "vpc" {
		dataList = append(dataList, cmdb.VirtualMachine{
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
		})
	} else {
		dataList = append(dataList, cmdb.VirtualMachine{
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
		})
	}
}
