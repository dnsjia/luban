/*
Copyright 2021 The DnsJia Authors.
WebSite:  https://github.com/dnsjia/luban
Email:    OpenSource@dnsjia.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package middleware

import (
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models"
	"github.com/gin-gonic/gin"
	"net/http"
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
