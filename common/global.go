package common

import (
	"github.com/spf13/viper"
	"go.uber.org/zap"

	"gorm.io/gorm"
)

var (
	DB     *gorm.DB
	CONFIG Server
	VP     *viper.Viper
	LOG    *zap.Logger
)
