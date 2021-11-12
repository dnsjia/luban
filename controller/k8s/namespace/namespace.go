package namespace

import (
	"github.com/gin-gonic/gin"
	"pigs/controller/response"
	"pigs/pkg/k8s/Init"
	"pigs/pkg/k8s/namespace"
)

func GetNamespaceList(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	namespaces, err := namespace.GetNamespaceList(client)

	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(namespaces, c)
	return
}
