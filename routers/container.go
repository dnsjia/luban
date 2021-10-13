package routers

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
)

func InitContainerRouter(r *gin.RouterGroup) {
	K8sClusterRouter := r.Group("k8s")
	{
		K8sClusterRouter.POST("cluster", controller.CreateK8SCluster)
		K8sClusterRouter.GET("cluster", controller.ListK8SCluster)
		K8sClusterRouter.GET("cluster/secret", controller.ClusterSecret)
		K8sClusterRouter.POST("delCluster", controller.DelK8SCluster)
		K8sClusterRouter.GET("cluster/detail", controller.GetK8SClusterDetail)
		K8sClusterRouter.GET("events", controller.Events)
		K8sClusterRouter.GET("node", controller.GetNodes)
	}
}
