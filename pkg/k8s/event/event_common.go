package event

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

// GetNodeEvents gets events associated to node with given name.
func GetNodeEvents(client *kubernetes.Clientset, nodeName string) (*v1.EventList, error) {

	//scheme := runtime.NewScheme()
	//groupVersion := schema.GroupVersion{Group: "", Version: "v1"}
	//scheme.AddKnownTypes(groupVersion, &v1.Node{})
	//
	//node, err := client.CoreV1().Nodes().Get(context.TODO(), nodeName, metaV1.GetOptions{})
	//
	//if err != nil {
	//	return nil, err
	//}
	events, err := client.CoreV1().Events(v1.NamespaceAll).List(context.TODO(),
		metaV1.ListOptions{FieldSelector: fmt.Sprintf("involvedObject.name=%v", nodeName)})

	//events, err := client.CoreV1().Events(v1.NamespaceAll).Search(scheme, node)

	if err != nil {
		return nil, err
	}

	return events, nil
}
