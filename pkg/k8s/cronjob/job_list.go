package cronjob

import (
	"context"
	"go.uber.org/zap"
	batch "k8s.io/api/batch/v1"
	batch2 "k8s.io/api/batch/v1beta1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/job"
	"strings"
)

type JobList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// Basic information about resources status on the list.
	Status k8scommon.ResourceStatus `json:"status"`

	// Unordered list of Pods.
	Jobs []job.Job `json:"jobs"`
}

func getJobList(client *kubernetes.Clientset, cj *batch2.CronJob, name string) (jo *JobList) {

	jobData, err := client.BatchV1().Jobs(cj.Namespace).List(context.TODO(), metaV1.ListOptions{})
	if err != nil {
		common.LOG.Error("Get a job list exception from the cronjob", zap.Any("err", err))
	}
	jobList := JobList{
		Jobs: make([]job.Job, 0),
	}
	jobList.ListMeta = k8s.ListMeta{TotalItems: len(jobData.Items)}
	for _, j := range jobData.Items {
		if strings.Contains(j.Name, name) {
			jobList.Jobs = append(jobList.Jobs, toJob(&j))
			jobList.ListMeta = k8s.ListMeta{
				TotalItems: len(jobList.Jobs),
			}
		}
	}

	return &jobList
}

func toJob(j *batch.Job) job.Job {
	return job.Job{
		ObjectMeta:          k8s.NewObjectMeta(j.ObjectMeta),
		TypeMeta:            k8s.NewTypeMeta(k8s.ResourceKindJob),
		ContainerImages:     k8scommon.GetContainerImages(&j.Spec.Template.Spec),
		InitContainerImages: k8scommon.GetInitContainerImages(&j.Spec.Template.Spec),
		JobStatus:           job.GetJobStatus(j),
		PodStatus:           job.GetPodStatus(j),
		Parallelism:         j.Spec.Parallelism,
	}
}
