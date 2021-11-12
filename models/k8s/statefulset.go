package k8s

type StatefulSetData struct {
	Namespace string `json:"namespace"  binding:"required"`
	Name      string `json:"name" binding:"required"`
}

type ScaleStatefulSet struct {
	ScaleNumber *int32 `json:"scaleNumber" binding:"required"`
	Namespace   string `json:"namespace" binding:"required"`
	Name        string `json:"name" binding:"required"`
}
