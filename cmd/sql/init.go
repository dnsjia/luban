package sql

import "gorm.io/gorm"

func InitMysqlData(db *gorm.DB) {
	InitK8sClusterVersion(db)
}
