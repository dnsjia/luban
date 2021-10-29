package k8s

type RemoveDeploymentData struct {
	Namespace      string `json:"namespace"  binding:"required"`
	DeploymentName string `json:"deploymentName" binding:"required"`
}

type ScaleDeployment struct {
	ScaleNumber    int32  `json:"scaleNumber" binding:"required"`
	Namespace      string `json:"namespace" binding:"required"`
	DeploymentName string `json:"deploymentName" binding:"required"`
}

type RestartDeployment struct {
	Namespace      string `json:"namespace"  binding:"required"`
	DeploymentName string `json:"deploymentName" binding:"required"`
}

type RemoveDeploymentToServiceData struct {
	IsDeleteService bool   `json:"isDeleteService"`
	ServiceName     string `json:"serviceName"`
	Namespace       string `json:"namespace"`
	DeploymentName  string `json:"deploymentName"`
}
