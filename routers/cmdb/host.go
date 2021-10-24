package cmdb

import (
	"github.com/gin-gonic/gin"
	"pigs/controller/cmdb"
)

func InitHostRouter(r *gin.RouterGroup) {
	Router := r.Group("cmdb")
	{
		Router.GET("/host/group", cmdb.ListHostGroup)
		Router.GET("/host/server", cmdb.ListHost)
	}
}
