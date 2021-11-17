package k8s

import (
	"github.com/gin-gonic/gin"
	"pigs/controller/response"
	"pigs/pkg/k8s/Init"
	"pigs/pkg/k8s/parser"
	"pigs/pkg/k8s/pv"
	"pigs/pkg/k8s/pvc"
)

func GetPersistentVolumeClaimListController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)

	data, err := pvc.GetPersistentVolumeClaimList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DetailPersistentVolumeClaimController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)

	result, err := pvc.GetPersistentVolumeClaimDetail(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(result, c)
	return
}

func DeletePersistentVolumeClaimController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)

	err = pvc.DeletePersistentVolumeClaim(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func GetPersistentVolumeListController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)

	data, err := pv.GetPersistentVolumeList(client, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DetailPersistentVolumeController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)

	result, err := pv.GetPersistentVolumeDetail(client, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(result, c)
	return
}

func DeletePersistentVolumeController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	name := parser.ParseNameParameter(c)

	err = pv.DeletePersistentVolume(client, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}
