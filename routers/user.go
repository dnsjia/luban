package routers

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
)

func User(r *gin.RouterGroup) {
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
