package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"io"
	"os"
	"pigs/common"
	"pigs/routers"
	"pigs/tools"
	"time"
)

func main() {
	// 创建记录日志的文件
	f, _ := os.Create("gin.log")
	//gin.DefaultWriter = io.MultiWriter(f)
	// 如果需要将日志同时写入文件和控制台，请使用以下代码
	gin.DefaultWriter = io.MultiWriter(f, os.Stdout)

	common.GVA_VP = tools.Viper()      // 初始化Viper
	common.GVA_LOG = tools.Zap()       // 初始化zap日志库
	common.GVA_DB = common.GormMysql() // gorm连接数据库
	common.MysqlTables(common.GVA_DB)  // 初始化表
	// 程序结束前关闭数据库链接
	db, _ := common.GVA_DB.DB()
	defer db.Close()

	InitServer()
}

func InitServer() {
	r := gin.Default()
	gin.ForceConsoleColor()
	r.Use(gin.LoggerWithFormatter(func(param gin.LogFormatterParams) string {

		// 你的自定义格式
		return fmt.Sprintf("%s - [%s] \"%s %s %s %d %s \"%s\" %s\"\n",
			param.ClientIP,
			param.TimeStamp.Format(time.RFC3339),
			param.Method,
			param.Path,
			param.Request.Proto,
			param.StatusCode,
			param.Latency,
			param.Request.UserAgent(),
			param.ErrorMessage,
		)
	}))
	r.Use(gin.Recovery())

	routers.User(r)
	err := r.Run(":8999")

	if err != nil {
		panic(fmt.Sprintf("start server err: %v", err))
	}
}
