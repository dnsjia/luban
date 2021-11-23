package job

import (
	"context"
	batch "k8s.io/api/batch/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/pkg/k8s/common"
)

// JobDetail is a presentation layer view of Kubernetes Job resource.
type JobDetail struct {
	// Extends list item structure.
	Job    `json:",inline"`
	Status []batch.JobCondition `json:"status"`
	// Completions specifies the desired number of successfully finished pods the job should be run with.
	Completions *int32 `json:"completions"`

	PodList *PodList `json:"podList"`
}

// GetJobDetail gets job details.
func GetJobDetail(client *kubernetes.Clientset, namespace, name string) (*JobDetail, error) {
	jobData, err := client.BatchV1().Jobs(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	podInfo, err := getJobPodInfo(client, jobData)
	if err != nil {
		return nil, err
	}

	job := toJobDetail(client, jobData, *podInfo)
	return &job, nil
}

func toJobDetail(client *kubernetes.Clientset, job *batch.Job, podInfo common.PodInfo) JobDetail {

	return JobDetail{
		Job:         toJob(job, &podInfo),
		Status:      job.Status.Conditions,
		Completions: job.Spec.Completions,
		PodList:     getJobToPod(client, job),
	}
}
