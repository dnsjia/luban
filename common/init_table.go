package common

import (
	"go.uber.org/zap"
	"gorm.io/gorm"
	"os"
	"pigs/model"
)

// MysqlTables
//@function: MysqlTables
//@description: 注册数据库表专用
//@param: db *gorm.DB

func MysqlTables(db *gorm.DB) {
	err := db.AutoMigrate(
		model.User{},

	)
	if err != nil {
		GVA_LOG.Error("register table failed", zap.Any("err", err))
		os.Exit(0)
	}
	GVA_LOG.Info("register table success")
}
