package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"pigs/common"
	"pigs/common/cloud/cloudvendor"
	"pigs/controller/response"
	"pigs/models/cmdb"
	"pigs/models/request"
	"pigs/services"
)

var (
	pageInfo request.PageInfo
	account  cmdb.CloudPlatform
)

func ListPlatform(c *gin.Context) {
	_ = c.ShouldBindJSON(&pageInfo)
	err, list, total := services.ListPlatform(pageInfo)
	if err != nil {
		common.LOG.Error("获取云平台信息失败", zap.Any("err", err))
		response.FailWithMessage(500, fmt.Sprintf("获取云平台信息失败，%v", err), c)
		return

	} else {
		response.OkWithData(response.PageResult{
			Data:  list,
			Total: total,
			Page:  pageInfo.Page,
			Size:  pageInfo.PageSize,
		}, c)
		return
	}
}

// AccountVerify 验证云账户连通性
func AccountVerify(conf *cmdb.CloudPlatform) error {
	_, err := cloudvendor.GetVendorClient(conf)
	if err != nil {
		fmt.Println("AccountVerify GetVendorClient failed", err)
		return err
	}

	return nil
}

// CloudPlatformAccount 云平台账号
func CloudPlatformAccount(c *gin.Context) {
	_ = c.ShouldBindJSON(&account)
	// 账户AK校验
	err := AccountVerify(&account)
	if err != nil {
		// "账户连通异常, 请检查AccessKey或Access Secret是否输入正确"
		response.FailWithMessage(500, fmt.Sprintf("获取云平台信息失败，%v", err), c)
		return
	}

	err1 := services.CreateCloudAccount(&account)
	if err1 != nil {
		response.FailWithMessage(500, fmt.Sprintf("获取云平台信息失败，%v", err1), c)
		return
	}
	response.OkWithDetailed(account, "添加成功, 任务正在后台同步云资源", c)
	return
}
