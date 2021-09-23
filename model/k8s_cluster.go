package model

type K8SCluster struct {
	ID             uint    `json:"id" gorm:"primarykey;AUTO_INCREMENT" form:"id"`
	ClusterName    string  `json:"clusterName" gorm:"comment:集群名称"`
	KubeConfig     string  `json:"kubeConfig" gorm:"comment:集群凭证;type:varchar(12800)"`
	ClusterVersion float32 `json:"clusterVersion" gorm:"comment:集群版本"`
	NodeNumber     int8    `json:"nodeNumber" gorm:"comment:节点数"`
}
