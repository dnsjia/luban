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
	"github.com/dnsjia/luban/controller/response"
	"github.com/dnsjia/luban/pkg/k8s/Init"
	"github.com/dnsjia/luban/pkg/k8s/logs"
	"github.com/dnsjia/luban/pkg/k8s/pods"
	"github.com/gin-gonic/gin"
	"io"
	v1 "k8s.io/api/core/v1"
	"strconv"
)

func GetLogSourcesController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	resourceName := c.Param("resourceName")
	resourceType := c.Param("resourceType")
	namespace := c.Param("namespace")
	logSources, err := logs.GetLogSources(client, namespace, resourceName, resourceType)

	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(logSources, c)
	return
}

func GetLogDetailController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	namespace := c.Param("namespace")
	podID := c.Param("pod")
	containerID := c.Param("container")

	refTimestamp := c.Query("referenceTimestamp")
	if refTimestamp == "" {
		refTimestamp = logs.NewestTimestamp
	}

	refLineNum, err := strconv.Atoi(c.Query("referenceLineNum"))
	if err != nil {
		refLineNum = 0
	}
	usePreviousLogs := c.Query("previous") == "true"
	offsetFrom, err1 := strconv.Atoi(c.Query("offsetFrom"))
	offsetTo, err2 := strconv.Atoi(c.Query("offsetTo"))
	logFilePosition := c.Query("logFilePosition")

	logSelector := logs.DefaultSelection
	if err1 == nil && err2 == nil {
		logSelector = &logs.Selection{
			ReferencePoint: logs.LogLineId{
				LogTimestamp: logs.LogTimestamp(refTimestamp),
				LineNum:      refLineNum,
			},
			OffsetFrom:      offsetFrom,
			OffsetTo:        offsetTo,
			LogFilePosition: logFilePosition,
		}
	}

	result, err := pods.GetLogDetails(client, namespace, podID, containerID, logSelector, usePreviousLogs)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}

	response.OkWithData(result, c)
	return
}

func GetLogFileController(c *gin.Context) {
	client, err := Init.ClusterID(c)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	opts := new(v1.PodLogOptions)
	namespace := c.Param("namespace")
	podID := c.Param("pod")
	containerID := c.Param("container")
	opts.Previous = c.Query("previous") == "true"
	opts.Timestamps = c.Query("timestamps") == "true"

	logStream, err := pods.GetLogFile(client, namespace, podID, containerID, opts)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
	handleDownload(c, logStream)
}

func handleDownload(c *gin.Context, result io.ReadCloser) {
	c.Writer.Header().Add("Content-Type", "text/plain")
	defer result.Close()
	_, err := io.Copy(c.Writer, result)
	if err != nil {
		response.FailWithMessage(response.InternalServerError, err.Error(), c)
		return
	}
}
