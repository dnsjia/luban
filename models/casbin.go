/*
Copyright 2021 The DnsJia Authors.
WebSite:  https://github.com/dnsjia/luban
Email:    OpenSource@dnsjia.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

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

// CasBinInReceive structure for input parameters
type CasBinInReceive struct {
	Role        string       `json:"role"`
	CasBinInfos []CasBinInfo `json:"casBinInfos"`
}

type Casbin struct {
	ModelPath string `mapstructure:"model-path" json:"modelPath" yaml:"model-path"`
}
