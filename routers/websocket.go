package routers

import (
	"github.com/gin-gonic/gin"
	"pigs/controller/cmdb"
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
