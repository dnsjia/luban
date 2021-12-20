package routers

import (
	"github.com/dnsjia/luban/controller"
	"github.com/gin-gonic/gin"
)

func InitCasBinRouter(Router *gin.RouterGroup) {

	CasBinRouter := Router.Group("casbin")
	{
		CasBinRouter.POST("", controller.AddCasBin)
	}
}
