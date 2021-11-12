package cloudsync

import (
	"fmt"
	"pigs/common"
	"pigs/common/cloud/cloudvendor"
	"pigs/models/cmdb"
)

var (
	aliClient cloudvendor.VendorClient
)

func SyncAliYunHost(task *cmdb.CloudPlatform) {
	defer func() {
		if err := recover(); err != nil {
			common.LOG.Error(fmt.Sprintf("sync panic err: %v", err))
		}
	}()

	// 获取cloud账户
	conf := cmdb.CloudPlatform{
		Type:      cmdb.AliYun,
		AccessKey: task.AccessKey,
		SecretKey: task.SecretKey,
	}

	aliClient, _ = cloudvendor.GetVendorClient(&conf)

	// 获取所有可用区
	regionSet, _ := aliClient.GetRegions()
	for _, region := range regionSet {
		// 获取所有区域ecs
		instancesInfo, err := aliClient.GetInstances(region.RegionId)
		if err != nil {
			common.LOG.Error(fmt.Sprintf("同步资产发生错误, err: %v", err))
		}

		if len(instancesInfo) == 0 {
			common.LOG.Error(fmt.Sprintf("hostResource is empty, region: %v %v",
				region.RegionId,
				region.RegionName))
		} else {
			if err := common.DB.Create(&instancesInfo).Error; err != nil {
				common.LOG.Error(fmt.Sprintf("插入失败, err: %v", err))
			}
		}
	}
}
