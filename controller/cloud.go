package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"pigs/common"
	"pigs/controller/response"
	"pigs/models/request"
	"pigs/services"
)

func ListPlatform(c *gin.Context) {
	var pageInfo request.PageInfo
	_ = c.ShouldBindJSON(&pageInfo)
	err, list, total := services.ListPlatform(pageInfo)
	if err != nil {
		common.GVA_LOG.Error("获取云平台信息失败", zap.Any("err", err))
		response.FailWithMessage(500, fmt.Sprintf("获取云平台信息失败，%v", err), c)
	} else {
		response.OkWithData(response.PageResult{
			Data:  list,
			Total: total,
			Page:  pageInfo.Page,
			Size:  pageInfo.PageSize,
		}, c)
	}
}
