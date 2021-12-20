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

package gva

import (
	"github.com/dnsjia/luban/cmd/sql"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/tools"

	"github.com/gookit/color"
	"github.com/spf13/cobra"
)

var initdbCmd = &cobra.Command{
	Use:   "initdb",
	Short: "LuBan 鲁班初始化数据",
	Long: `鲁班运维平台: 
欢迎大家加入我们,一起共创社区。`,
	Run: func(cmd *cobra.Command, args []string) {
		path, _ := cmd.Flags().GetString("path")
		common.VP = tools.Viper(path)
		common.LOG = tools.Zap()
		db := common.GormMysql()
		switch common.CONFIG.System.DbType {
		case "mysql":
			common.MysqlTables(db)
			sql.InitMysqlData(db)
		default:
			common.MysqlTables(db)
			sql.InitMysqlData(db)
		}
		frame, _ := cmd.Flags().GetString("frame")
		if frame == "gf" {
			color.Info.Println("gf功能开发中")
			return
		} else {
			return
		}
	},
}

func init() {
	rootCmd.AddCommand(initdbCmd)
	initdbCmd.Flags().StringP("path", "p", "./config.yaml", "自定配置文件路径(绝对路径)")
	initdbCmd.Flags().StringP("frame", "f", "gin", "可选参数为gin,gf")
	initdbCmd.Flags().StringP("type", "t", "mysql", "可选参数为mysql")
}
