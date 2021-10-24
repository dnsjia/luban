package node

import (
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/parser"
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
	Unschedulable      k8s.Unschedulable          `json:"unschedulable"`
	NodeIP             k8s.NodeIP                 `json:"nodeIP"`
	AllocatedResources k8s.NodeAllocatedResources `json:"allocatedResources"`
	NodeInfo           v1.NodeSystemInfo          `json:"nodeInfo"`
	//RuntimeType        string                     `json:"runtimeType"`
}

func GetNodeList(client *kubernetes.Clientset, dsQuery *gin.Context) (*NodeList, error) {
	/*
		获取所有Node节点信息
	*/

	nodes, err := client.CoreV1().Nodes().List(context.TODO(), metav1.ListOptions{})
	if err != nil {
		return nil, fmt.Errorf("get nodes from cluster failed: %v", err)
	}

	return toNodeList(client, nodes.Items, dsQuery), nil
}

func toNodeList(client *kubernetes.Clientset, nodes []v1.Node, dsQuery *gin.Context) *NodeList {

	nodeList := &NodeList{
		Nodes:    make([]Node, 0),                      // make初始化node信息
		ListMeta: k8s.ListMeta{TotalItems: len(nodes)}, // 计算node数量
	}
	// 解析前端传递的参数, filterBy=name,1.1&itemsPerPage=10&name=&namespace=default&page=1&sortBy=d,creationTimestamp
	// sortBy=d 倒序, sortBy=a 正序, 排序按照a-z
	dataSelect := parser.ParseDataSelectPathParameter(dsQuery)
	// 过滤
	nodeCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(nodes), dataSelect)
	nodes = fromCells(nodeCells)
	// 更新node数量, filteredTotal过滤后的数量
	nodeList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, node := range nodes {
		// 根据Node名称去获取节点上面的pod，过滤时排除pod为 Succeeded, Failed 返回pods
		pods, err := getNodePods(client, node)
		if err != nil {
			common.LOG.Error(fmt.Sprintf("Couldn't get pods of %s node: %s\n", node.Name, err))
		}

		// 调用toNode方法获取 node节点的计算资源
		nodeList.Nodes = append(nodeList.Nodes, toNode(node, pods, getNodeRole(node)))
	}

	return nodeList
}

func toNode(node v1.Node, pods *v1.PodList, role string) Node {
	// 获取cpu和内存的reqs, limits使用
	allocatedResources, err := getNodeAllocatedResources(node, pods)
	if err != nil {
		common.LOG.Error(fmt.Sprintf("Couldn't get allocated resources of %s node: %s\n", node.Name, err))
	}

	return Node{
		ObjectMeta:         k8s.NewObjectMeta(node.ObjectMeta),
		TypeMeta:           k8s.NewTypeMeta(k8s.ResourceKind(role)),
		Ready:              getNodeConditionStatus(node, v1.NodeReady),
		NodeIP:             k8s.NodeIP(getNodeIP(node)),
		Unschedulable:      k8s.Unschedulable(node.Spec.Unschedulable),
		AllocatedResources: allocatedResources,
		NodeInfo:           node.Status.NodeInfo,
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

func getNodeIP(node v1.Node) string {
	for _, addr := range node.Status.Addresses {
		if addr.Type == v1.NodeInternalIP {
			return addr.Address
		}
	}
	return ""
}

func getNodeRole(node v1.Node) string {
	var role string
	if _, ok := node.ObjectMeta.Labels["node-role.kubernetes.io/master"]; ok {
		role = "Master"
	} else {
		role = "Worker"
	}
	return role
}

func GetNodeResource(client *kubernetes.Clientset) (namespaces int, deployments int, pods int) {
	/*
		获取集群 namespace数量 deployment数量 pod数量 container数量
	*/
	namespace, err := client.CoreV1().Namespaces().List(context.TODO(), metav1.ListOptions{})
	namespaces = len(namespace.Items)
	if err != nil {
		common.LOG.Error("list namespace err")
	}
	for _, v := range namespace.Items {
		deployment, err := client.AppsV1().Deployments(v.Name).List(context.TODO(), metav1.ListOptions{})
		deployments += len(deployment.Items)
		if err != nil {
			common.LOG.Error("get deployment err")
		}
		pod, err := client.CoreV1().Pods(v.Name).List(context.TODO(), metav1.ListOptions{})
		if err != nil {
			common.LOG.Error("get pod err")
		}
		pods += len(pod.Items)
	}

	return namespaces, deployments, pods
}

func NodeUnschdulable(client *kubernetes.Clientset, nodeName string, unschdulable bool) (bool, error) {
	/*
		设置节点是否可调度
	*/
	common.LOG.Info(fmt.Sprintf("设置Node节点:%v  是否可调度: %v", nodeName, unschdulable))
	node, err := client.CoreV1().Nodes().Get(context.TODO(), nodeName, metav1.GetOptions{})
	if err != nil {
		return false, err
	}
	node.Spec.Unschedulable = unschdulable

	_, err = client.CoreV1().Nodes().Update(context.TODO(), node, metav1.UpdateOptions{})

	if err != nil {
		common.LOG.Error(fmt.Sprintf("设置节点调度失败：%v", err))
		return false, err
	}
	return true, nil
}
