package services

import (
	"fmt"
	"pigs/common"
	"pigs/models"
)

func CreateK8SCluster(cluster models.K8SCluster) (err error) {
	err = common.GVA_DB.Create(&cluster).Error
	return
}

func ListK8SCluster(cluster *[]models.K8SCluster) (err error) {

	result := common.GVA_DB.Find(&cluster)
	fmt.Printf("条数:%d", result.RowsAffected)
	return
}
