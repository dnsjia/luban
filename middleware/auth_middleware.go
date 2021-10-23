package middleware

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"pigs/common"
	"pigs/models"
	"strings"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 获取authorization header
		tokenString := c.GetHeader("token")
		// token 前缀为 jwt 用空格分开
		if tokenString == "" || !strings.HasPrefix(tokenString, "jwt") {
			c.JSON(http.StatusUnauthorized, gin.H{"errcode": 401, "errmsg": "未登录或非法访问"})
			c.Abort()
			return
		}

		tokenString = tokenString[4:] // 截取token 从jwt开始
		token, claims, err := common.ParseToken(tokenString)

		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"errcode": 401, "errmsg": "授权已过期"})
			c.Abort()
			return
		}

		// 验证通过之后 获取 claim中的userId
		userId := claims.ID
		var user models.User
		//common.GVA_DB.First(&user, userId)
		common.DB.Preload("Role").First(&user, userId)
		// 判断用户是否存在
		if user.UserName == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"errcode": 401, "errmsg": "认证失败"})
			c.Abort()
			return
		}

		// 用户存在, 将用户的信息写入 context
		c.Set("user", user)
		c.Set("claims", claims)
		c.Next()
	}

}
