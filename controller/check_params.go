package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"pigs/common"
	"pigs/controller/response"
)

func CheckParams(c *gin.Context, ptr interface{}) error {
	if ptr == nil {
		return nil
	}
	switch t := ptr.(type) {
	case string:
		if t != "" {
			panic(t)
		}
	case error:
		panic(t.Error())
	}
	if err := c.ShouldBindJSON(&ptr); err != nil {
		common.LOG.Warn(fmt.Sprintf("解析参数出错：%v", err.Error()))
		response.FailWithMessage(response.ParamError, "", c)
		return err
	}
	return nil
}
