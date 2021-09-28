package routers

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
)

func InitCloudRouter(r *gin.RouterGroup) {
	InitCloudRouter := r.Group("cloud")
	{
		InitCloudRouter.GET("listPlatform", controller.ListPlatform)
	}
}
