package logs

import (
	"context"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/models/k8s"
	"pigs/pkg/k8s/common"
	"pigs/pkg/k8s/controller"
)

// GetLogSources returns all log sources for a given resource. A log source identifies a log file through the combination of pod & container
func GetLogSources(k8sClient kubernetes.Interface, ns string, resourceName string, resourceType string) (controller.LogSources, error) {
	if resourceType == "pod" {
		return getLogSourcesFromPod(k8sClient, ns, resourceName)
	}
	return getLogSourcesFromController(k8sClient, ns, resourceName, resourceType)
}

// GetLogSourcesFromPod returns all containers for a given pod
func getLogSourcesFromPod(k8sClient kubernetes.Interface, ns, resourceName string) (controller.LogSources, error) {
	pod, err := k8sClient.CoreV1().Pods(ns).Get(context.TODO(), resourceName, meta.GetOptions{})
	if err != nil {
		return controller.LogSources{}, err
	}
	return controller.LogSources{
		ContainerNames:     common.GetContainerNames(&pod.Spec),
		InitContainerNames: common.GetInitContainerNames(&pod.Spec),
		PodNames:           []string{resourceName},
	}, nil
}

// GetLogSourcesFromController returns all pods and containers for a controller object, such as ReplicaSet
func getLogSourcesFromController(k8sClient kubernetes.Interface, ns, resourceName, resourceType string) (controller.LogSources, error) {
	ref := meta.OwnerReference{Kind: resourceType, Name: resourceName}
	rc, err := controller.NewResourceController(ref, ns, k8sClient)
	if err != nil {
		return controller.LogSources{}, err
	}
	allPods, err := k8sClient.CoreV1().Pods(ns).List(context.TODO(), k8s.ListEverything)
	if err != nil {
		return controller.LogSources{}, err
	}
	return rc.GetLogSources(allPods.Items), nil
}
