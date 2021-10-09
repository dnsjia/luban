package controller

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"pigs/common"
	"pigs/controller/response"
	"pigs/models"
	"pigs/services"
	"pigs/tools/k8s"
	"strconv"
)

func CreateK8SCluster(c *gin.Context) {
	var K8sCluster models.K8SCluster
	err := CheckParams(c, &K8sCluster)

	if err != nil {
		return
	}
	client, err := k8s.GetK8sClient(K8sCluster.KubeConfig)
	if err != nil {
		response.FailWithMessage(response.CreateK8SClusterError, err.Error(), c)
		return
	}
	version, err := k8s.GetClusterVersion(client)
	if err != nil {
		response.FailWithMessage(response.CreateK8SClusterError, "连接集群异常,请检查网络是否畅通！", c)
		return
	}
	K8sCluster.ClusterVersion = version
	number, err := k8s.GetClusterNodesNumber(client)
	if err != nil {
		common.GVA_LOG.Error("获取集群节点数量异常", zap.Any("err", err))
	}
	K8sCluster.NodeNumber = number

	if err := services.CreateK8SCluster(K8sCluster); err != nil {
		common.GVA_LOG.Error(response.CreateK8SClusterErrorMsg, zap.Any("err", err))
		response.FailWithMessage(response.CreateK8SClusterError, "", c)
		return
	} else {
		response.OkWithMessage("创建集群成功", c)
		return
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

// ClusterID 公共方法, 获取指定k8s集群的KubeConfig
func ClusterID(c *gin.Context) {
	clusterId := c.DefaultQuery("clusterId", "1")
	clusterIdUint, err := strconv.ParseUint(clusterId, 10, 32)
	cluster, err := services.GetK8sCluster(uint(clusterIdUint))
	if err != nil {
		common.GVA_LOG.Error("获取集群失败", zap.Any("err", err))
		response.FailWithMessage(response.InternalServerError, "获取集群失败", c)
		return
	}
	response.OkWithData(cluster, c)
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

func GetK8SClusterDetail(c *gin.Context) {

	clusterId := c.DefaultQuery("clusterId", "1")
	clusterIdUint, err := strconv.ParseUint(clusterId, 10, 32)
	config, err := services.GetK8sCluster(uint(clusterIdUint))
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	client, err := k8s.GetK8sClient(config.KubeConfig)

	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	data := k8s.GetClusterInfo(client)
	response.OkWithData(data, c)

}

func Events(c *gin.Context) {
	clusterId := c.DefaultQuery("clusterId", "1")
	namespace := c.DefaultQuery("namespace", "")
	clusterIdUint, err := strconv.ParseUint(clusterId, 10, 32)
	config, err := services.GetK8sCluster(uint(clusterIdUint))
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	client, err := k8s.GetK8sClient(config.KubeConfig)

	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	data, err := k8s.GetEvents(client, namespace)

	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
}
