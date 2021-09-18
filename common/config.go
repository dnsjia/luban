package common

import "pigs/model"

type Server struct {
	Zap    Zap          `mapstructure:"zap" json:"zap" yaml:"zap"`
	Mysql  Mysql        `mapstructure:"mysql" json:"mysql" yaml:"mysql"`
	Casbin model.Casbin `mapstructure:"casbin" json:"casbin" yaml:"casbin"`
	System System       `mapstructure:"system" json:"system" yaml:"system"`
}
