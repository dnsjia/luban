package pods

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
	"pigs/controller/response"
	"pigs/models/k8s"
	"pigs/pkg/k8s/Init"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/parser"
	"pigs/pkg/k8s/pods"
	"strings"
)

func GetPodsListController(c *gin.Context) {

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	dataSelect := parser.ParseDataSelectPathParameter(c)
	nameSpace := c.Query("namespace")
	var p = &k8scommon.NamespaceQuery{
		Namespaces: strings.Split(nameSpace, ","),
	}

	data, err := pods.GetPodsList(client, p, dataSelect)
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
	var podsData k8s.RemovePodsData

	err = controller.CheckParams(c, &podsData)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	err = pods.DeletePod(client, podsData.Namespace, podsData.PodName)
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
	namespace := c.Query("namespace")
	podName := c.Query("name")

	podData, err := pods.GetPodDetail(client, namespace, podName)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(podData, c)
	return
}
