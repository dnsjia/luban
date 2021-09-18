package common

import (
	"go.uber.org/zap"
	"gorm.io/gorm"
	"os"
	"pigs/model"
)

func MysqlTables(db *gorm.DB) {
	/*
		注册数据库表专用
	*/
	err := db.AutoMigrate(
		model.User{},
		model.Menu{},
		model.Role{},
		model.Dept{},
	)
	if err != nil {
		GVA_LOG.Error("register table failed", zap.Any("err", err))
		os.Exit(0)
	}
	GVA_LOG.Info("register table success")
}
