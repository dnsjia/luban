package controller

import (
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
	var K8sCluster []models.K8SCluster
	if err := services.ListK8SCluster(&K8sCluster); err != nil {
		common.GVA_LOG.Error(response.CreateK8SClusterErrorMsg, zap.Any("err", err))
		response.FailWithMessage(response.CreateK8SClusterError, "", c)
	} else {
		response.OkWithDetailed(K8sCluster, "获取集群成功", c)
	}
}
