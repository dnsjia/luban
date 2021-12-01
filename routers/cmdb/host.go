package cmdb

import (
	"github.com/dnsjia/luban/controller/cmdb"
	"github.com/gin-gonic/gin"
)

func InitHostRouter(r *gin.RouterGroup) {
	Router := r.Group("cmdb")
	{
		Router.GET("/host/group", cmdb.ListHostGroup)
		Router.GET("/host/server", cmdb.ListHost)
	}
}
