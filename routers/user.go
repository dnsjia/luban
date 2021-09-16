package routers

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
	"pigs/middleware"
)

func User(r *gin.Engine) {
	user := r.Group("/user")
	{
		user.POST("/register", controller.Register)
		user.POST("/login", controller.Login)
		user.GET("/:id", middleware.AuthMiddleware(), controller.UserInfo)
	}
}
