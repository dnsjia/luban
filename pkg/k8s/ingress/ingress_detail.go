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

package ingress

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	v1 "k8s.io/api/extensions/v1beta1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	client "k8s.io/client-go/kubernetes"
)

// IngressDetail API resource provides mechanisms to inject containers with configuration data while keeping
// containers agnostic of Kubernetes
type IngressDetail struct {
	// Extends list item structure.
	Ingress `json:",inline"`

	// Spec is the desired state of the Ingress.
	Spec v1.IngressSpec `json:"spec"`

	// Status is the current state of the Ingress.
	Status v1.IngressStatus `json:"status"`
}

// GetIngressDetail returns detailed information about an ingress
func GetIngressDetail(client *client.Clientset, namespace, name string) (*IngressDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s ingress in %s namespace", name, namespace))

	rawIngress, err := client.ExtensionsV1beta1().Ingresses(namespace).Get(context.TODO(), name, metaV1.GetOptions{})

	if err != nil {
		return nil, err
	}

	return getIngressDetail(rawIngress), nil
}

func getIngressDetail(i *v1.Ingress) *IngressDetail {
	return &IngressDetail{
		Ingress: toIngress(i),
		Spec:    i.Spec,
		Status:  i.Status,
	}
}
