package k8s

import (
	"fmt"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models"
	"strings"
)

func GetKubeNodes(client *kubernetes.Clientset) ([]models.NodesFromK8s, string, string, error) {
	/*
		获取所有Node节点信息
	*/
	var (
		k8sNodes    []models.NodesFromK8s
		runtimeType string
		clusterName string
	)

	nodes, err := client.CoreV1().Nodes().List(metav1.ListOptions{})
	if err != nil {
		return k8sNodes, runtimeType, clusterName, fmt.Errorf("get nodes from cluster failed: %v", err)
	}
	for i, node := range nodes.Items {
		if i == 0 {
			if strings.Contains(node.Status.NodeInfo.ContainerRuntimeVersion, "docker") {
				runtimeType = "docker"
			} else {
				runtimeType = "containerd"
			}
		}

		var item models.NodesFromK8s
		item.Name = node.ObjectMeta.Name
		if _, ok := node.ObjectMeta.Labels["node-role.kubernetes.io/master"]; ok {
			item.Role = "master"
		} else {
			item.Role = "worker"
		}
		item.Architecture = node.Status.NodeInfo.Architecture

		for _, addr := range node.Status.Addresses {
			if addr.Type == "InternalIP" {
				item.Ip = addr.Address
			}
		}
		k8sNodes = append(k8sNodes, item)
	}
	return k8sNodes, runtimeType, clusterName, nil
}

func GetNodeResource(client *kubernetes.Clientset) (namespaces int, deployments int, pods int) {
	/*
		获取集群 namespace数量 deployment数量 pod数量 container数量
	*/
	namespace, err := client.CoreV1().Namespaces().List(metav1.ListOptions{})
	namespaces = len(namespace.Items)
	if err != nil {
		common.GVA_LOG.Error("list namespace err")
	}
	for _, v := range namespace.Items {
		deployment, err := client.AppsV1().Deployments(v.Name).List(metav1.ListOptions{})
		deployments += len(deployment.Items)
		if err != nil {
			common.GVA_LOG.Error("get deployment err")
		}
		pod, err := client.CoreV1().Pods(v.Name).List(metav1.ListOptions{})
		if err != nil {
			common.GVA_LOG.Error("get pod err")
		}
		pods += len(pod.Items)
	}

	return namespaces, deployments, pods
}
