package cluster

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/json"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"
	"log"
	"testing"
)

func TestGetNodeList(t *testing.T) {
	rules := clientcmd.NewDefaultClientConfigLoadingRules()
	overrides := &clientcmd.ConfigOverrides{ClusterInfo: clientcmdapi.Cluster{InsecureSkipTLSVerify: true}}
	config, err := clientcmd.NewNonInteractiveDeferredLoadingClientConfig(rules, overrides).ClientConfig()
	if err != nil {
		log.Fatalf("Couldn't get Kubernetes default config: %s", err)
	}

	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatalln(err)
	}

	//nodes, err := clientset.CoreV1().Nodes().List(context.TODO(), metav1.ListOptions{})
	//for _, c := range nodes.Items {
	//	j, _ := json.Marshal(c)
	//	fmt.Println(string(j))
	//}

	selector, namespace := getDeployment(clientset)

	fmt.Println(selector)

	//pod, err := getPod(clientset, namespace, selector)
	fmt.Println("根据pod过滤endpoint")
	getEndpoint(clientset, namespace, selector)

	//for _, v2 := range pod.Items {
	//
	//	fmt.Println("根据pod过滤endpoint")
	//	getEndpoint(clientset, namespace, selector)
	//
	//	fmt.Println("根据endpoint过滤svc")
	//	//svc, err := clientset.CoreV1().Services(namespace).List(context.TODO(), metav1.ListOptions{
	//	//	FieldSelector: v2.Status.PodIP,
	//	//})
	//	//if err != nil {
	//	//	return
	//	//}
	//	//s, _ := json.Marshal(svc)
	//	//fmt.Println(string(s))
	//}

}

func getDeployment(clientset *kubernetes.Clientset) (selector, namespace string) {
	fmt.Println("开始获取deployment")
	deployment, err := clientset.AppsV1().Deployments("default").Get(context.TODO(), "nginx", metav1.GetOptions{})
	if err != nil {
		fmt.Println(err)
	}

	selector = ""
	fmt.Println("deployment返回的标签:", deployment.Labels)
	if len(deployment.Labels) == 1 {
		for k, v := range deployment.Labels {
			selector = fmt.Sprintf("%v=%v", k, v)
		}
	} else {
		for k, v := range deployment.Labels {
			selector += fmt.Sprintf("%v=%v,", k, v)
		}
		selector = removeLastRune(selector)
	}

	deploymentJson, _ := json.Marshal(deployment)
	fmt.Printf("返回的deployment数据:%v\n", string(deploymentJson))
	return selector, deployment.Namespace
}

func getPod(clientset *kubernetes.Clientset, namespace, selector string) (*v1.PodList, error) {
	fmt.Println("根据deployment过滤pod")
	pod, err := clientset.CoreV1().Pods(namespace).List(context.TODO(), metav1.ListOptions{
		LabelSelector: selector,
	})
	if err != nil {
		return nil, err
	}
	podJson, _ := json.Marshal(pod)
	fmt.Printf("返回的pod数据：%v\n", string(podJson))
	return pod, nil
}

func getEndpoint(clientset *kubernetes.Clientset, namespace string, lable string) *v1.EndpointsList {
	endpodint, errr := clientset.CoreV1().Endpoints(namespace).List(context.TODO(), metav1.ListOptions{LabelSelector: lable})
	if errr != nil {
		fmt.Printf("获取endpoint出错：%v\n", errr.Error())
	}
	endpodintJson, _ := json.Marshal(endpodint)
	fmt.Printf("返回的endpoint:%v\n", string(endpodintJson))

	return endpodint
}

func removeLastRune(s string) string {
	r := []rune(s)
	return string(r[:len(r)-1])
}
