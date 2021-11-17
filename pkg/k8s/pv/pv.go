package pv

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
)

// PersistentVolumeList contains a list of Persistent Volumes in the cluster.
type PersistentVolumeList struct {
	ListMeta k8s.ListMeta       `json:"listMeta"`
	Items    []PersistentVolume `json:"items"`
}

// PersistentVolume provides the simplified presentation layer view of Kubernetes Persistent Volume resource.
type PersistentVolume struct {
	ObjectMeta    k8s.ObjectMeta                   `json:"objectMeta"`
	TypeMeta      k8s.TypeMeta                     `json:"typeMeta"`
	Capacity      v1.ResourceList                  `json:"capacity"`
	AccessModes   []v1.PersistentVolumeAccessMode  `json:"accessModes"`
	ReclaimPolicy v1.PersistentVolumeReclaimPolicy `json:"reclaimPolicy"`
	StorageClass  string                           `json:"storageClass"`
	MountOptions  []string                         `json:"mountOptions"`
	Status        v1.PersistentVolumePhase         `json:"status"`
	Claim         string                           `json:"claim"`
	Reason        string                           `json:"reason"`
}

// GetPersistentVolumeList returns a list of all Persistent Volumes in the cluster.
func GetPersistentVolumeList(client kubernetes.Interface, dsQuery *dataselect.DataSelectQuery) (*PersistentVolumeList, error) {
	common.LOG.Info("Getting list persistent volumes")
	channels := &k8scommon.ResourceChannels{
		PersistentVolumeList: k8scommon.GetPersistentVolumeListChannel(client, 1),
	}

	return GetPersistentVolumeListFromChannels(channels, dsQuery)
}

// GetPersistentVolumeListFromChannels returns a list of all Persistent Volumes in the cluster
// reading required resource list once from the channels.
func GetPersistentVolumeListFromChannels(channels *k8scommon.ResourceChannels, dsQuery *dataselect.DataSelectQuery) (*PersistentVolumeList, error) {
	persistentVolumes := <-channels.PersistentVolumeList.List
	err := <-channels.PersistentVolumeList.Error
	if err != nil {
		return nil, err
	}

	return toPersistentVolumeList(persistentVolumes.Items, dsQuery), nil
}

func toPersistentVolumeList(persistentVolumes []v1.PersistentVolume, dsQuery *dataselect.DataSelectQuery) *PersistentVolumeList {

	result := &PersistentVolumeList{
		Items:    make([]PersistentVolume, 0),
		ListMeta: k8s.ListMeta{TotalItems: len(persistentVolumes)},
	}

	pvCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(persistentVolumes), dsQuery)
	persistentVolumes = fromCells(pvCells)
	result.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, item := range persistentVolumes {
		result.Items = append(result.Items, toPersistentVolume(item))
	}

	return result
}

func toPersistentVolume(pv v1.PersistentVolume) PersistentVolume {
	return PersistentVolume{
		ObjectMeta:    k8s.NewObjectMeta(pv.ObjectMeta),
		TypeMeta:      k8s.NewTypeMeta(k8s.ResourceKindPersistentVolume),
		Capacity:      pv.Spec.Capacity,
		AccessModes:   pv.Spec.AccessModes,
		ReclaimPolicy: pv.Spec.PersistentVolumeReclaimPolicy,
		StorageClass:  pv.Spec.StorageClassName,
		MountOptions:  pv.Spec.MountOptions,
		Status:        pv.Status.Phase,
		Claim:         getPersistentVolumeClaim(&pv),
		Reason:        pv.Status.Reason,
	}
}

func DeletePersistentVolume(client *kubernetes.Clientset, name string) (err error) {
	common.LOG.Info(fmt.Sprintf("Start deleting persistent volume, name: %v", name))
	return client.CoreV1().PersistentVolumes().Delete(context.TODO(), name, metav1.DeleteOptions{})
}
