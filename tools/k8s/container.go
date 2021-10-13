package k8s

import (
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"pigs/common"
	"pigs/services"
	"strconv"
)

// GetK8sClient 获取k8s Client
func GetK8sClient(k8sConf string) (*kubernetes.Clientset, error) {

	config, err := clientcmd.RESTConfigFromKubeConfig([]byte(k8sConf))
	// skips the validity check for the server's certificate. This will make your HTTPS connections insecure.
	// config.TLSClientConfig.Insecure = true
	if err != nil {
		common.GVA_LOG.Error("KubeConfig内容错误", zap.Any("err", err))
		return nil, errors.New("KubeConfig内容错误")
	}

	clientSet, err := kubernetes.NewForConfig(config)
	if err != nil {
		common.GVA_LOG.Error("创建Client失败", zap.Any("err", err))
		return nil, errors.New("创建Client失败！")
	}
	return clientSet, nil
}

// GetRestConf 获取k8s RESTConfig
func GetRestConf(k8sConf string) (restConf *rest.Config, err error) {

	if restConf, err = clientcmd.RESTConfigFromKubeConfig([]byte(k8sConf)); err != nil {
		fmt.Println("err: ", err)
		return nil, err
	}
	return restConf, nil
}

// ClusterID 公共方法, 获取指定k8s集群的KubeConfig
func ClusterID(c *gin.Context) (*kubernetes.Clientset, error) {

	clusterId := c.DefaultQuery("clusterId", "1")
	clusterIdUint, err := strconv.ParseUint(clusterId, 10, 32)
	cluster, err := services.GetK8sCluster(uint(clusterIdUint))
	if err != nil {
		common.GVA_LOG.Error("获取集群失败", zap.Any("err", err))
		return nil, err
	}

	client, _ := GetK8sClient(cluster.KubeConfig)

	return client, nil
}
