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
