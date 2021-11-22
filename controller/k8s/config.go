package k8s

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
	"pigs/controller/response"
	"pigs/models/k8s"
	"pigs/pkg/k8s/Init"
	"pigs/pkg/k8s/configmap"
	"pigs/pkg/k8s/parser"
	"pigs/pkg/k8s/secret"
)

func GetConfigMapController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)

	data, err := configmap.GetConfigMapList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DetailConfigMapController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)
	namespace := parser.ParseNamespaceParameter(c)
	data, err := configmap.GetConfigMapDetail(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}

func DeleteConfigMapController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)
	namespace := parser.ParseNamespaceParameter(c)
	err = configmap.DeleteConfigMap(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.Ok(c)
	return
}

func DeleteCollectionConfigMapController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	var configMapList []k8s.ConfigMapData

	err = controller.CheckParams(c, &configMapList)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	err = configmap.DeleteCollectionConfigMap(client, configMapList)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func GetSecretsController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)

	data, err := secret.GetSecretList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DetailSecretsController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)
	namespace := parser.ParseNamespaceParameter(c)
	data, err := secret.GetSecretDetail(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}

func DeleteSecretsController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)
	namespace := parser.ParseNamespaceParameter(c)
	err = secret.DeleteSecret(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.Ok(c)
	return
}

func DeleteCollectionSecretsController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	var secretList []k8s.SecretsData

	err = controller.CheckParams(c, &secretList)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	err = secret.DeleteCollectionSecret(client, secretList)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}
