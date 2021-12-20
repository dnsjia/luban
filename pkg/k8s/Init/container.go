/*
Copyright 2021 The DnsJia Authors.
WebSite:  https://github.com/dnsjia/luban
Email:    OpenSource@dnsjia.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package Init

import (
	"errors"
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/services"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"strconv"
)

// GetK8sClient 获取k8s Client
func GetK8sClient(k8sConf string) (*kubernetes.Clientset, error) {

	config, err := clientcmd.RESTConfigFromKubeConfig([]byte(k8sConf))
	// skips the validity check for the server's certificate. This will make your HTTPS connections insecure.
	// config.TLSClientConfig.Insecure = true
	if err != nil {
		common.LOG.Error("KubeConfig内容错误", zap.Any("err", err))
		return nil, errors.New("KubeConfig内容错误")
	}

	clientSet, err := kubernetes.NewForConfig(config)
	if err != nil {
		common.LOG.Error("创建Client失败", zap.Any("err", err))
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
		common.LOG.Error("获取集群失败", zap.Any("err", err))
		return nil, err
	}

	client, _ := GetK8sClient(cluster.KubeConfig)

	return client, nil
}
