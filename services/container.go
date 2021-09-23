package services

import (
	"pigs/common"
	"pigs/model"
)

func CreateK8SCluster(cluster model.K8SCluster) (err error) {
	err = common.GVA_DB.Create(&cluster).Error
	return
}
