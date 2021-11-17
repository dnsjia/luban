package storageclass

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	storage "k8s.io/api/storage/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
)

// StorageClassList holds a list of Storage Class objects in the cluster.
type StorageClassList struct {
	ListMeta k8s.ListMeta   `json:"listMeta"`
	Items    []StorageClass `json:"items"`
}

// StorageClass is a representation of a Kubernetes Storage Class object.
type StorageClass struct {
	ObjectMeta    k8s.ObjectMeta                    `json:"objectMeta"`
	TypeMeta      k8s.TypeMeta                      `json:"typeMeta"`
	Provisioner   string                            `json:"provisioner"`
	Parameters    map[string]string                 `json:"parameters"`
	ReclaimPolicy *v1.PersistentVolumeReclaimPolicy `json:"reclaimPolicy,omitempty"`
}

// GetStorageClassList returns a list of all storage class objects in the cluster.
func GetStorageClassList(client kubernetes.Interface, dsQuery *dataselect.DataSelectQuery) (*StorageClassList, error) {
	common.LOG.Info("Getting list of storage classes in the cluster")

	channels := &k8scommon.ResourceChannels{
		StorageClassList: k8scommon.GetStorageClassListChannel(client, 1),
	}

	return GetStorageClassListFromChannels(channels, dsQuery)
}

// GetStorageClassListFromChannels returns a list of all storage class objects in the cluster.
func GetStorageClassListFromChannels(channels *k8scommon.ResourceChannels,
	dsQuery *dataselect.DataSelectQuery) (*StorageClassList, error) {
	storageClasses := <-channels.StorageClassList.List
	err := <-channels.StorageClassList.Error
	if err != nil {
		return nil, err
	}

	return toStorageClassList(storageClasses.Items, dsQuery), nil
}

func toStorageClassList(storageClasses []storage.StorageClass, dsQuery *dataselect.DataSelectQuery) *StorageClassList {

	storageClassList := &StorageClassList{
		Items:    make([]StorageClass, 0),
		ListMeta: k8s.ListMeta{TotalItems: len(storageClasses)},
	}

	storageClassCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(storageClasses), dsQuery)
	storageClasses = fromCells(storageClassCells)
	storageClassList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, storageClass := range storageClasses {
		storageClassList.Items = append(storageClassList.Items, toStorageClass(&storageClass))
	}

	return storageClassList
}

func toStorageClass(storageClass *storage.StorageClass) StorageClass {

	return StorageClass{
		ObjectMeta:    k8s.NewObjectMeta(storageClass.ObjectMeta),
		TypeMeta:      k8s.NewTypeMeta(k8s.ResourceKindStorageClass),
		Provisioner:   storageClass.Provisioner,
		Parameters:    storageClass.Parameters,
		ReclaimPolicy: storageClass.ReclaimPolicy,
	}
}

func DeleteStorageClass(client kubernetes.Interface, name string) (err error) {
	common.LOG.Info(fmt.Sprintf("delete of %s storage class", name))

	return client.StorageV1().StorageClasses().Delete(context.TODO(), name, metaV1.DeleteOptions{})

}
