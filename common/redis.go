package common

type Redis struct {
	Host     string `mapstructure:"host" json:"host" yaml:"host"`
	UserName string `mapstructure:"username" json:"username" yaml:"username"`
	PassWord string `mapstructure:"password" json:"password" yaml:"password"`
	DB       int    `mapstructure:"db" json:"db" yaml:"db"`
}
