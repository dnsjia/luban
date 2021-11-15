package common

import (
	"context"
	batch "k8s.io/api/batch/v1"
	"pigs/models/k8s"

	apps "k8s.io/api/apps/v1"

	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	client "k8s.io/client-go/kubernetes"
)

// ResourceChannels struct holds channels to resource lists. Each list channel is paired with
// an error channel which *must* be read sequentially: first read the list channel and then
// the error channel.
//
// This struct can be used when there are multiple clients that want to process, e.g., a
// list of pods. With this helper, the list can be read only once from the backend and
// distributed asynchronously to clients that need it.
//
// When a channel is nil, it means that no resource list is available for getting.
//
// Each channel pair can be read up to N times. N is specified upon creation of the channels.
type ResourceChannels struct {

	// List and error channels to Replica Sets.
	ReplicaSetList ReplicaSetListChannel

	// List and error channels to Deployments.
	DeploymentList DeploymentListChannel

	// List and error channels to Pods.
	PodList PodListChannel

	// List and error channels to Events.
	EventList EventListChannel

	// List and error channels to ConfigMaps.
	ConfigMapList ConfigMapListChannel

	// List and error channels to Secrets.
	SecretList SecretListChannel

	// List and error channels to PersistentVolumes
	PersistentVolumeList PersistentVolumeListChannel

	// List and error channels to PersistentVolumeClaims
	PersistentVolumeClaimList PersistentVolumeClaimListChannel

	// List and error channels to StatefulSets.
	StatefulSetList StatefulSetListChannel

	// List and error channels to Daemon Sets.
	DaemonSetList DaemonSetListChannel

	// List and error channels to Services.
	ServiceList ServiceListChannel

	// List and error channels to Jobs.
	JobList JobListChannel
}

// EventListChannel is a list and error channels to Events.
type EventListChannel struct {
	List  chan *v1.EventList
	Error chan error
}

// GetEventListChannel returns a pair of channels to an Event list and errors that both must be read
// numReads times.
func GetEventListChannel(client *client.Clientset, nsQuery *NamespaceQuery, numReads int) EventListChannel {
	return GetEventListChannelWithOptions(client, nsQuery, k8s.ListEverything, numReads)
}

// GetEventListChannelWithOptions is GetEventListChannel plus list options.
func GetEventListChannelWithOptions(client *client.Clientset, nsQuery *NamespaceQuery, options metaV1.ListOptions, numReads int) EventListChannel {
	channel := EventListChannel{
		List:  make(chan *v1.EventList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		// 原options是根据label过滤来过滤Event事件信息, 代码deployment_detail + L78
		// TODO 改成field过滤
		//options.FieldSelector = fmt.Sprintf("involvedObject.name=%v", deploymentName)
		list, err := client.CoreV1().Events(nsQuery.ToRequestParam()).List(context.TODO(), options)
		var filteredItems []v1.Event
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// PodListChannel is a list and error channels to Pods.
type PodListChannel struct {
	List  chan *v1.PodList
	Error chan error
}

// GetPodListChannel returns a pair of channels to a Pod list and errors that both must be read
// numReads times.
func GetPodListChannel(client client.Interface, nsQuery *NamespaceQuery, numReads int) PodListChannel {
	return GetPodListChannelWithOptions(client, nsQuery, k8s.ListEverything, numReads)
}

// GetPodListChannelWithOptions is GetPodListChannel plus listing options.
func GetPodListChannelWithOptions(client client.Interface, nsQuery *NamespaceQuery, options metaV1.ListOptions, numReads int) PodListChannel {

	channel := PodListChannel{
		List:  make(chan *v1.PodList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.CoreV1().Pods(nsQuery.ToRequestParam()).List(context.TODO(), options)
		var filteredItems []v1.Pod
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// DeploymentListChannel is a list and error channels to Deployments.
type DeploymentListChannel struct {
	List  chan *apps.DeploymentList
	Error chan error
}

// GetDeploymentListChannel returns a pair of channels to a Deployment list and errors
// that both must be read numReads times.
func GetDeploymentListChannel(client client.Interface, nsQuery *NamespaceQuery, numReads int) DeploymentListChannel {

	channel := DeploymentListChannel{
		List:  make(chan *apps.DeploymentList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.AppsV1().Deployments(nsQuery.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
		var filteredItems []apps.Deployment
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// ReplicaSetListChannel is a list and error channels to Replica Sets.
type ReplicaSetListChannel struct {
	List  chan *apps.ReplicaSetList
	Error chan error
}

// GetReplicaSetListChannel returns a pair of channels to a ReplicaSet list and
// errors that both must be read numReads times.
func GetReplicaSetListChannel(client client.Interface, nsQuery *NamespaceQuery, numReads int) ReplicaSetListChannel {
	return GetReplicaSetListChannelWithOptions(client, nsQuery, k8s.ListEverything, numReads)
}

// GetReplicaSetListChannelWithOptions returns a pair of channels to a ReplicaSet list filtered
// by provided options and errors that both must be read numReads times.
func GetReplicaSetListChannelWithOptions(client client.Interface, nsQuery *NamespaceQuery, options metaV1.ListOptions, numReads int) ReplicaSetListChannel {
	channel := ReplicaSetListChannel{
		List:  make(chan *apps.ReplicaSetList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.AppsV1().ReplicaSets(nsQuery.ToRequestParam()).
			List(context.TODO(), options)
		var filteredItems []apps.ReplicaSet
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// ConfigMapListChannel is a list and error channels to ConfigMaps.
type ConfigMapListChannel struct {
	List  chan *v1.ConfigMapList
	Error chan error
}

// GetConfigMapListChannel returns a pair of channels to a ConfigMap list and errors that both must be read
// numReads times.
func GetConfigMapListChannel(client client.Interface, nsQuery *NamespaceQuery, numReads int) ConfigMapListChannel {

	channel := ConfigMapListChannel{
		List:  make(chan *v1.ConfigMapList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.CoreV1().ConfigMaps(nsQuery.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
		var filteredItems []v1.ConfigMap
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// SecretListChannel is a list and error channels to Secrets.
type SecretListChannel struct {
	List  chan *v1.SecretList
	Error chan error
}

// GetSecretListChannel returns a pair of channels to a Secret list and errors that
// both must be read numReads times.
func GetSecretListChannel(client client.Interface, nsQuery *NamespaceQuery, numReads int) SecretListChannel {

	channel := SecretListChannel{
		List:  make(chan *v1.SecretList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.CoreV1().Secrets(nsQuery.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
		var filteredItems []v1.Secret
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// PersistentVolumeListChannel is a list and error channels to PersistentVolumes.
type PersistentVolumeListChannel struct {
	List  chan *v1.PersistentVolumeList
	Error chan error
}

// GetPersistentVolumeListChannel returns a pair of channels to a PersistentVolume list and errors
// that both must be read numReads times.
func GetPersistentVolumeListChannel(client client.Interface,
	numReads int) PersistentVolumeListChannel {
	channel := PersistentVolumeListChannel{
		List:  make(chan *v1.PersistentVolumeList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.CoreV1().PersistentVolumes().List(context.TODO(), k8s.ListEverything)
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// PersistentVolumeClaimListChannel is a list and error channels to PersistentVolumeClaims.
type PersistentVolumeClaimListChannel struct {
	List  chan *v1.PersistentVolumeClaimList
	Error chan error
}

// GetPersistentVolumeClaimListChannel returns a pair of channels to a PersistentVolumeClaim list
// and errors that both must be read numReads times.
func GetPersistentVolumeClaimListChannel(client client.Interface, nsQuery *NamespaceQuery,
	numReads int) PersistentVolumeClaimListChannel {

	channel := PersistentVolumeClaimListChannel{
		List:  make(chan *v1.PersistentVolumeClaimList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.CoreV1().PersistentVolumeClaims(nsQuery.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// StatefulSetListChannel is a list and error channels to StatefulSets.
type StatefulSetListChannel struct {
	List  chan *apps.StatefulSetList
	Error chan error
}

// GetStatefulSetListChannel returns a pair of channels to a StatefulSet list and errors that both must be read
// numReads times.
func GetStatefulSetListChannel(client client.Interface, nsQuery *NamespaceQuery, numReads int) StatefulSetListChannel {
	channel := StatefulSetListChannel{
		List:  make(chan *apps.StatefulSetList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		statefulSets, err := client.AppsV1().StatefulSets(nsQuery.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
		var filteredItems []apps.StatefulSet
		for _, item := range statefulSets.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		statefulSets.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- statefulSets
			channel.Error <- err
		}
	}()

	return channel
}

// DaemonSetListChannel is a list and error channels to Daemon Sets.
type DaemonSetListChannel struct {
	List  chan *apps.DaemonSetList
	Error chan error
}

// GetDaemonSetListChannel returns a pair of channels to a DaemonSet list and errors that both must be read
// numReads times.
func GetDaemonSetListChannel(client client.Interface, nsQuery *NamespaceQuery, numReads int) DaemonSetListChannel {
	channel := DaemonSetListChannel{
		List:  make(chan *apps.DaemonSetList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.AppsV1().DaemonSets(nsQuery.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
		var filteredItems []apps.DaemonSet
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// ServiceListChannel is a list and error channels to Services.
type ServiceListChannel struct {
	List  chan *v1.ServiceList
	Error chan error
}

// GetServiceListChannel returns a pair of channels to a Service list and errors that both
// must be read numReads times.
func GetServiceListChannel(client client.Interface, nsQuery *NamespaceQuery, numReads int) ServiceListChannel {

	channel := ServiceListChannel{
		List:  make(chan *v1.ServiceList, numReads),
		Error: make(chan error, numReads),
	}
	go func() {
		list, err := client.CoreV1().Services(nsQuery.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
		var filteredItems []v1.Service
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}

// JobListChannel is a list and error channels to Jobs.
type JobListChannel struct {
	List  chan *batch.JobList
	Error chan error
}

// GetJobListChannel returns a pair of channels to a Job list and errors that both must be read numReads times.
func GetJobListChannel(client client.Interface,
	nsQuery *NamespaceQuery, numReads int) JobListChannel {
	channel := JobListChannel{
		List:  make(chan *batch.JobList, numReads),
		Error: make(chan error, numReads),
	}

	go func() {
		list, err := client.BatchV1().Jobs(nsQuery.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
		var filteredItems []batch.Job
		for _, item := range list.Items {
			if nsQuery.Matches(item.ObjectMeta.Namespace) {
				filteredItems = append(filteredItems, item)
			}
		}
		list.Items = filteredItems
		for i := 0; i < numReads; i++ {
			channel.List <- list
			channel.Error <- err
		}
	}()

	return channel
}
