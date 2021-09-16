package common

type Server struct {
	Zap   Zap   `mapstructure:"zap" json:"zap" yaml:"zap"`
	Mysql Mysql `mapstructure:"mysql" json:"mysql" yaml:"mysql"`
}
