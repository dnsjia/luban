package models

import (
	_ "github.com/go-sql-driver/mysql"
)

type CasBinModel struct {
	PType  string `json:"p_type" gorm:"column:p_type"`
	Role   string `json:"role_name" gorm:"column:v0"`
	Path   string `json:"path" gorm:"column:v1"`
	Method string `json:"method" gorm:"column:v2"`
}

type CasBinInfo struct {
	Path   string `json:"path"`
	Method string `json:"method"`
}

// CasBin structure for input parameters
type CasBinInReceive struct {
	Role        string       `json:"role"`
	CasBinInfos []CasBinInfo `json:"casBinInfos"`
}

type Casbin struct {
	ModelPath string `mapstructure:"models-path" json:"modelPath" yaml:"models-path"`
}
