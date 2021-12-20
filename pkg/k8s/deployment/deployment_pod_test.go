package deployment

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/labels"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"
	"log"
	"testing"
)

func TestGetDeploymentToPod(t *testing.T) {
	rules := clientcmd.NewDefaultClientConfigLoadingRules()
	overrides := &clientcmd.ConfigOverrides{ClusterInfo: clientcmdapi.Cluster{InsecureSkipTLSVerify: true}}
	config, err := clientcmd.NewNonInteractiveDeferredLoadingClientConfig(rules, overrides).ClientConfig()
	if err != nil {
		log.Fatalf("Couldn't get Kubernetes default config: %s", err)
	}

	client, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatalln(err)
	}
	namespace := "default"
	name := "nginx"
	selector := getDeployment(client, namespace, name)
	pod, err := getPod(client, namespace, selector)
	if err != nil {
		log.Fatalln(err)
	}
	fmt.Printf("podList: %v\n", pod)

}

func getDeployment(client *kubernetes.Clientset, namespace, name string) (selector labels.Selector) {
	fmt.Println("开始获取deployment")
	deployment, err := client.AppsV1().Deployments(namespace).Get(context.TODO(), name, metav1.GetOptions{})
	if err != nil {
		fmt.Println(err)
	}

	selector, _ = metav1.LabelSelectorAsSelector(deployment.Spec.Selector)

	return selector
}

func getPod(client *kubernetes.Clientset, namespace string, selector labels.Selector) (*v1.PodList, error) {
	fmt.Println("根据deployment过滤pod")
	pod, err := client.CoreV1().Pods(namespace).List(context.TODO(), metav1.ListOptions{
		LabelSelector: selector.String(),
	})
	if err != nil {
		return nil, err
	}

	return pod, nil
}
