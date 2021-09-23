package services

import (
	"pigs/common"
	"pigs/models"
)

func CreateK8SCluster(cluster models.K8SCluster) (err error) {
	err = common.GVA_DB.Create(&cluster).Error
	return
}
