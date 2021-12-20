package pvc

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

// PersistentVolumeClaimDetail provides the presentation layer view of Kubernetes Persistent Volume Claim resource.
type PersistentVolumeClaimDetail struct {
	// Extends list item structure.
	PersistentVolumeClaim `json:",inline"`
}

// GetPersistentVolumeClaimDetail returns detailed information about a persistent volume claim
func GetPersistentVolumeClaimDetail(client kubernetes.Interface, namespace string, name string) (*PersistentVolumeClaimDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s persistent volume claim", name))

	pvc, err := client.CoreV1().PersistentVolumeClaims(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	return getPersistentVolumeClaimDetail(*pvc), nil
}

func getPersistentVolumeClaimDetail(pvc v1.PersistentVolumeClaim) *PersistentVolumeClaimDetail {
	return &PersistentVolumeClaimDetail{
		PersistentVolumeClaim: toPersistentVolumeClaim(pvc),
	}
}
