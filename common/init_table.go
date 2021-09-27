package common

import (
	"go.uber.org/zap"
	"gorm.io/gorm"
	"os"
	"pigs/models"
)

func MysqlTables(db *gorm.DB) {
	/*
		注册数据库表专用
	*/
	err := db.AutoMigrate(
		models.User{},
		models.Menu{},
		models.Role{},
		models.Dept{},
		models.K8SCluster{},
		models.CloudPlatform{},
		models.VirtualMachine{},
	)
	if err != nil {
		GVA_LOG.Error("register table failed", zap.Any("err", err))
		os.Exit(0)
	}
	GVA_LOG.Info("register table success")
}
