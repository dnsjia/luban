package routers

import (
	"github.com/dnsjia/luban/controller/cmdb"
	"github.com/gin-gonic/gin"
)

func InitWebSocketRouter(r *gin.RouterGroup) {
	ws := r.Group("ws")
	{
		ws.GET("/pong", func(c *gin.Context) {
			c.String(200, "pong")
		})
		ws.GET("webssh", cmdb.WebSocketConnect)
	}
}
