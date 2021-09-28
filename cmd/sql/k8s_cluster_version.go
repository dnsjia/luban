package sql

import (
	"github.com/gookit/color"
	"gorm.io/gorm"
	"os"
	"pigs/models"
)

var t models.LocalTime

var Version = []models.ClusterVersion{
	{GModel: models.GModel{ID: 1, CreatedAt: t, UpdatedAt: t}, Version: "v1.18.11"},
	{GModel: models.GModel{ID: 2, CreatedAt: t, UpdatedAt: t}, Version: "v1.18.12"},
}

func InitK8sClusterVersion(db *gorm.DB) {
	if err := db.Transaction(func(tx *gorm.DB) error {
		if tx.Where("id IN ?", []int{1, 2}).Find(&[]models.ClusterVersion{}).RowsAffected == 2 {
			color.Danger.Println("k8s_cluster_version表初始数据已存在!")
			return nil
		}
		if err := tx.Create(&Version).Error; err != nil { // 遇到错误时回滚事务
			return err
		}
		return nil
	}); err != nil {
		color.Warn.Printf("[mysql]--> k8s_cluster_version 表的初始数据失败,err: %v\n", err)
		os.Exit(0)
	}
}
