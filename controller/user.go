package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"golang.org/x/crypto/bcrypt"
	"log"
	"net/http"
	"pigs/common"
	"pigs/model"
	"pigs/services"
)

func Register(c *gin.Context) {
	var user model.User
	if err := c.ShouldBindJSON(&user); err != nil {
		common.GVA_LOG.Warn(fmt.Sprintf("解析参数出错：%v", err.Error()))
		c.JSON(http.StatusBadRequest, gin.H{"errcode": 500, "errmsg": err.Error()})
		return
	}
	// 创建用户的时候加密用户的密码
	hashPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"errcdoe": 500, "errmsg": "密码加密错误"})
		return
	}
	user.Password = string(hashPassword)
	u, err := services.UserRegister(user)
	if err != nil {
		common.GVA_LOG.Error("注册失败", zap.Any("err", err))
		c.JSON(http.StatusBadRequest, gin.H{"msg": err.Error()})
	} else {
		c.JSON(http.StatusOK, gin.H{"msg": "注册成功", "data": u})
	}
}

func Login(c *gin.Context) {
	var user model.User

	if err := c.ShouldBindJSON(&user); err != nil {
		common.GVA_LOG.Warn(fmt.Sprintf("解析参数出错：%v", err.Error()))
		c.JSON(http.StatusBadRequest, gin.H{"errcode": 500, "errmsg": err.Error()})
		return
	}
	if user.UserName == "" {
		c.JSON(http.StatusBadRequest, gin.H{"errcode": 400, "errmsg": "用户不能为空"})
		return
	}
	if user.Password == "" {
		c.JSON(http.StatusBadRequest, gin.H{"errcode": 400, "errmsg": "密码不能为空"})
		return
	}
	u, err := services.Login(user)
	if err != nil {
		common.GVA_LOG.Error("登录失败", zap.Any("err", err))
		c.JSON(http.StatusBadRequest, gin.H{"msg": err.Error()})
	}

	// 发放Token
	token, err := common.ReleaseToken(u)
	if err != nil {
		c.JSON(500, gin.H{"msg": "token error"})
		log.Printf("token generate err: %v", err)
		return
	}
	c.SetCookie("username", u.UserName, 7*24, "/", "*", true, false)
	c.JSON(http.StatusOK, gin.H{"msg": "登录成功", "data": gin.H{"token": token}})

}

func UserInfo(c *gin.Context)  {

	user, _ := c.Get("user")
	c.JSON(http.StatusOK, gin.H{"errcode": 0, "data": gin.H{"user": user,}})
}