package cluster

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
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

	scheme := runtime.NewScheme()
	groupVersion := schema.GroupVersion{Group: "", Version: "v1"}
	scheme.AddKnownTypes(groupVersion, &v1.Node{})
	events, err := clientset.CoreV1().Events(v1.NamespaceAll).List(context.TODO(),
		metav1.ListOptions{FieldSelector: fmt.Sprintf("involvedObject.name=%v", "192.168.1.16")})
	fmt.Println(err)
	d, _ := json.Marshal(events)
	fmt.Println(string(d))
}
