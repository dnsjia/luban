package evict

import (
	"context"
	"fmt"
	policy "k8s.io/api/policy/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
)

func EvictNodePods(client *kubernetes.Clientset, nodeName string) error {

	pods, err := client.CoreV1().Pods("").List(context.TODO(), metav1.ListOptions{
		FieldSelector: "spec.nodeName=" + nodeName,
	})

	if err != nil {
		return err
	}
	for _, i := range pods.Items {
		if i.Namespace == "kube-system" {
			continue
		} else {
			//evict
			common.LOG.Info(fmt.Sprintf("开始驱逐Node: %v, 节点Namespace: %v下的Pod: %v", nodeName, i.Namespace, i.Name))
			err := EvictPod(client, i.Name, i.Namespace)
			if err != nil {
				common.LOG.Error(fmt.Sprintf("驱逐Pod：%v失败", i.Name))
			}
		}
	}
	return nil
}

func EvictPod(client *kubernetes.Clientset, name, namespace string) error {
	return client.PolicyV1beta1().Evictions(namespace).Evict(context.TODO(), &policy.Eviction{
		ObjectMeta: metav1.ObjectMeta{
			Name:      name,
			Namespace: namespace,
		},
	})
}
