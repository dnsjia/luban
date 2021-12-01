package services

import (
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/cmdb"
	"github.com/dnsjia/luban/models/request"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// ListPlatform 云平台信息
func ListPlatform(info request.PageInfo) (err error, list interface{}, total int64) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)

	var platformList []cmdb.CloudPlatform
	err = common.DB.Find(&platformList).Count(&total).Error
	err = common.DB.Limit(limit).Offset(offset).Find(&platformList).Error
	return err, platformList, total
}

// CreateCloudAccount 创建云账号
func CreateCloudAccount(account *cmdb.CloudPlatform) (err error) {

	results := common.DB.Table("cloud_platform").Where("access_key = ?", &account.AccessKey).First(&account)

	if results.Error != nil {
		if results.Error == gorm.ErrRecordNotFound {
			results := common.DB.Table("cloud_platform").Create(&account)
			if results.Error != nil {
				common.LOG.Error("创建云平台账号失败", zap.Any("err", results.Error))
				return results.Error
			}
		}
	} else {
		results := common.DB.Table("cloud_platform").Model(&account).Updates(map[string]interface{}{
			"name":       &account.Name,
			"access_key": &account.AccessKey,
			"secret_key": &account.SecretKey,
			"remark":     &account.Remark,
		})
		if results.Error != nil {
			common.LOG.Error("更新云平台账号失败", zap.Any("err", results.Error))
			return results.Error
		}
	}

	return nil
}
