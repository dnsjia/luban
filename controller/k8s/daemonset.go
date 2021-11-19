package k8s

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"pigs/controller"
	"pigs/controller/response"
	"pigs/models/k8s"
	"pigs/pkg/k8s/Init"
	"pigs/pkg/k8s/daemonset"
	"pigs/pkg/k8s/parser"
)

func GetDaemonSetListController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)

	data, err := daemonset.GetDaemonSetList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DeleteCollectionDaemonSetController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	var daemonSetList []k8s.DaemonSetData

	err = controller.CheckParams(c, &daemonSetList)
	if err != nil {
		response.FailWithMessage(http.StatusNotFound, err.Error(), c)
		return
	}

	err = daemonset.DeleteCollectionDaemonSet(client, daemonSetList)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func DeleteDaemonSetController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)

	err = daemonset.DeleteDaemonSet(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func RestartDaemonSetController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	var daemonSet k8s.DaemonSetData
	err = controller.CheckParams(c, &daemonSet)
	if err != nil {
		response.FailWithMessage(http.StatusNotFound, err.Error(), c)
		return
	}

	err = daemonset.RestartDaemonSet(client, daemonSet.Namespace, daemonSet.Name)

	if err != nil {
		response.FailWithMessage(response.ERROR, err.Error(), c)
		return
	}
	response.Ok(c)
}

func DetailDaemonSetController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}
	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)

	data, err := daemonset.GetDaemonSetDetail(client, namespace, name)

	if err != nil {
		response.FailWithMessage(response.ERROR, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
}
