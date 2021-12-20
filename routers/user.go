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

package routers

import (
	"fmt"
	"github.com/dnsjia/luban/controller"
	"github.com/gin-gonic/gin"
	"os"
)

func User(r *gin.RouterGroup) {
	guest := r.Group("/luban")
	{
		guest.GET("/ping", func(c *gin.Context) {
			c.String(200, "pong")
		})
		guest.GET("/pid", func(c *gin.Context) {
			c.String(200, fmt.Sprintf("%d", os.Getpid()))
		})
		guest.GET("/addr", func(c *gin.Context) {
			c.String(200, c.Request.RemoteAddr)
		})
	}

	user := r.Group("user")
	{
		user.POST("/register", controller.Register)
		user.POST("/login", controller.Login)
	}
}

func InitUserRouter(r *gin.RouterGroup) {
	UserRouter := r.Group("user")
	{
		UserRouter.GET("info", controller.UserInfo)
	}
}
