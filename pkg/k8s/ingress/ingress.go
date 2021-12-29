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
	"github.com/dnsjia/luban/models/k8s"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	//v1 "k8s.io/api/extensions/v1beta1"
	v1 "k8s.io/api/networking/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	client "k8s.io/client-go/kubernetes"
)

// Ingress - a single ingress returned to the frontend.
type Ingress struct {
	k8s.ObjectMeta `json:"objectMeta"`
	k8s.TypeMeta   `json:"typeMeta"`

	// External endpoints of this ingress.
	Endpoints []k8scommon.Endpoint `json:"endpoints"`
	Hosts     []string             `json:"hosts"`
	Spec      v1.IngressSpec       `json:"spec"`
	Status    v1.IngressStatus     `json:"status"`
}

// IngressList - response structure for a queried ingress list.
type IngressList struct {
	k8s.ListMeta `json:"listMeta"`

	// Unordered list of Ingresss.
	Items []Ingress `json:"items"`
}

// GetIngressList returns all ingresses in the given namespace.
func GetIngressList(client *client.Clientset, namespace *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*IngressList, error) {
	//ingressList, err := client.ExtensionsV1beta1().Ingresses(namespace.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
	ingressList, err := client.NetworkingV1().Ingresses(namespace.ToRequestParam()).List(context.TODO(), k8s.ListEverything)

	if err != nil {
		return nil, err
	}
	return toIngressList(ingressList.Items, dsQuery), nil

}

func getEndpoints(ingress *v1.Ingress) []k8scommon.Endpoint {
	endpoints := make([]k8scommon.Endpoint, 0)
	if len(ingress.Status.LoadBalancer.Ingress) > 0 {
		for _, status := range ingress.Status.LoadBalancer.Ingress {
			endpoint := k8scommon.Endpoint{}
			if status.Hostname != "" {
				endpoint.Host = status.Hostname
			} else if status.IP != "" {
				endpoint.Host = status.IP
			}
			endpoints = append(endpoints, endpoint)
		}
	}
	return endpoints
}

func getHosts(ingress *v1.Ingress) []string {
	hosts := make([]string, 0)
	set := make(map[string]struct{})

	for _, rule := range ingress.Spec.Rules {
		if _, exists := set[rule.Host]; !exists && len(rule.Host) > 0 {
			hosts = append(hosts, rule.Host)
		}

		set[rule.Host] = struct{}{}
	}

	return hosts
}

func toIngress(ingress *v1.Ingress) Ingress {
	return Ingress{
		ObjectMeta: k8s.NewObjectMeta(ingress.ObjectMeta),
		TypeMeta:   k8s.NewTypeMeta(k8s.ResourceKindIngress),
		Endpoints:  getEndpoints(ingress),
		Hosts:      getHosts(ingress),
		Spec:       ingress.Spec,
		Status:     ingress.Status,
	}
}

func toIngressList(ingresses []v1.Ingress, dsQuery *dataselect.DataSelectQuery) *IngressList {
	newIngressList := &IngressList{
		ListMeta: k8s.ListMeta{TotalItems: len(ingresses)},
		Items:    make([]Ingress, 0),
	}

	ingresCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(ingresses), dsQuery)
	ingresses = fromCells(ingresCells)
	newIngressList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, ingress := range ingresses {
		newIngressList.Items = append(newIngressList.Items, toIngress(&ingress))
	}

	return newIngressList
}

func DeleteIngress(client *client.Clientset, namespace string, name string) error {
	common.LOG.Info(fmt.Sprintf("请求删除Ingress: %v, namespace: %v", name, namespace))
	return client.ExtensionsV1beta1().Ingresses(namespace).Delete(
		context.TODO(),
		name,
		metav1.DeleteOptions{},
	)
}

func DeleteCollectionIngress(client *client.Clientset, ingressList []k8s.ServiceData) (err error) {
	common.LOG.Info("批量删除Ingress开始")
	for _, v := range ingressList {
		common.LOG.Info(fmt.Sprintf("delete ingress：%v, ns: %v", v.Name, v.Namespace))
		err := client.ExtensionsV1beta1().Ingresses(v.Namespace).Delete(
			context.TODO(),
			v.Name,
			metav1.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除ingress已完成")
	return nil
}
