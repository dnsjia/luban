package k8s

import (
	"github.com/gin-gonic/gin"
	"pigs/controller"
	"pigs/controller/response"
	"pigs/models/k8s"
	"pigs/pkg/k8s/Init"
	"pigs/pkg/k8s/cronjob"
	"pigs/pkg/k8s/parser"
)

func GetCronJobListController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	dataSelect := parser.ParseDataSelectPathParameter(c)
	nsQuery := parser.ParseNamespacePathParameter(c)

	data, err := cronjob.GetCronJobList(client, nsQuery, dataSelect)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(data, c)
	return
}

func DeleteCronJobController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)
	err = cronjob.DeleteCronJob(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func DeleteCollectionCronJobController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	var jobList []k8s.JobData

	err = controller.CheckParams(c, &jobList)
	if err != nil {
		response.FailWithMessage(response.ParamError, err.Error(), c)
		return
	}

	err = cronjob.DeleteCollectionCronJob(client, jobList)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.Ok(c)
	return
}

func DetailCronJobController(c *gin.Context) {

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	namespace := parser.ParseNamespaceParameter(c)
	name := parser.ParseNameParameter(c)

	result, err := cronjob.GetCronJobDetail(client, namespace, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(result, c)
	return
}
