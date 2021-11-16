package routers

import (
	"github.com/gin-gonic/gin"
	"pigs/controller/k8s"
)

func InitContainerRouter(r *gin.RouterGroup) {
	K8sClusterRouter := r.Group("k8s")
	{
		K8sClusterRouter.POST("cluster", k8s.CreateK8SCluster)
		K8sClusterRouter.GET("cluster", k8s.ListK8SCluster)
		K8sClusterRouter.GET("cluster/secret", k8s.ClusterSecret)
		K8sClusterRouter.POST("cluster/delete", k8s.DelK8SCluster)
		K8sClusterRouter.GET("cluster/detail", k8s.GetK8SClusterDetail)
		K8sClusterRouter.GET("events", k8s.Events)

		K8sClusterRouter.GET("node", k8s.GetNodes)
		K8sClusterRouter.DELETE("node", k8s.RemoveNode)
		K8sClusterRouter.GET("node/detail", k8s.GetNodeDetail)
		K8sClusterRouter.POST("node/schedule", k8s.NodeUnschedulable)
		K8sClusterRouter.POST("node/collectionSchedule", k8s.CollectionNodeUnschedule)
		K8sClusterRouter.GET("node/cordon", k8s.CordonNode)
		K8sClusterRouter.POST("node/collectionCordon", k8s.CollectionCordonNode)

		K8sClusterRouter.GET("deployment", k8s.GetDeploymentList)
		K8sClusterRouter.POST("deployments", k8s.DeleteCollectionDeployment)
		K8sClusterRouter.POST("deployment/delete", k8s.DeleteDeployment)

		K8sClusterRouter.POST("deployment/scale", k8s.ScaleDeployment)
		K8sClusterRouter.GET("deployment/detail", k8s.DetailDeploymentController)
		K8sClusterRouter.POST("deployment/restart", k8s.RestartDeploymentController)
		K8sClusterRouter.POST("deployment/service", k8s.GetDeploymentToServiceController)
		K8sClusterRouter.POST("deployment/rollback", k8s.RollBackDeploymentController)

		K8sClusterRouter.GET("namespace", k8s.GetNamespaceList)

		K8sClusterRouter.GET("pod", k8s.GetPodsListController)
		K8sClusterRouter.DELETE("pod", k8s.DeletePodController)
		K8sClusterRouter.POST("pods", k8s.DeleteCollectionPodsController)
		K8sClusterRouter.GET("pod/detail", k8s.DetailPodController)

		K8sClusterRouter.GET("statefulset", k8s.GetStatefulSetListController)
		K8sClusterRouter.DELETE("statefulset", k8s.DeleteStatefulSetController)
		K8sClusterRouter.POST("statefulsets", k8s.DeleteCollectionStatefulSetController)
		K8sClusterRouter.POST("statefulset/restart", k8s.RestartStatefulSetController)
		K8sClusterRouter.POST("statefulset/scale", k8s.ScaleStatefulSetController)
		K8sClusterRouter.GET("statefulset/detail", k8s.DetailStatefulSetController)

		K8sClusterRouter.GET("daemonset", k8s.GetDaemonSetListController)
		K8sClusterRouter.DELETE("daemonset", k8s.DeleteDaemonSetController)
		K8sClusterRouter.POST("daemonsets", k8s.DeleteCollectionDaemonSetController)
		K8sClusterRouter.POST("daemonset/restart", k8s.RestartDaemonSetController)
		K8sClusterRouter.GET("daemonset/detail", k8s.DetailDaemonSetController)

		K8sClusterRouter.GET("job", k8s.GetJobListController)
		K8sClusterRouter.DELETE("job", k8s.DeleteJobController)
		K8sClusterRouter.POST("jobs", k8s.DeleteCollectionJobController)
		K8sClusterRouter.POST("job/scale", k8s.ScaleJobController)
		K8sClusterRouter.GET("job/detail", k8s.DetailJobController)

		K8sClusterRouter.GET("cronjob", k8s.GetCronJobListController)
		K8sClusterRouter.DELETE("cronjob", k8s.DeleteCronJobController)
		K8sClusterRouter.POST("cronjobs", k8s.DeleteCollectionCronJobController)
		K8sClusterRouter.GET("cronjob/detail", k8s.DetailCronJobController)
	}
}
