package service

import (
	"context"
	"fmt"
	"go.uber.org/zap"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/pkg/k8s/deployment"
)

func GetDeploymentToService(client *kubernetes.Clientset, ns string, deploymentName string) (*v1.ServiceList, error) {

	deploymentData, err := deployment.GetDeploymentDetail(client, ns, deploymentName)
	if err != nil {
		common.LOG.Error("获取deployment详情异常", zap.Any("err: ", err))
		return nil, err
	}
	for k, v := range deploymentData.Selector {
		selector := fmt.Sprintf("%v=%v", k, v)
		common.LOG.Info(fmt.Sprintf("根据label过滤service: %v", selector))
		svc, err := client.CoreV1().Services(ns).List(context.TODO(), metav1.ListOptions{
			LabelSelector: selector,
		})
		if err != nil {
			common.LOG.Error("根据deployment获取service异常", zap.Any("err: ", err))
			return nil, err
		}
		return svc, nil
	}

	return nil, err

	//selector := ""
	//for k, v := range deploymentData.Selector {
	//	selector += fmt.Sprintf("%v=%v,", k, v)
	//}
	//selector = removeLastRune(selector)
	//common.LOG.Info(fmt.Sprintf("根据label过滤service: %v", selector))
	//svc, err := client.CoreV1().Services(ns).List(context.TODO(), metav1.ListOptions{
	//	LabelSelector: selector,
	//})
	//if err != nil {
	//	common.LOG.Error("根据deployment获取service异常", zap.Any("err: ", err))
	//	return nil, err
	//}
	//
	//return svc, nil
}

func DeleteService(client *kubernetes.Clientset, ns string, serviceName string) error {
	common.LOG.Info(fmt.Sprintf("请求删除Service: %v, namespace: %v", serviceName, ns))
	return client.CoreV1().Services(ns).Delete(
		context.TODO(),
		serviceName,
		metav1.DeleteOptions{},
	)
}

func removeLastRune(s string) string {
	r := []rune(s)
	return string(r[:len(r)-1])
}
