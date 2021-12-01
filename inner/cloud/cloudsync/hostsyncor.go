package cloudsync

import (
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/inner/cloud/cloudvendor"
	"github.com/dnsjia/luban/models/cmdb"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

var (
	aliClient cloudvendor.VendorClient
)

// SyncAliYunHost 同步阿里云主机
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
		// 获取所有区域下的ecs主机
		instancesInfo, err := aliClient.GetInstances(region.RegionId)
		if err != nil {
			common.LOG.Error(fmt.Sprintf("同步资产发生错误, err: %v", err))
		}
		// 判断区域下是否有ecs
		if len(instancesInfo) != 0 {
			for _, i := range instancesInfo {
				// 根据主机实例id获取db中的主机信息,并获取有差异的主机
				diffHosts, _ := getDiffHosts(&i)
				if len(diffHosts) != 0 {
					// 有差异的更新任务状态为同步中
					//updateTaskState(diffHosts)

					// 同步有差异的主机数据
					syncDiffHosts(diffHosts)
				}
			}
		}
	}
	return
}

// getDiffHosts 根据主机实例id获取db中的主机信息,并获取有差异的主机
func getDiffHosts(remoteHosts *cmdb.VirtualMachine) (map[string][]*cmdb.VirtualMachine, error) {
	// 本地已有主机
	localHosts, _ := getLocalHosts(remoteHosts)

	localIdHostsMap := make(map[string]*cmdb.VirtualMachine)
	for _, h := range localHosts {
		localIdHostsMap[h.UUID] = h
	}

	// 有差异的主机
	diffHosts := make(map[string][]*cmdb.VirtualMachine)

	// 本地需要同步新增和更新的主机
	if _, ok := localIdHostsMap[remoteHosts.UUID]; ok {
		lh := localIdHostsMap[remoteHosts.UUID]
		// 判断云主机和本地主机是否有差异，有则需要更新
		if remoteHosts.HostName != lh.HostName || remoteHosts.PublicAddr != lh.PublicAddr ||
			remoteHosts.PrivateAddr != lh.PrivateAddr || remoteHosts.VmExpiredTime != lh.VmExpiredTime ||
			remoteHosts.Status != lh.Status || remoteHosts.Mem != lh.Mem || remoteHosts.CPU != lh.CPU ||
			remoteHosts.BandWidth != lh.BandWidth {
			diffHosts["update"] = append(diffHosts["update"], remoteHosts)
		}
	} else {
		diffHosts["add"] = append(diffHosts["add"], remoteHosts)
	}

	return diffHosts, nil
}

// getLocalHosts 获取本地主机
func getLocalHosts(hostResource *cmdb.VirtualMachine) ([]*cmdb.VirtualMachine, error) {
	result := make([]*cmdb.VirtualMachine, 0)
	var c cmdb.VirtualMachine

	results := common.DB.Table("cloud_virtual_machine").Where("uuid = ?", hostResource.UUID).First(&c)
	if results.Error != nil {
		if results.Error == gorm.ErrRecordNotFound {
			return nil, gorm.ErrRecordNotFound
		}
	}
	result = append(result, &c)
	return result, nil
}

// addHost 添加云主机
func addHost(hostResource []*cmdb.VirtualMachine) error {
	if err := common.DB.Create(&hostResource); err != nil {
		return err.Error
	}
	return nil
}

// syncDiffHosts 更新变化的主机
func syncDiffHosts(diff map[string][]*cmdb.VirtualMachine) {

	for k, v := range diff {
		switch k {
		case "update":
			for _, host := range v {
				// HostName、PublicAddr、PrivateAddr、VmExpiredTime、Status、Mem、CPU、BandWidth
				results := common.DB.Table("cloud_virtual_machine").
					Where("uuid = ?", &host.UUID).Updates(map[string]interface{}{
					"hostname":        &host.HostName,
					"public_addr":     &host.PublicAddr,
					"private_addr":    &host.PrivateAddr,
					"vm_expired_time": &host.VmExpiredTime,
					"status":          &host.Status,
					"mem":             &host.Mem,
					"cpu":             &host.CPU,
					"bandwidth":       &host.BandWidth,
				})
				if results.Error != nil {
					common.LOG.Error("更新主机资源失败", zap.Any("err", results.Error))
				}
			}
		case "add":
			if err := addHost(v); err != nil {
				common.LOG.Error("同步新增主机失败", zap.Any("err", err.Error()))
			}
		}
	}
}
