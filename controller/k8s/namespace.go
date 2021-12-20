package k8s

import (
	"github.com/dnsjia/luban/controller/response"
	"github.com/dnsjia/luban/pkg/k8s/Init"
	"github.com/dnsjia/luban/pkg/k8s/namespace"
	"github.com/gin-gonic/gin"
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
