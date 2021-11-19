package pv

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	client "k8s.io/client-go/kubernetes"
	"pigs/common"
)

// PersistentVolumeDetail provides the presentation layer view of Kubernetes Persistent Volume resource.
type PersistentVolumeDetail struct {
	// Extends list item structure.
	PersistentVolume `json:",inline"`

	Message                string                    `json:"message"`
	PersistentVolumeSource v1.PersistentVolumeSource `json:"persistentVolumeSource"`
}

// GetPersistentVolumeDetail returns detailed information about a persistent volume
func GetPersistentVolumeDetail(client client.Interface, name string) (*PersistentVolumeDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s persistent volume", name))

	rawPersistentVolume, err := client.CoreV1().PersistentVolumes().Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	return getPersistentVolumeDetail(*rawPersistentVolume), nil
}

func getPersistentVolumeDetail(pv v1.PersistentVolume) *PersistentVolumeDetail {
	return &PersistentVolumeDetail{
		PersistentVolume:       toPersistentVolume(pv),
		Message:                pv.Status.Message,
		PersistentVolumeSource: pv.Spec.PersistentVolumeSource,
	}
}
