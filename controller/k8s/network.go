package k8s

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
	"pigs/controller/response"
	"pigs/models/k8s"
	"pigs/pkg/ingress"
	"pigs/pkg/k8s/Init"
	"pigs/pkg/k8s/parser"
	"pigs/pkg/k8s/service"
)

func GetServiceListController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)
	data, err := service.GetServiceList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DetailServiceController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)
	namespace := parser.ParseNamespaceParameter(c)
	dataSelect := parser.ParseDataSelectPathParameter(c)
	data, err := service.GetServiceDetail(client, namespace, name, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}

func DeleteServiceController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)
	namespace := parser.ParseNamespaceParameter(c)
	err = service.DeleteService(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.Ok(c)
	return
}

func DeleteCollectionServiceController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	var serviceList []k8s.ServiceData

	err = controller.CheckParams(c, &serviceList)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	err = service.DeleteCollectionService(client, serviceList)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func GetIngressListController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)
	data, err := ingress.GetIngressList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DetailIngressController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)
	namespace := parser.ParseNamespaceParameter(c)
	data, err := ingress.GetIngressDetail(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}

func DeleteIngressController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)
	namespace := parser.ParseNamespaceParameter(c)
	err = ingress.DeleteIngress(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.Ok(c)
	return
}

func DeleteCollectionIngressController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	var ingressList []k8s.ServiceData

	err = controller.CheckParams(c, &ingressList)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	err = ingress.DeleteCollectionIngress(client, ingressList)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}
