package gva

import (
	"pigs/cmd/sql"
	"pigs/common"
	"pigs/tools"

	"github.com/gookit/color"
	"github.com/spf13/cobra"
)

var initdbCmd = &cobra.Command{
	Use:   "initdb",
	Short: "pigs 小飞猪初始化数据",
	Long: `小飞猪运维平台: 
欢迎大家加入我们,一起共创社区。`,
	Run: func(cmd *cobra.Command, args []string) {
		path, _ := cmd.Flags().GetString("path")
		common.GVA_VP = tools.Viper(path)
		common.GVA_LOG = tools.Zap()
		db := common.GormMysql()
		switch common.GVA_CONFIG.System.DbType {
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
