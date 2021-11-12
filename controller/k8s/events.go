package k8s

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"pigs/controller/response"
	"pigs/pkg/k8s/Init"
	"pigs/pkg/k8s/event"
)

func Events(c *gin.Context) {

	namespace := c.Query("namespace")
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	field := fmt.Sprintf("type=%s", "Warning")
	data, err := event.GetClusterNodeEvent(client, namespace, field)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}
