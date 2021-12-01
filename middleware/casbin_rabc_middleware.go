package middleware

import (
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/controller/response"
	"github.com/dnsjia/luban/services"
	"github.com/gin-gonic/gin"
)

func CasBinHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		claims, _ := c.Get("claims")
		waitUse := claims.(*common.CustomClaims)
		// 获取请求的URI
		obj := c.Request.URL.RequestURI()
		// 获取请求方法
		act := c.Request.Method
		// 获取用户的角色
		sub := waitUse.Role
		common.LOG.Info(fmt.Sprintf("URL：%v, Method：%v, Role：%v", obj, act, sub))
		e := services.Casbin()
		// 判断策略中是否存在
		success, _ := e.Enforce(sub, obj, act)
		common.LOG.Debug(fmt.Sprintf("用户：%v, 权限校验：%v", waitUse.Username, success))
		if common.CONFIG.System.Env == "develop" || success {
			c.Next()
		} else {
			c.JSON(response.Forbidden, gin.H{"errCode": 403, "errMsg": "权限不足", "data": gin.H{}, "msg": ""})
			c.Abort()
			return
		}
	}
}
