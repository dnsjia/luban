package response

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type Response struct {
	Code int         `json:"errCode"`
	Data interface{} `json:"data"`
	Msg  string      `json:"errMsg"`
}

const (
	SUCCESS             = 0
	ERROR               = 7000
	AuthError           = 1000
	ParamError          = 1001
	UserForbidden       = 1002
	Forbidden           = http.StatusForbidden
	InternalServerError = http.StatusInternalServerError
)

const (
	OkMsg                  = "操作成功"
	NotOkMsg               = "操作失败"
	LoginCheckErrorMsg     = "用户名或密码错误"
	ForbiddenMsg           = "无权访问该资源"
	InternalServerErrorMsg = "服务器内部错误"
	ParamErrorMsg          = "参数绑定失败, 请检查数据类型"
	UserForbiddenMsg       = "用户已被禁用"
)

var CustomError = map[int]string{
	SUCCESS:             OkMsg,
	ERROR:               NotOkMsg,
	Forbidden:           ForbiddenMsg,
	InternalServerError: InternalServerErrorMsg,
	AuthError:           LoginCheckErrorMsg,
	ParamError:          ParamErrorMsg,
	UserForbidden:       UserForbiddenMsg,
}

func ResultFail(code int, data interface{}, msg string, c *gin.Context) {

	if msg == "" {
		c.JSON(http.StatusOK, Response{
			Code: code,
			Data: data,
			Msg:  CustomError[code],
		})
	} else {
		c.JSON(http.StatusOK, Response{
			Code: code,
			Data: data,
			Msg:  msg,
		})
	}
}

func ResultOk(code int, data interface{}, msg string, c *gin.Context) {
	// 开始时间
	c.JSON(http.StatusOK, Response{
		Code: code,
		Data: data,
		Msg:  msg,
	})
}

func Ok(c *gin.Context) {
	ResultOk(SUCCESS, map[string]interface{}{}, "操作成功", c)
}

func OkWithMessage(message string, c *gin.Context) {
	ResultOk(SUCCESS, map[string]interface{}{}, message, c)
}

func OkWithData(data interface{}, c *gin.Context) {
	ResultOk(SUCCESS, data, "操作成功", c)
}

func OkWithDetailed(data interface{}, message string, c *gin.Context) {
	ResultOk(SUCCESS, data, message, c)
}

func Fail(c *gin.Context) {
	ResultFail(ERROR, map[string]interface{}{}, "操作失败", c)
}

func FailWithMessage(code int, message string, c *gin.Context) {
	ResultFail(code, map[string]interface{}{}, message, c)
}

func FailWithDetailed(data interface{}, code int, message string, c *gin.Context) {
	ResultFail(code, data, message, c)
}
