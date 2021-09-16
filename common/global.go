package common

import (
	"github.com/spf13/viper"
	"go.uber.org/zap"

	"gorm.io/gorm"
)

var (
	GVA_DB     *gorm.DB
	GVA_CONFIG Server
	GVA_VP     *viper.Viper
	GVA_LOG    *zap.Logger
)
