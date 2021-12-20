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
