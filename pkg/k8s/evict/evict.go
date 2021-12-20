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

package evict

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	policy "k8s.io/api/policy/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

var (
	systemNamespace = "kube-system"
)

func EvictsNodePods(client *kubernetes.Clientset, nodeName string) error {
	/*
		驱逐节点上不在 kube-system 命名空间中的所有 pod
	*/
	pods, err := client.CoreV1().Pods("").List(context.TODO(), metav1.ListOptions{
		FieldSelector: "spec.nodeName=" + nodeName,
	})

	if err != nil {
		return err
	}
	for _, i := range pods.Items {
		if i.Namespace == systemNamespace {
			continue
		} else {
			common.LOG.Info(fmt.Sprintf("开始驱逐Node: %v, 节点Namespace: %v下的Pod: %v", nodeName, i.Namespace, i.Name))
			err := EvictsPod(client, i.Name, i.Namespace)
			if err != nil {
				common.LOG.Error(fmt.Sprintf("驱逐Pod：%v失败", i.Name))
			}
		}
	}
	common.LOG.Info(fmt.Sprintf("已成功从节点: %v 中驱逐所有pod", nodeName))
	return nil
}

func EvictsPod(client *kubernetes.Clientset, name, namespace string) error {
	// Pod优雅退出时间, 默认退出时间30s, 如果未指定, 则默认为每个对象的值。0表示立即删除。
	var gracePeriodSeconds int64 = 0
	propagationPolicy := metav1.DeletePropagationForeground
	deleteOptions := &metav1.DeleteOptions{
		GracePeriodSeconds: &gracePeriodSeconds,
		PropagationPolicy:  &propagationPolicy,
	}
	return client.PolicyV1beta1().Evictions(namespace).Evict(context.TODO(), &policy.Eviction{
		ObjectMeta: metav1.ObjectMeta{
			Name:      name,
			Namespace: namespace,
		},
		DeleteOptions: deleteOptions,
	})
}
