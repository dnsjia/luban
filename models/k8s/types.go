package k8s

import metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"

// NewObjectMeta returns internal endpoint name for the given service properties, e.g.,
// NewObjectMeta creates a new instance of ObjectMeta struct based on K8s object meta.
func NewObjectMeta(k8SObjectMeta metaV1.ObjectMeta) ObjectMeta {
	return ObjectMeta{
		Name:              k8SObjectMeta.Name,
		Namespace:         k8SObjectMeta.Namespace,
		Labels:            k8SObjectMeta.Labels,
		CreationTimestamp: Time(k8SObjectMeta.CreationTimestamp),
		Annotations:       k8SObjectMeta.Annotations,
	}
}

// NewTypeMeta creates new type mete for the resource kind.
func NewTypeMeta(kind ResourceKind) TypeMeta {
	return TypeMeta{
		Kind: kind,
	}
}
