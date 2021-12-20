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

package service

import (
	"context"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/event"
	"github.com/dnsjia/luban/pkg/k8s/pods"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/fields"
	"k8s.io/apimachinery/pkg/labels"
	"k8s.io/client-go/kubernetes"
)

// GetServicePods gets list of pods targeted by given label selector in given namespace.
func GetServicePods(client *kubernetes.Clientset, namespace, name string, dsQuery *dataselect.DataSelectQuery) (*pods.PodList, error) {
	podList := pods.PodList{
		Pods: []pods.Pod{},
	}

	service, err := client.CoreV1().Services(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return &podList, err
	}

	if service.Spec.Selector == nil {
		return &podList, nil
	}

	labelSelector := labels.SelectorFromSet(service.Spec.Selector)
	channels := &k8scommon.ResourceChannels{
		PodList: k8scommon.GetPodListChannelWithOptions(client, k8scommon.NewSameNamespaceQuery(namespace),
			metaV1.ListOptions{
				LabelSelector: labelSelector.String(),
				FieldSelector: fields.Everything().String(),
			}, 1),
	}

	apiPodList := <-channels.PodList.List
	if err := <-channels.PodList.Error; err != nil {
		return &podList, err
	}

	events, err := event.GetPodsEvents(client, namespace, apiPodList.Items)

	if err != nil {
		return &podList, err
	}

	podList = pods.ToPodList(apiPodList.Items, events, dsQuery)
	return &podList, nil
}
