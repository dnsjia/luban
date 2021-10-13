package k8s

import (
	"fmt"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	"strings"
)

// NodeList 包含集群中的节点列表.
type NodeList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`
	Nodes    []Node       `json:"nodes"`
}

// Node is a presentation layer view of Kubernetes nodes. This means it is node plus additional
// augmented data we can get from other sources.
type Node struct {
	ObjectMeta         k8s.ObjectMeta             `json:"objectMeta"`
	TypeMeta           k8s.TypeMeta               `json:"typeMeta"`
	Ready              v1.ConditionStatus         `json:"ready"`
	AllocatedResources k8s.NodeAllocatedResources `json:"allocatedResources"`
	RuntimeType        string                     `json:"runtimeType"`
}

func GetNodeList(client *kubernetes.Clientset) (*NodeList, error) {
	/*
		获取所有Node节点信息
	*/

	nodes, err := client.CoreV1().Nodes().List(metav1.ListOptions{})
	if err != nil {
		return nil, fmt.Errorf("get nodes from cluster failed: %v", err)
	}

	return toNodeList(client, nodes.Items), nil
}

func toNodeList(client *kubernetes.Clientset, nodes []v1.Node) *NodeList {

	nodeList := &NodeList{
		Nodes:    make([]Node, 0),                      // make初始化node信息
		ListMeta: k8s.ListMeta{TotalItems: len(nodes)}, // 计算node数量
	}
	var runtimeType string
	for i, node := range nodes {
		// todo
		if i == 0 {
			if strings.Contains(node.Status.NodeInfo.ContainerRuntimeVersion, "docker") {
				runtimeType = "docker"
			} else {
				runtimeType = "containerd"
			}
		}
		var role string
		if _, ok := node.ObjectMeta.Labels["node-role.kubernetes.io/master"]; ok {
			role = "master"
		} else {
			role = "worker"
		}
		//item.Architecture = node.Status.NodeInfo.Architecture
		//item.RuntimeType = runtimeType
		//for _, addr := range node.Status.Addresses {
		//	if addr.Type == "InternalIP" {
		//		item.Ip = addr.Address
		//	}
		//}
		//k8sNodes = append(k8sNodes, item)

		// 根据Node名称去获取节点上面的pod，过滤时排除pod为 Succeeded, Failed 返回pods
		pods, err := getNodePods(client, node)
		if err != nil {
			common.GVA_LOG.Error(fmt.Sprintf("Couldn't get pods of %s node: %s\n", node.Name, err))
		}

		// 调用toNode方法获取 node节点的计算资源
		nodeList.Nodes = append(nodeList.Nodes, toNode(node, pods, role, runtimeType))
	}

	return nodeList
}

func toNode(node v1.Node, pods *v1.PodList, role string, runtimeType string) Node {
	// 获取cpu和内存的reqs, limits使用
	allocatedResources, err := getNodeAllocatedResources(node, pods)
	if err != nil {
		common.GVA_LOG.Error(fmt.Sprintf("Couldn't get allocated resources of %s node: %s\n", node.Name, err))
	}

	return Node{
		ObjectMeta:         k8s.NewObjectMeta(node.ObjectMeta),
		TypeMeta:           k8s.NewTypeMeta(k8s.ResourceKind(role)),
		Ready:              getNodeConditionStatus(node, v1.NodeReady),
		AllocatedResources: allocatedResources,
		RuntimeType:        runtimeType,
	}
}

func getNodeConditionStatus(node v1.Node, conditionType v1.NodeConditionType) v1.ConditionStatus {
	for _, condition := range node.Status.Conditions {
		if condition.Type == conditionType {
			return condition.Status
		}
	}
	return v1.ConditionUnknown
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
