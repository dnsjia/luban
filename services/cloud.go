package services

import (
	"pigs/common"
	"pigs/models/cmdb"
	"pigs/models/request"
)

func ListPlatform(info request.PageInfo) (err error, list interface{}, total int64) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := common.DB
	var platformList []cmdb.CloudPlatform
	err = db.Find(&platformList).Count(&total).Error
	err = db.Limit(limit).Offset(offset).Find(&platformList).Error
	return err, platformList, total
}
