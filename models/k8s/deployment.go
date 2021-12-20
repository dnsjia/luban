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

type RemoveDeploymentData struct {
	Namespace      string `json:"namespace"  binding:"required"`
	DeploymentName string `json:"deploymentName" binding:"required"`
}

type ScaleDeployment struct {
	ScaleNumber    *int32 `json:"scaleNumber" binding:"required"`
	Namespace      string `json:"namespace" binding:"required"`
	DeploymentName string `json:"deploymentName" binding:"required"`
}

type RestartDeployment struct {
	Namespace      string `json:"namespace"  binding:"required"`
	DeploymentName string `json:"deploymentName" binding:"required"`
}

type RemoveDeploymentToServiceData struct {
	IsDeleteService bool   `json:"isDeleteService" binding:"required"`
	ServiceName     string `json:"serviceName" binding:"required"`
	Namespace       string `json:"namespace" binding:"required"`
	DeploymentName  string `json:"deploymentName" binding:"required"`
}

type RollbackDeployment struct {
	Namespace      string `json:"namespace" binding:"required"`
	DeploymentName string `json:"deploymentName" binding:"required"`
	ReVersion      *int64 `json:"reVersion" binding:"required"`
}
