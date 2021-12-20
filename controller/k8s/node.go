/*
Copyright 2021 The DnsJia Authors.
WebSite:  https://github.com/dnsjia/luban
Email:    OpenSource@dnsjia.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package k8s

import (
	"github.com/dnsjia/luban/controller"
	"github.com/dnsjia/luban/controller/response"
	"github.com/dnsjia/luban/pkg/k8s/Init"
	"github.com/dnsjia/luban/pkg/k8s/node"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetNodes(c *gin.Context) {

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	data, err := node.GetNodeList(client, c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}

func GetNodeDetail(c *gin.Context) {
	client, err := Init.ClusterID(c)
	name := c.Query("name")
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	data, err := node.GetNodeDetail(client, name)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}

type Status struct {
	NodeName    string `json:"node_name"`
	Unscheduled bool   `json:"unscheduled"`
}

func NodeUnschedulable(c *gin.Context) {
	var nodeUnscheduled Status
	err := controller.CheckParams(c, &nodeUnscheduled)

	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	data, err := node.NodeUnschdulable(client, nodeUnscheduled.NodeName, nodeUnscheduled.Unscheduled)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.OkWithData(data, c)
	return
}

func CordonNode(c *gin.Context) {
	nodeName := c.Query("node_name")

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	if ok, err := node.CordonNode(client, nodeName); !ok {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.Ok(c)
}

func RemoveNode(c *gin.Context) {
	nodeName := c.Query("nodeName")
	if nodeName == "" {
		response.FailWithMessage(http.StatusNotFound, "移除节点名称不能为空", c)
		return
	}

	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	go node.RemoveNode(client, nodeName)
	//if ok, err := node.RemoveNode(client, nodeName); !ok {
	//	response.FailWithMessage(response.InternalServerError, err.Error(), c)
	//	return
	//}
	response.Ok(c)

}

type collectionNode struct {
	NodeName []string `json:"node_name"`
}

func CollectionNodeUnschedule(c *gin.Context) {
	var nodeUnscheduled collectionNode
	err := controller.CheckParams(c, &nodeUnscheduled)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	err = node.CollectionNodeUnschedule(client, nodeUnscheduled.NodeName)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	response.Ok(c)
	return
}

func CollectionCordonNode(c *gin.Context) {
	var nodeUnscheduled collectionNode
	err := controller.CheckParams(c, &nodeUnscheduled)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	err2 := node.CollectionCordonNode(client, nodeUnscheduled.NodeName)
	if err2 != nil {
		response.FailWithMessage(response.InternalServerError, err2.Error(), c)
		return
	}
	response.Ok(c)
	return
}
