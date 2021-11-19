package k8s

type JobData struct {
	Namespace string `json:"namespace"  binding:"required"`
	Name      string `json:"name"  binding:"required"`
}

type ScaleJob struct {
	Namespace string `json:"namespace" binding:"required"`
	Name      string `json:"name" binding:"required"`
	// Job并行运行的Pod数量
	Number *int32 `json:"number" binding:"required"`
}
