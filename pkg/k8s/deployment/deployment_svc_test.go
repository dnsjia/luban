package deployment

import (
	"context"
	"encoding/json"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"
	"log"
	"os"
	"strings"
	"testing"
)

func TestGetDeploymentToSVC(t *testing.T) {
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
	namespace := "develop"
	name := "service"
	//selector := getDeployment(client, namespace, name)
	svcData, err := getSvc(client, namespace, name)
	if err != nil {
		log.Fatalln(err)
	}
	svcJSON, _ := json.Marshal(svcData)
	fmt.Printf("svcList: %s\n", svcJSON)

}

func getSvc(client *kubernetes.Clientset, namespace string, name string) (svc *v1.Service, err error) {
	svcList, err := client.CoreV1().Services(namespace).List(context.TODO(), metav1.ListOptions{})
	fmt.Printf("开始获取svc: %v\n", svcList)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}
	for _, svc := range svcList.Items {
		if strings.Contains(svc.Name, name) {
			fmt.Fprintf(os.Stdout, "service name: %v\n", svc.Name)
			return &svc, nil
		}
	}
	return svc, nil

}
