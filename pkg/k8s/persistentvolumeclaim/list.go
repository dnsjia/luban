package persistentvolumeclaim

import (
	v1 "k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
)

// PersistentVolumeClaimList contains a list of Persistent Volume Claims in the cluster.
type PersistentVolumeClaimList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// Unordered list of persistent volume claims
	Items []PersistentVolumeClaim `json:"items"`

	// List of non-critical errors, that occurred during resource retrieval.
	Errors []error `json:"errors"`
}

// PersistentVolumeClaim provides the simplified presentation layer view of Kubernetes Persistent Volume Claim resource.
type PersistentVolumeClaim struct {
	ObjectMeta   k8s.ObjectMeta                  `json:"objectMeta"`
	TypeMeta     k8s.TypeMeta                    `json:"typeMeta"`
	Status       string                          `json:"status"`
	Volume       string                          `json:"volume"`
	Capacity     v1.ResourceList                 `json:"capacity"`
	AccessModes  []v1.PersistentVolumeAccessMode `json:"accessModes"`
	StorageClass *string                         `json:"storageClass"`
}

// GetPersistentVolumeClaimList returns a list of all Persistent Volume Claims in the cluster.
func GetPersistentVolumeClaimList(client kubernetes.Interface, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*PersistentVolumeClaimList, error) {

	common.LOG.Info("Getting list persistent volumes claims")
	channels := &k8scommon.ResourceChannels{
		PersistentVolumeClaimList: k8scommon.GetPersistentVolumeClaimListChannel(client, nsQuery, 1),
	}

	return GetPersistentVolumeClaimListFromChannels(channels, nsQuery, dsQuery)
}

// GetPersistentVolumeClaimListFromChannels returns a list of all Persistent Volume Claims in the cluster
// reading required resource list once from the channels.
func GetPersistentVolumeClaimListFromChannels(channels *k8scommon.ResourceChannels, nsQuery *k8scommon.NamespaceQuery,
	dsQuery *dataselect.DataSelectQuery) (*PersistentVolumeClaimList, error) {

	persistentVolumeClaims := <-channels.PersistentVolumeClaimList.List
	err := <-channels.PersistentVolumeClaimList.Error
	if err != nil {
		return nil, err
	}

	return toPersistentVolumeClaimList(persistentVolumeClaims.Items, dsQuery), nil
}

func toPersistentVolumeClaim(pvc v1.PersistentVolumeClaim) PersistentVolumeClaim {
	return PersistentVolumeClaim{
		ObjectMeta:   k8s.NewObjectMeta(pvc.ObjectMeta),
		TypeMeta:     k8s.NewTypeMeta(k8s.ResourceKindPersistentVolumeClaim),
		Status:       string(pvc.Status.Phase),
		Volume:       pvc.Spec.VolumeName,
		Capacity:     pvc.Status.Capacity,
		AccessModes:  pvc.Spec.AccessModes,
		StorageClass: pvc.Spec.StorageClassName,
	}
}

func toPersistentVolumeClaimList(persistentVolumeClaims []v1.PersistentVolumeClaim, dsQuery *dataselect.DataSelectQuery) *PersistentVolumeClaimList {

	result := &PersistentVolumeClaimList{
		Items:    make([]PersistentVolumeClaim, 0),
		ListMeta: k8s.ListMeta{TotalItems: len(persistentVolumeClaims)},
	}

	pvcCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(persistentVolumeClaims), dsQuery)
	persistentVolumeClaims = fromCells(pvcCells)
	result.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, item := range persistentVolumeClaims {
		result.Items = append(result.Items, toPersistentVolumeClaim(item))
	}

	return result
}
