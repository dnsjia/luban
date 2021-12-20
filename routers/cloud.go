package routers

import (
	"github.com/dnsjia/luban/controller"
	"github.com/gin-gonic/gin"
)

func InitCloudRouter(r *gin.RouterGroup) {
	InitCloudRouter := r.Group("cloud")
	{
		InitCloudRouter.GET("listPlatform", controller.ListPlatform)
		InitCloudRouter.POST("account", controller.CloudPlatformAccount)
	}
}
