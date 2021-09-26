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
	}
}
