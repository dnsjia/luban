package services

import (
	"pigs/common"
	"pigs/models"
)

func CreateK8SCluster(cluster models.K8SCluster) (err error) {
	err = common.GVA_DB.Create(&cluster).Error
	return
}

func ListK8SCluster(p *models.PaginationQ, k *[]models.K8SCluster) (err error) {

	if p.Page < 1 {
		p.Page = 1
	}
	if p.Size < 1 {
		p.Size = 10
	}

	offset := p.Size * (p.Page - 1)
	tx := common.GVA_DB
	if p.Keyword != "" {
		tx = common.GVA_DB.Where("cluster_name like ?", "%"+p.Keyword+"%").Limit(p.Size).Offset(offset).Find(&k)
	} else {
		tx = common.GVA_DB.Limit(p.Size).Offset(offset).Find(&k)

	}

	var total int64
	tx.Count(&total)
	//p.Total = tx.RowsAffected
	p.Total = total
	if err := tx.Error; err != nil {
		return err
	}

	return nil
}

func GetK8sCluster(id uint) (K8sCluster models.K8SCluster, err error) {
	err = common.GVA_DB.Where("id = ?", id).First(&K8sCluster).Error
	if err != nil {
		return K8sCluster, err
	}
	return K8sCluster, nil
}

func DelCluster(ids models.ClusterIds) (err error) {
	var k models.K8SCluster

	//if reflect.TypeOf(id.Data).Kind() == reflect.Slice {
	//	s := reflect.ValueOf(id.Data)
	//	for i := 0; i < s.Len(); i++ {
	//		err := common.GVA_DB.Where("id = ?", s.Index(i)).Delete(&models.K8SCluster{})
	//		if err.Error != nil {
	//			fmt.Println("删除出错", err.Error)
	//		}
	//	}
	//}

	err2 := common.GVA_DB.Delete(&k, ids.Data)
	if err2.Error != nil {
		return err2.Error
	}
	return nil

}
