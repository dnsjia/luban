package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"pigs/common"
	"pigs/controller/response"
	"pigs/models"
	"pigs/services"
)

func CreateK8SCluster(c *gin.Context) {
	var K8sCluster models.K8SCluster
	err := CheckParams(c, &K8sCluster)

	if err != nil {
		return
	}

	if err := services.CreateK8SCluster(K8sCluster); err != nil {
		common.GVA_LOG.Error(response.CreateK8SClusterErrorMsg, zap.Any("err", err))
		response.FailWithMessage(response.CreateK8SClusterError, "", c)
	} else {
		response.OkWithMessage("创建集群成功", c)
	}
}

func ListK8SCluster(c *gin.Context) {
	query := models.PaginationQ{}
	if c.ShouldBindQuery(&query) != nil {
		response.FailWithMessage(response.ParamError, response.ParamErrorMsg, c)
		return
	}

	var K8sCluster []models.K8SCluster
	data := make(map[string]interface{})
	if err := services.ListK8SCluster(&query, &K8sCluster); err != nil {
		common.GVA_LOG.Error("获取集群失败", zap.Any("err", err))
		response.FailWithMessage(response.InternalServerError, "获取集群失败", c)
	} else {
		data["Data"] = K8sCluster
		data["Total"] = query.Total
		data["Size"] = query.Size
		data["Page"] = query.Page
		response.OkWithDetailed(data, "获取集群成功", c)
	}
}

func DelK8SCluster(c *gin.Context) {
	var id models.ClusterIds
	err := CheckParams(c, &id)
	if err != nil {
		return
	}

	err2 := services.DelCluster(id)

	if err2 != nil {
		username, _ := c.Get("username")
		common.GVA_LOG.Error(fmt.Sprintf("用户：%s, 删除数据失败", username))
		response.FailWithMessage(response.InternalServerError, "删除失败！", c)
		return
	}

	response.Ok(c)
	return
}
