package k8s

type RemovePodsData struct {
	Namespace string `json:"namespace"  binding:"required"`
	PodName   string `json:"podName"  binding:"required"`
}
