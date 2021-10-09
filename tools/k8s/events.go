package k8s

import (
	"fmt"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

func GetEvents(client *kubernetes.Clientset, namespace string) (*v1.EventList, error) {
	events, err := client.CoreV1().Events(namespace).List(
		metav1.ListOptions{
			FieldSelector: fmt.Sprintf("type=%s", "Warning"),
		},
	)
	//events, err := client.CoreV1().Events(namespace).List(metav1.ListOptions{})
	if err != nil {
		return nil, err
	}
	return events, nil
}
