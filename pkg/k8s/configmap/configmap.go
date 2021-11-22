package configmap

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
)

// ConfigMapList contains a list of Config Maps in the cluster.
type ConfigMapList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// Unordered list of Config Maps
	Items []ConfigMap `json:"items"`
}

// ConfigMap API resource provides mechanisms to inject containers with configuration data while keeping
// containers agnostic of Kubernetes
type ConfigMap struct {
	ObjectMeta k8s.ObjectMeta `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta   `json:"typeMeta"`
}

// GetConfigMapList returns a list of all ConfigMaps in the cluster.
func GetConfigMapList(client kubernetes.Interface, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*ConfigMapList, error) {
	common.LOG.Info(fmt.Sprintf("Getting list config maps in the namespace %s", nsQuery.ToRequestParam()))
	channels := &k8scommon.ResourceChannels{
		ConfigMapList: k8scommon.GetConfigMapListChannel(client, nsQuery, 1),
	}

	return GetConfigMapListFromChannels(channels, dsQuery)
}

// GetConfigMapListFromChannels returns a list of all Config Maps in the cluster reading required resource list once from the channels.
func GetConfigMapListFromChannels(channels *k8scommon.ResourceChannels, dsQuery *dataselect.DataSelectQuery) (*ConfigMapList, error) {
	configMaps := <-channels.ConfigMapList.List
	err := <-channels.ConfigMapList.Error
	if err != nil {
		return nil, err
	}

	result := toConfigMapList(configMaps.Items, dsQuery)

	return result, nil
}

func toConfigMap(meta metaV1.ObjectMeta) ConfigMap {
	return ConfigMap{
		ObjectMeta: k8s.NewObjectMeta(meta),
		TypeMeta:   k8s.NewTypeMeta(k8s.ResourceKindConfigMap),
	}
}

func toConfigMapList(configMaps []v1.ConfigMap, dsQuery *dataselect.DataSelectQuery) *ConfigMapList {
	result := &ConfigMapList{
		Items:    make([]ConfigMap, 0),
		ListMeta: k8s.ListMeta{TotalItems: len(configMaps)},
	}

	configMapCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(configMaps), dsQuery)
	configMaps = fromCells(configMapCells)
	result.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, item := range configMaps {
		result.Items = append(result.Items, toConfigMap(item.ObjectMeta))
	}

	return result
}

func DeleteConfigMap(client *kubernetes.Clientset, namespace string, name string) error {
	common.LOG.Info(fmt.Sprintf("请求删除ConfigMap: %v, namespace: %v", name, namespace))
	return client.CoreV1().ConfigMaps(namespace).Delete(
		context.TODO(),
		name,
		metaV1.DeleteOptions{},
	)
}

func DeleteCollectionConfigMap(client *kubernetes.Clientset, configMapList []k8s.ConfigMapData) (err error) {
	common.LOG.Info("批量删除ConfigMap开始")
	for _, v := range configMapList {
		common.LOG.Info(fmt.Sprintf("delete configMap：%v, ns: %v", v.Name, v.Namespace))
		err := client.CoreV1().ConfigMaps(v.Namespace).Delete(
			context.TODO(),
			v.Name,
			metaV1.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除ConfigMap已完成")
	return nil
}
