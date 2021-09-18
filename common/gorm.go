package common

import (
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

type Mysql struct {
	Path         string `mapstructure:"path" json:"path" yaml:"path"`
	Config       string `mapstructure:"config" json:"config" yaml:"config"`
	Dbname       string `mapstructure:"db-name" json:"dbname" yaml:"db-name"`
	Username     string `mapstructure:"username" json:"username" yaml:"username"`
	Password     string `mapstructure:"password" json:"password" yaml:"password"`
	MaxIdleConns int    `mapstructure:"max-idle-conns" json:"maxIdleConns" yaml:"max-idle-conns"`
	MaxOpenConns int    `mapstructure:"max-open-conns" json:"maxOpenConns" yaml:"max-open-conns"`
	LogMode      bool   `mapstructure:"log-mode" json:"logMode" yaml:"log-mode"`
	LogZap       string `mapstructure:"log-zap" json:"logZap" yaml:"log-zap"`
}

func gormConfig(mod bool) *gorm.Config {
	/*
		根据配置决定是否开启日志
	*/
	switch GVA_CONFIG.Mysql.LogZap {
	case "Silent":
		return &gorm.Config{
			Logger:                                   Default.LogMode(logger.Silent),
			DisableForeignKeyConstraintWhenMigrating: true,
		}
	case "Error":
		return &gorm.Config{
			Logger:                                   Default.LogMode(logger.Error),
			DisableForeignKeyConstraintWhenMigrating: true,
		}
	case "Warn":
		return &gorm.Config{
			Logger:                                   Default.LogMode(logger.Warn),
			DisableForeignKeyConstraintWhenMigrating: true,
		}
	case "Info":
		return &gorm.Config{
			Logger:                                   Default.LogMode(logger.Info),
			DisableForeignKeyConstraintWhenMigrating: true,
		}
	default:
		if mod {
			return &gorm.Config{
				Logger:                                   logger.Default.LogMode(logger.Info),
				DisableForeignKeyConstraintWhenMigrating: true,
			}
		} else {
			return &gorm.Config{
				Logger:                                   logger.Default.LogMode(logger.Silent),
				DisableForeignKeyConstraintWhenMigrating: true,
			}
		}
	}
}
