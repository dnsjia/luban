package models

type K8SCluster struct {
	ID             uint   `json:"id" gorm:"primarykey;AUTO_INCREMENT" form:"id"`
	ClusterName    string `json:"clusterName" gorm:"comment:集群名称" form:"clusterName" binding:"required"`
	KubeConfig     string `json:"kubeConfig" gorm:"comment:集群凭证;type:varchar(12800)" binding:"required"`
	ClusterVersion string `json:"clusterVersion" gorm:"comment:集群版本" binding:"required"`
	NodeNumber     int8   `json:"nodeNumber" gorm:"comment:节点数"`
}

func (ks K8SCluster) TableName() string {
	var k GModel
	return k.TableName("k8s_cluster")
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
