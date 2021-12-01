package node

import (
	"context"
	"errors"
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/k8s"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/evict"
	"github.com/dnsjia/luban/pkg/k8s/parser"
	"github.com/gin-gonic/gin"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"time"
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
	common.LOG.Info(fmt.Sprintf("设置Node节点:%v  不可调度: %v", nodeName, unschdulable))
	node, err := client.CoreV1().Nodes().Get(context.TODO(), nodeName, metav1.GetOptions{})
	if err != nil {
		common.LOG.Error(fmt.Sprintf("get node err: %v", err.Error()))
		return false, err
	}
	node.Spec.Unschedulable = unschdulable

	_, err2 := client.CoreV1().Nodes().Update(context.TODO(), node, metav1.UpdateOptions{})

	if err2 != nil {
		common.LOG.Error(fmt.Sprintf("设置节点调度失败：%v", err2.Error()))
		return false, err2
	}
	return true, nil
}

func CordonNode(client *kubernetes.Clientset, nodeName string) (bool, error) {
	/*
		排空节点
		选择排空节点（同时设置为不可调度），在后续进行应用部署时，则Pod不会再调度到该节点，并且该节点上由DaemonSet控制的Pod不会被排空。
		kubectl drain cn-beijing.i-2ze19qyi8votgjz12345 --grace-period=120 --ignore-daemonsets=true
	*/
	_, err := NodeUnschdulable(client, nodeName, true)
	if err != nil {
		return false, err
	}
	err = evict.EvictsNodePods(client, nodeName)
	if err != nil {
		common.LOG.Error(fmt.Sprintf("排空节点出现异常: %v", err.Error()))
		return false, err
	}
	return true, nil

}

func RemoveNode(client *kubernetes.Clientset, nodeName string) (bool, error) {
	startTime := time.Now()
	common.LOG.Info(fmt.Sprintf("移除Node节点:%v, 异步任务已开始", nodeName))
	_, err := NodeUnschdulable(client, nodeName, true)
	if err != nil {
		return false, err
	}
	err = evict.EvictsNodePods(client, nodeName)
	if err != nil {
		common.LOG.Error(fmt.Sprintf("排空节点出现异常: %v", err.Error()))
		return false, err
	}
	err2 := client.CoreV1().Nodes().Delete(context.TODO(), nodeName, metav1.DeleteOptions{})
	if err2 != nil {
		return false, err2
	}
	common.LOG.Info(fmt.Sprintf("已将节点：%v从集群中移除, 异步任务已完成,任务耗时：%v", nodeName, time.Since(startTime)))

	return true, nil
}

func CollectionNodeUnschedule(client *kubernetes.Clientset, nodeName []string) error {
	/*
		批量设置Node节点不可调度
		{"node_name": ["k8s-master", "k8s-node"]}
	*/
	if len(nodeName) <= 0 {
		return errors.New("节点名称不能为空")
	}
	common.LOG.Info(fmt.Sprintf("批量设置Node节点:%v  不可调度：true", nodeName))
	for _, v := range nodeName {
		node, err := client.CoreV1().Nodes().Get(context.TODO(), v, metav1.GetOptions{})
		if err != nil {
			common.LOG.Error(fmt.Sprintf("get node err: %v", err.Error()))
			return err
		}
		node.Spec.Unschedulable = true

		_, err2 := client.CoreV1().Nodes().Update(context.TODO(), node, metav1.UpdateOptions{})

		if err2 != nil {
			common.LOG.Error(fmt.Sprintf("设置节点调度失败：%v", err2.Error()))
			return err
		}
	}
	common.LOG.Info(fmt.Sprintf("已将所有Node节点:%v  设置为不可调度", nodeName))
	return nil
}

func CollectionCordonNode(client *kubernetes.Clientset, nodeName []string) error {
	/*
		批量排空Node节点， 不允许调度
		{"node_name": ["k8s-master", "k8s-node"]}
	*/

	if len(nodeName) <= 0 {
		return errors.New("节点名称不能为空")
	}
	common.LOG.Info(fmt.Sprintf("开始排空节点, 设置Node节点:%v  不可调度：true", nodeName))
	for _, v := range nodeName {
		node, err := client.CoreV1().Nodes().Get(context.TODO(), v, metav1.GetOptions{})
		if err != nil {
			common.LOG.Error(fmt.Sprintf("get node err: %v", err.Error()))
			return err
		}
		node.Spec.Unschedulable = true

		_, err2 := client.CoreV1().Nodes().Update(context.TODO(), node, metav1.UpdateOptions{})

		if err2 != nil {
			common.LOG.Error(fmt.Sprintf("设置节点调度失败：%v", err2.Error()))
			return err
		}
		_, cordonErr := CordonNode(client, v)
		if cordonErr != nil {
			return cordonErr
		}
	}
	common.LOG.Info(fmt.Sprintf("已将所有Node节点:%v  设置为不可调度", nodeName))
	return nil
}
