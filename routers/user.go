package routers

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"os"
	"pigs/controller"
)

func User(r *gin.RouterGroup) {
	guest := r.Group("/api/pigs")
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

func InitUserRouter(Router *gin.RouterGroup) {
	UserRouter := Router.Group("user")
	{
		UserRouter.GET("info", controller.UserInfo)
	}
}
