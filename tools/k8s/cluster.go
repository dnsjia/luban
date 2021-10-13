package k8s

import (
	"fmt"
	"github.com/prometheus/common/expfmt"
	"go.uber.org/zap"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models"
	"pigs/tools"
	"strings"
)

func GetClusterVersion(c *kubernetes.Clientset) (string, error) {
	/*
		获取k8s 集群版本
	*/
	version, err := c.ServerVersion()

	if err != nil {
		return "", fmt.Errorf("get version from cluster failed: %v", err.Error())
	}

	return version.String(), nil
}

func GetClusterNodesNumber(c *kubernetes.Clientset) (int, error) {
	/*
		获取k8s node节点数量
	*/
	nodes, err := c.CoreV1().Nodes().List(metav1.ListOptions{})
	if err != nil {
		return 0, err
	}
	return len(nodes.Items), nil
}

func GetClusterNodesRunningStatus(c *kubernetes.Clientset, m *models.ClusterNodesStatus) *models.ClusterNodesStatus {
	/*
		统计k8s 集群node节点 就绪数量
	*/
	nodes, err := c.CoreV1().Nodes().List(metav1.ListOptions{})
	if err != nil {
		common.GVA_LOG.Error("get nodes err")
	}

	var ready int = 0
	var unready int = 0
	for _, node := range nodes.Items {
		listNode, _ := c.CoreV1().Nodes().Get(node.ObjectMeta.Name, metav1.GetOptions{})

		if len(listNode.Status.Conditions) >= 0 {
			if string(listNode.Status.Conditions[len(listNode.Status.Conditions)-1].Status) == "True" {
				ready += 1
			} else {
				unready += 1
			}
		} else {
			common.GVA_LOG.Error("get nodes ready err")
			return &models.ClusterNodesStatus{}
		}
	}
	m.Ready = ready
	m.UnReady = unready
	return m
}

func GetClusterInfo(c *kubernetes.Clientset) *models.ClusterNodesStatus {
	/*
		获取集群信息
	*/
	var node models.ClusterNodesStatus
	//nodeNumber, _ := GetClusterNodesNumber(c)
	//node.Total = nodeNumber

	// eg: node节点不健康
	_ = GetClusterNodesRunningStatus(c, &node)

	//namespace, deployment, pod := GetNodeResource(c)
	//node.Namespace = namespace
	//node.Deployment = deployment
	//node.Pod = pod

	data, _ := c.RESTClient().Get().AbsPath("/api/v1/namespaces/kube-system/services/tke-kube-state-metrics:http-metrics/proxy/metrics").DoRaw()

	var parser expfmt.TextParser
	mf, err := parser.TextToMetricFamilies(strings.NewReader(string(data)))
	if err != nil {
		common.GVA_LOG.Error("解析metrics错误", zap.Any("err:", err))
		return nil
	}

	var (
		// cpuUsage
		kubePodContainerResourceRequestsCpuCores float64 = 0
		kubeNodeStatusCapacityCpuCores           float64 = 0
		// memoryUsage
		kubePodContainerResourceRequestsMemoryBytes float64 = 0
		kubeNodeStatusAllocatableMemoryBytes        float64 = 0
	)

	for metricIndex, metricValue := range mf {
		// sum(kube_pod_container_resource_requests_cpu_cores{node!~"master-.*"})/sum(kube_node_status_capacity_cpu_cores{node!~"master-.*"})*100
		if metricIndex == "kube_pod_container_resource_requests_cpu_cores" {
			for _, metric := range metricValue.GetMetric() {
				kubePodContainerResourceRequestsCpuCores += *metric.Gauge.Value
			}
		}
		if metricIndex == "kube_node_status_capacity_cpu_cores" {
			for _, metric := range metricValue.GetMetric() {
				kubeNodeStatusCapacityCpuCores += *metric.Gauge.Value
			}
		}
		// sum(kube_pod_container_resource_requests_memory_bytes{node!~"master-.*"})/sum(kube_node_status_allocatable_memory_bytes{node!~"master-.*"})*100
		if metricIndex == "kube_pod_container_resource_requests_memory_bytes" {
			for _, metric := range metricValue.GetMetric() {
				kubePodContainerResourceRequestsMemoryBytes += *metric.Gauge.Value
			}
		}
		if metricIndex == "kube_node_status_allocatable_memory_bytes" {
			for _, metric := range metricValue.GetMetric() {
				kubeNodeStatusAllocatableMemoryBytes += *metric.Gauge.Value
			}
		}

		// 计算Node节点数量
		if metricIndex == "kube_node_info" {
			node.NodeCount = len(metricValue.Metric)
		}

	}

	node.CpuCore = tools.ParseFloat2F(kubePodContainerResourceRequestsCpuCores)
	node.CpuUsage = tools.ParseFloat2F(kubePodContainerResourceRequestsCpuCores / kubeNodeStatusCapacityCpuCores * 100)
	node.CpuCapacityCore = tools.ParseFloat2F(kubeNodeStatusCapacityCpuCores)

	node.MemoryUsed = tools.ParseFloat2F(kubePodContainerResourceRequestsMemoryBytes / 1024 / 1024 / 1024)
	node.MemoryUsage = tools.ParseFloat2F(kubePodContainerResourceRequestsMemoryBytes / kubeNodeStatusAllocatableMemoryBytes * 100)
	node.MemoryTotal = tools.ParseFloat2F(kubeNodeStatusAllocatableMemoryBytes / 1024 / 1024 / 1024)

	return &node

}
