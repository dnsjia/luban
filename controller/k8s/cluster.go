package k8s

import (
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/controller"
	"github.com/dnsjia/luban/controller/response"
	"github.com/dnsjia/luban/models"
	"github.com/dnsjia/luban/pkg/k8s/Init"
	"github.com/dnsjia/luban/pkg/k8s/cluster"
	"github.com/dnsjia/luban/services"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"strconv"
)

func CreateK8SCluster(c *gin.Context) {

	var K8sCluster models.K8SCluster
	err := controller.CheckParams(c, &K8sCluster)
	if err != nil {
		return
	}
	client, err := Init.GetK8sClient(K8sCluster.KubeConfig)
	if err != nil {
		response.FailWithMessage(response.CreateK8SClusterError, err.Error(), c)
		return
	}
	version, err := cluster.GetClusterVersion(client)
	if err != nil {
		response.FailWithMessage(response.CreateK8SClusterError, "连接集群异常,请检查网络是否畅通！", c)
		return
	}
	K8sCluster.ClusterVersion = version
	number, err := cluster.GetClusterNodesNumber(client)
	if err != nil {
		common.LOG.Error("获取集群节点数量异常", zap.Any("err", err))
	}
	K8sCluster.NodeNumber = number

	if err := services.CreateK8SCluster(K8sCluster); err != nil {
		common.LOG.Error(response.CreateK8SClusterErrorMsg, zap.Any("err", err))
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
		common.LOG.Error("获取集群失败", zap.Any("err", err))
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
	err := controller.CheckParams(c, &id)
	if err != nil {
		return
	}
	err2 := services.DelCluster(id)
	if err2 != nil {
		username, _ := c.Get("username")
		common.LOG.Error(fmt.Sprintf("用户：%s, 删除数据失败", username))
		response.FailWithMessage(response.InternalServerError, "删除失败！", c)
		return
	}
	response.Ok(c)
	return
}

func ClusterSecret(c *gin.Context) {
	clusterId := c.DefaultQuery("clusterId", "1")
	clusterIdUint, err := strconv.ParseUint(clusterId, 10, 32)
	clusterConfig, err := services.GetK8sCluster(uint(clusterIdUint))
	if err != nil {
		common.LOG.Error("获取集群失败", zap.Any("err", err))
		response.FailWithMessage(1000, "获取集群凭证失败", c)
		return
	}
	data := map[string]interface{}{"secret": clusterConfig.KubeConfig, "name": clusterConfig.ClusterName}
	response.OkWithData(data, c)
	return
}

func GetK8SClusterDetail(c *gin.Context) {

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	data := cluster.GetClusterInfo(client)
	response.OkWithData(data, c)

}
