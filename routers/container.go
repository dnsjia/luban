package routers

import (
	"github.com/gin-gonic/gin"
	"pigs/controller/k8s/cluster"
	"pigs/controller/k8s/deployment"
	"pigs/controller/k8s/event"
	"pigs/controller/k8s/namespace"
	"pigs/controller/k8s/node"
	"pigs/controller/k8s/pods"
)

func InitContainerRouter(r *gin.RouterGroup) {
	K8sClusterRouter := r.Group("k8s")
	{
		K8sClusterRouter.POST("cluster", cluster.CreateK8SCluster)
		K8sClusterRouter.GET("cluster", cluster.ListK8SCluster)
		K8sClusterRouter.GET("cluster/secret", cluster.ClusterSecret)
		K8sClusterRouter.POST("delCluster", cluster.DelK8SCluster)
		K8sClusterRouter.GET("cluster/detail", cluster.GetK8SClusterDetail)
		K8sClusterRouter.GET("events", event.Events)
		K8sClusterRouter.GET("node", node.GetNodes)
		K8sClusterRouter.DELETE("node", node.RemoveNode)
		K8sClusterRouter.GET("node/detail", node.GetNodeDetail)
		K8sClusterRouter.POST("node/schedule", node.NodeUnschedulable)
		K8sClusterRouter.POST("node/collectionSchedule", node.CollectionNodeUnschedule)
		K8sClusterRouter.GET("node/cordon", node.CordonNode)
		K8sClusterRouter.POST("node/collectionCordon", node.CollectionCordonNode)

		K8sClusterRouter.GET("deployment", deployment.GetDeploymentList)
		K8sClusterRouter.POST("deployments", deployment.DeleteCollectionDeployment)
		K8sClusterRouter.POST("deployment/delete", deployment.DeleteDeployment)

		K8sClusterRouter.POST("deployment/scale", deployment.ScaleDeployment)
		K8sClusterRouter.GET("deployment/detail", deployment.DetailDeploymentController)
		K8sClusterRouter.POST("deployment/restart", deployment.RestartDeploymentController)
		K8sClusterRouter.POST("deployment/service", deployment.GetDeploymentToServiceController)
		K8sClusterRouter.POST("deployment/rollback", deployment.RollBackDeploymentController)

		K8sClusterRouter.GET("namespace", namespace.GetNamespaceList)

		K8sClusterRouter.GET("pods", pods.GetPodsList)
	}
}
