package common

import (
	"github.com/dnsjia/luban/models"
	"github.com/dnsjia/luban/models/cmdb"
	"go.uber.org/zap"
	"gorm.io/gorm"
	"os"
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
		//models.ClusterVersion{},
		cmdb.CloudPlatform{},
		cmdb.VirtualMachine{},
		cmdb.TreeMenu{},
		cmdb.SSHRecord{},
		//

	)
	if err != nil {
		LOG.Error("register table failed", zap.Any("err", err))
		os.Exit(0)
	}
	LOG.Info("register table success")
}
