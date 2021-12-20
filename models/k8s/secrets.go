package k8s

type SecretsData struct {
	Namespace string `json:"namespace"  binding:"required"`
	Name      string `json:"name" binding:"required"`
}
