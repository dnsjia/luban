package job

import (
	batch "k8s.io/api/batch/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/fields"
	"k8s.io/apimachinery/pkg/labels"
	"k8s.io/client-go/kubernetes"
	"pigs/pkg/k8s/common"
)

// Returns simple info about pods(running, desired, failing, etc.) related to given job.
func getJobPodInfo(client *kubernetes.Clientset, job *batch.Job) (*common.PodInfo, error) {
	labelSelector := labels.SelectorFromSet(job.Spec.Selector.MatchLabels)
	channels := &common.ResourceChannels{
		PodList: common.GetPodListChannelWithOptions(client, common.NewSameNamespaceQuery(
			job.Namespace),
			metaV1.ListOptions{
				LabelSelector: labelSelector.String(),
				FieldSelector: fields.Everything().String(),
			}, 1),
	}

	pods := <-channels.PodList.List
	if err := <-channels.PodList.Error; err != nil {
		return nil, err
	}

	podInfo := common.GetPodInfo(job.Status.Active, job.Spec.Completions, pods.Items)

	// This pod info for jobs should be get from job status, similar to kubectl describe logic.
	podInfo.Running = job.Status.Active
	podInfo.Succeeded = job.Status.Succeeded
	podInfo.Failed = job.Status.Failed
	return &podInfo, nil
}
