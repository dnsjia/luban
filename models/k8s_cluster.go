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

package models

type K8SCluster struct {
	//ID             uint   `json:"id" gorm:"primarykey;AUTO_INCREMENT" form:"id"`
	GModel
	ClusterName    string `json:"clusterName" gorm:"comment:集群名称" form:"clusterName" binding:"required"`
	KubeConfig     string `json:"kubeConfig" gorm:"comment:集群凭证;type:varchar(12800)" binding:"required"`
	ClusterVersion string `json:"clusterVersion" gorm:"comment:集群版本"`
	NodeNumber     int    `json:"nodeNumber" gorm:"comment:节点数"`
}

func (ks K8SCluster) TableName() string {
	var k GModel
	return k.TableName("k8s_cluster")
}

type ClusterVersion struct {
	GModel
	Version string `json:"version"`
}

func (v ClusterVersion) TableName() string {
	var k GModel
	return k.TableName("k8s_cluster_version")
}

type PaginationQ struct {
	Size    int    `form:"size" json:"size"`
	Page    int    `form:"page" json:"page"`
	Total   int64  `json:"total"`
	Keyword string `form:"keyword" json:"keyword"`
}

type ClusterIds struct {
	Data interface{} `json:"clusterIds"`
}

type ClusterNodesStatus struct {
	NodeCount       int     `json:"node_count"`
	Ready           int     `json:"ready"`
	UnReady         int     `json:"unready"`
	Namespace       int     `json:"namespace"`
	Deployment      int     `json:"deployment"`
	Pod             int     `json:"pod"`
	CpuUsage        float64 `json:"cpu_usage" desc:"cpu使用率"`
	CpuCore         float64 `json:"cpu_core"`
	CpuCapacityCore float64 `json:"cpu_capacity_core"`
	MemoryUsage     float64 `json:"memory_usage" desc:"内存使用率"`
	MemoryUsed      float64 `json:"memory_used"`
	MemoryTotal     float64 `json:"memory_total"`
}
