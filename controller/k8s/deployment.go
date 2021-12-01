package k8s

import (
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/controller"
	"github.com/dnsjia/luban/controller/response"
	"github.com/dnsjia/luban/models/k8s"
	"github.com/dnsjia/luban/pkg/k8s/Init"
	"github.com/dnsjia/luban/pkg/k8s/deployment"
	"github.com/dnsjia/luban/pkg/k8s/parser"
	"github.com/dnsjia/luban/pkg/k8s/service"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"net/http"
)

func GetDeploymentList(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)

	data, err := deployment.GetDeploymentList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DeleteCollectionDeployment(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	var deploymentList []k8s.RemoveDeploymentData

	err = controller.CheckParams(c, &deploymentList)
	if err != nil {
		response.FailWithMessage(http.StatusNotFound, err.Error(), c)
		return
	}

	err = deployment.DeleteCollectionDeployment(client, deploymentList)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func DeleteDeployment(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}
	var deploymentData k8s.RemoveDeploymentToServiceData

	err2 := controller.CheckParams(c, &deploymentData)
	if err2 != nil {
		response.FailWithMessage(http.StatusNotFound, err2.Error(), c)
		return
	}

	err = deployment.DeleteDeployment(client, deploymentData.Namespace, deploymentData.DeploymentName)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	common.LOG.Info(fmt.Sprintf("deployment：%v, 已删除", deploymentData.DeploymentName))

	if deploymentData.IsDeleteService {
		serviceErr := service.DeleteService(client, deploymentData.Namespace, deploymentData.ServiceName)

		if serviceErr != nil {
			common.LOG.Error("删除相关Service出错", zap.Any("err: ", serviceErr))
			response.FailWithMessage(response.InternalServerError, err.Error(), c)
			return
		}
	}
	response.Ok(c)
	return
}

func ScaleDeployment(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	var scaleData k8s.ScaleDeployment

	err2 := controller.CheckParams(c, &scaleData)
	if err2 != nil {
		response.FailWithMessage(http.StatusNotFound, err2.Error(), c)
		return
	}

	err = deployment.ScaleDeployment(client, scaleData.Namespace, scaleData.DeploymentName, *scaleData.ScaleNumber)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func RestartDeploymentController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}
	var restartDeployment k8s.RestartDeployment
	err2 := controller.CheckParams(c, &restartDeployment)
	if err2 != nil {
		response.FailWithMessage(response.ParamError, err2.Error(), c)
		return
	}
	err3 := deployment.RestartDeployment(client, restartDeployment.DeploymentName, restartDeployment.Namespace)
	if err3 != nil {
		response.FailWithMessage(response.InternalServerError, err3.Error(), c)
		return
	}
	response.Ok(c)
	return

}

func GetDeploymentToServiceController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	var Deployment k8s.RestartDeployment
	err2 := controller.CheckParams(c, &Deployment)
	if err2 != nil {
		response.FailWithMessage(response.ParamError, err2.Error(), c)
		return
	}

	data, err := service.GetToService(client, Deployment.Namespace, Deployment.DeploymentName)
	if err != nil {
		response.FailWithMessage(response.ERROR, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}

func DetailDeploymentController(c *gin.Context) {

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}
	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)

	data, err := deployment.GetDeploymentDetail(client, namespace, name)

	if err != nil {
		response.FailWithMessage(response.ERROR, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
}

func RollBackDeploymentController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}
	var rollback k8s.RollbackDeployment

	rollbackParamsErr := controller.CheckParams(c, &rollback)
	if rollbackParamsErr != nil {
		response.FailWithMessage(response.ParamError, rollbackParamsErr.Error(), c)
		return
	}
	rollbackErr := deployment.RollbackDeployment(client, rollback.DeploymentName, rollback.Namespace, *rollback.ReVersion)

	if rollbackErr != nil {
		response.FailWithMessage(response.ERROR, rollbackErr.Error(), c)
		return
	}
	response.Ok(c)
}
