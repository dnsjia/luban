package k8s

type ServiceData struct {
	Namespace string `json:"namespace"  binding:"required"`
	Name      string `json:"name" binding:"required"`
}
