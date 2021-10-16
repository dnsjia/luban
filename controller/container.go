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
	if err := services.ListK8SCluster(&query, &K8sCluster); err != nil {
		common.GVA_LOG.Error("获取集群失败", zap.Any("err", err))
		response.FailWithMessage(response.InternalServerError, "获取集群失败", c)
	} else {
		response.OkWithDetailed(response.PageResult{
			Data:  K8sCluster,
			Total: query.Total,
			Size:  query.Size,
			Page:  query.Page,
		}, "获取集群成功", c)
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

func ClusterSecret(c *gin.Context) {
	clusterId := c.DefaultQuery("clusterId", "1")
	clusterIdUint, err := strconv.ParseUint(clusterId, 10, 32)
	cluster, err := services.GetK8sCluster(uint(clusterIdUint))
	if err != nil {
		common.GVA_LOG.Error("获取集群失败", zap.Any("err", err))
		response.FailWithMessage(1000, "获取集群凭证失败", c)
		return
	}
	data := map[string]interface{}{"secret": cluster.KubeConfig, "name": cluster.ClusterName}
	response.OkWithData(data, c)
	return
}

func GetK8SClusterDetail(c *gin.Context) {

	client, err := k8s.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	data := k8s.GetClusterInfo(client)
	response.OkWithData(data, c)

}

func Events(c *gin.Context) {

	namespace := c.DefaultQuery("namespace", "")
	client, err := k8s.ClusterID(c)
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
	return
}

func GetNodes(c *gin.Context) {

	client, err := k8s.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	data, err := k8s.GetNodeList(client, c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}
