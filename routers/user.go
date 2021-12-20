package routers

import (
	"fmt"
	"github.com/dnsjia/luban/controller"
	"github.com/gin-gonic/gin"
	"os"
)

func User(r *gin.RouterGroup) {
	guest := r.Group("/pigs")
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
