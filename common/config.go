package common

import (
	"bytes"
	"fmt"
	"github.com/dnsjia/luban/models"
	"github.com/dnsjia/luban/pkg/iconf"
	"github.com/spf13/viper"
	"github.com/toolkits/pkg/file"
)

type Server struct {
	Zap     Zap           `mapstructure:"zap"    json:"zap" yaml:"zap"`
	Mysql   Mysql         `mapstructure:"mysql"  json:"mysql" yaml:"mysql"`
	Casbin  models.Casbin `mapstructure:"casbin" json:"casbin" yaml:"casbin"`
	System  System        `mapstructure:"system" json:"system" yaml:"system"`
	Redis   Redis         `mapstructure:"redis"  json:"redis" yaml:"redis"`
	Crontab Crontab       `mapstructure:"crontab" json:"crontab" yaml:"crontab"`
}

type contactKey struct {
	Label string `yaml:"label" json:"label"`
	Key   string `yaml:"key" json:"key"`
}

type ConfigStruct struct {
	LDAP models.LdapSection `yaml:"ldap"`
}

var Config *ConfigStruct

func Parse() error {
	ymlFile := iconf.GetYmlFile("server")
	if ymlFile == "" {
		return fmt.Errorf("configuration file of server not found")
	}

	bs, err := file.ReadBytes(ymlFile)
	if err != nil {
		return fmt.Errorf("cannot read yml[%s]: %v", ymlFile, err)
	}

	viper.SetConfigType("yaml")
	err = viper.ReadConfig(bytes.NewBuffer(bs))
	if err != nil {
		return fmt.Errorf("cannot read yml[%s]: %v", ymlFile, err)
	}
	err = viper.Unmarshal(&Config)
	if err != nil {
		return fmt.Errorf("cannot read yml[%s]: %v", ymlFile, err)
	}

	fmt.Println("config.file:", ymlFile)

	return nil
}
