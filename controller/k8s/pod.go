package k8s

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
	"pigs/controller/response"
	"pigs/models/k8s"
	"pigs/pkg/k8s/Init"
	"pigs/pkg/k8s/parser"
	"pigs/pkg/k8s/pods"
)

func GetPodsListController(c *gin.Context) {

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)

	data, err := pods.GetPodsList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DeleteCollectionPodsController(c *gin.Context) {

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	var podsData []k8s.RemovePodsData

	err = controller.CheckParams(c, &podsData)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	err = pods.DeleteCollectionPods(client, podsData)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func DeletePodController(c *gin.Context) {

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)

	err = pods.DeletePod(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func DetailPodController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)

	podData, err := pods.GetPodDetail(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(podData, c)
	return
}
