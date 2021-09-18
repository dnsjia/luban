package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"golang.org/x/crypto/bcrypt"
	"log"
	"net/http"
	"pigs/common"
	"pigs/controller/response"
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
		c.JSON(http.StatusInternalServerError, gin.H{"errcode": 500, "errmsg": "密码加密错误"})
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
	var user model.LoginUser

	if err := c.ShouldBindJSON(&user); err != nil {
		common.GVA_LOG.Warn(fmt.Sprintf("解析参数出错：%v", err.Error()))
		//response.FailWithDetailed(gin.H{}, response.ParamError, "", c)
		response.FailWithMessage(response.ParamError, "", c)
		return
	}
	if user.Email == "" {
		c.JSON(http.StatusOK, gin.H{"errcode": 400, "errmsg": "用户不能为空"})
		return
	}
	if user.Password == "" {
		c.JSON(http.StatusOK, gin.H{"errcode": 400, "errmsg": "密码不能为空"})
		return
	}
	u, err := services.Login(user)
	if err != nil {
		common.GVA_LOG.Error("查询用户失败", zap.Any("err", err))
		response.FailWithMessage(response.InternalServerError, "", c)
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(user.Password)); err != nil {
		// 密码错误
		response.FailWithMessage(response.AuthError, "", c)
		return
	}

	// 发放Token
	token, err := common.ReleaseToken(u)
	if err != nil {
		log.Printf("token generate err: %v", err)
		response.FailWithMessage(response.InternalServerError, "xxxxxxxx", c)
		return
	}
	c.SetCookie("username", u.UserName, 7*24, "/", "*", true, false)
	response.OkWithDetailed(gin.H{"token": token}, "登录成功", c)
	return

}

func UserInfo(c *gin.Context) {

	user, _ := c.Get("user")
	c.JSON(http.StatusOK, gin.H{"errcode": 0, "data": gin.H{"user": user}})
}
