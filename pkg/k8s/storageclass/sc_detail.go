/*
Copyright 2021 The DnsJia Authors.
WebSite:  https://github.com/dnsjia/luban
Email:    OpenSource@dnsjia.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package storageclass

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/pv"
	storage "k8s.io/api/storage/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

// StorageClassDetail provides the presentation layer view of Storage Class resource.
type StorageClassDetail struct {
	// Extends list item structure.
	StorageClass         `json:",inline"`
	PersistentVolumeList pv.PersistentVolumeList `json:"persistentVolumeList"`
}

// GetStorageClassDetail returns Storage Class resource.
func GetStorageClassDetail(client kubernetes.Interface, name string) (*StorageClassDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s storage class", name))

	sc, err := client.StorageV1().StorageClasses().Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}
	persistentVolumeList, err := pv.GetStorageClassPersistentVolumes(client, sc.Name, dataselect.DefaultDataSelect)

	storageClass := toStorageClassDetail(sc, persistentVolumeList)
	return &storageClass, err
}

func toStorageClassDetail(storageClass *storage.StorageClass, persistentVolumeList *pv.PersistentVolumeList) StorageClassDetail {
	return StorageClassDetail{
		StorageClass:         toStorageClass(storageClass),
		PersistentVolumeList: *persistentVolumeList,
	}
}
