package ingress

import (
	"context"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"
	"log"
	"testing"
)

func TestGetIngressList(t *testing.T) {

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

	ingressList, err := client.ExtensionsV1beta1().Ingresses("").List(context.TODO(), metav1.ListOptions{})

	log.Print(ingressList)

}
