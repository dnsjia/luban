package k8s

type ConfigMapData struct {
	Namespace string `json:"namespace"  binding:"required"`
	Name      string `json:"name" binding:"required"`
}
