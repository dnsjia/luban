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

package main

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	phttp "github.com/dnsjia/luban/http"
	"github.com/dnsjia/luban/middleware"
	"github.com/dnsjia/luban/models"
	"github.com/dnsjia/luban/routers"
	"github.com/dnsjia/luban/routers/cmdb"
	"github.com/dnsjia/luban/tools"
	"io"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/toolkits/pkg/logger"
)

func main() {
	// 创建记录日志的文件
	f, _ := os.Create("gin.log")
	//gin.DefaultWriter = io.MultiWriter(f)
	// 如果需要将日志同时写入文件和控制台，请使用以下代码
	gin.DefaultWriter = io.MultiWriter(f, os.Stdout)

	common.VP = tools.Viper()      // 初始化Viper
	common.LOG = tools.Zap()       // 初始化zap日志库
	common.DB = common.GormMysql() // gorm连接数据库
	common.MysqlTables(common.DB)  // 初始化表
	// 程序结束前关闭数据库链接
	db, _ := common.DB.DB()
	defer db.Close()

	parseConf()
	models.InitLdap(common.Config.LDAP)
	models.InitError()
	InitServer()
}

func InitServer() {

	r := gin.Default()
	//gin.ForceConsoleColor()
	r.Use(middleware.Cors())
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
	PublicGroup := r.Group("/api/v1/")
	{
		// 注册基础功能路由 不做鉴权
		routers.User(PublicGroup)
		routers.InitWebSocketRouter(PublicGroup)
	}
	PrivateGroup := r.Group("/api/v1/")
	PrivateGroup.Use(gin.Recovery()).Use(middleware.AuthMiddleware()).Use(middleware.CasBinHandler())
	{
		routers.InitUserRouter(PrivateGroup)
		// 权限相关路由
		routers.InitCasBinRouter(PrivateGroup)
		// 容器相关
		routers.InitContainerRouter(PrivateGroup)
		// 主机
		cmdb.InitHostRouter(PrivateGroup)
		//云资产管理
		routers.InitCloudRouter(PrivateGroup)
		// Websocket todo websocket鉴权
		//routers.InitWebSocketRouter(PrivateGroup)

	}
	// 任务调度
	//go tasks.TaskBeta()
	//go tasks.TaskWorker()
	address := fmt.Sprintf(":%d", common.CONFIG.System.Addr)
	err := r.Run(address)

	if err != nil {
		panic(fmt.Sprintf("start server err: %v", err))
	}

	_, cancelFunc := context.WithCancel(context.Background())
	endingProc(cancelFunc)

}

func parseConf() {
	if err := common.Parse(); err != nil {
		fmt.Println("cannot parse configuration file:", err)
		os.Exit(1)
	}
}

func endingProc(cancelFunc context.CancelFunc) {
	c := make(chan os.Signal, 1)
	signal.Notify(c, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)

	<-c
	fmt.Printf("stop signal caught, stopping... pid=%d\n", os.Getpid())

	// 执行清理工作
	cancelFunc()
	logger.Close()
	phttp.Shutdown()
	fmt.Println("process stopped successfully")
}
