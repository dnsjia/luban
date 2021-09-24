package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"pigs/common"
	"pigs/controller/response"
	"pigs/models"
	"pigs/services"
)

func Register(c *gin.Context) {
	var user models.User
	err := CheckParams(c, &user)
	if err != nil {
		return
	}
	// 创建用户的时候加密用户的密码
	hashPassword, _ := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	user.Password = string(hashPassword)
	u, err := services.UserRegister(user)
	if err != nil {
		common.GVA_LOG.Error(fmt.Sprintf("用户：%v, 注册失败", user.UserName), zap.Any("err", err))
		response.FailWithMessage(response.UserRegisterFail, err.Error(), c)
	} else {
		response.ResultOk(0, u, "注册成功", c)
	}
}

func Login(c *gin.Context) {
	var user models.LoginUser
	fmt.Println(c.Request.Body)
	//user, _ = CheckLoginParams(c, user)
	err := CheckParams(c, &user)
	if err != nil {
		return
	}
	if user.Email == "" {
		response.FailWithMessage(response.UserNameEmpty, "", c)
		return
	}
	if user.Password == "" {
		response.FailWithMessage(response.UserPassEmpty, "", c)
		return
	}
	// 判断是否以LDAP方式登录
	if user.LdapEnable {
		user, err1 := services.PassLogin(user.Email, user.Password)
		if err1 == nil {
			if !*user.Status {
				response.FailWithMessage(response.UserDisable, "", c)
				return
			}

			c.Set("username", user.UserName)
			return
		}

		// password login fail, try ldap
		if common.Config.LDAP.Enable {
			user, err2 := services.LdapLogin(user.UserName, user.Password)
			if err2 == nil {
				if !*user.Status {
					response.FailWithMessage(response.UserDisable, "", c)
					return
				}
				c.Set("username", user.UserName)
				return
			}
		}
	}

	u, err := services.Login(user)
	if err != nil {
		common.GVA_LOG.Error("用户登录失败", zap.Any("err", err))
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
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
		common.GVA_LOG.Error(fmt.Sprintf("token generate err: %v", err))
		response.FailWithMessage(response.InternalServerError, fmt.Sprintf("token generate err：%v", err), c)
		return
	}
	c.SetCookie("username", u.UserName, 7*24, "/", "/", true, false)
	response.OkWithDetailed(gin.H{"token": token, "username": u.UserName, "role": u.Role, "email": u.Email}, "登录成功", c)
	return

}

func UserInfo(c *gin.Context) {

	user, _ := c.Get("user")
	c.JSON(http.StatusOK, gin.H{"errcode": 0, "data": gin.H{"user": user}})
}
