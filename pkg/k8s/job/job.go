package job

import (
	"context"
	"fmt"
	batch "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	meta "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
)

// JobList contains a list of Jobs in the cluster.
type JobList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// Basic information about resources status on the list.
	Status k8scommon.ResourceStatus `json:"status"`

	// Unordered list of Jobs.
	Jobs []Job `json:"jobs"`

	// List of non-critical errors, that occurred during resource retrieval.
	Errors []error `json:"errors"`
}

type JobStatusType string

const (
	// JobStatusRunning means the job is still running.
	JobStatusRunning JobStatusType = "Running"
	// JobStatusComplete means the job has completed its execution.
	JobStatusComplete JobStatusType = "Complete"
	// JobStatusFailed means the job has failed its execution.
	JobStatusFailed JobStatusType = "Failed"
)

type JobStatus struct {
	// Short, machine understandable job status code.
	Status JobStatusType `json:"status"`
	// A human-readable description of the status of related job.
	Message string `json:"message"`
	// Conditions describe the state of a job after it finishes.
	Conditions []k8scommon.Condition `json:"conditions"`
}

// Job is a presentation layer view of Kubernetes Job resource. This means it is Job plus additional
// augmented data we can get from other sources
type Job struct {
	ObjectMeta k8s.ObjectMeta `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta   `json:"typeMeta"`

	// Aggregate information about pods belonging to this Job.
	Pods k8scommon.PodInfo `json:"podInfo"`

	// Container images of the Job.
	ContainerImages []string `json:"containerImages"`

	// Init Container images of the Job.
	InitContainerImages []string `json:"initContainerImages"`

	// number of parallel jobs defined.
	Parallelism *int32 `json:"parallelism"`

	// JobStatus contains inferred job status based on job conditions
	JobStatus JobStatus `json:"jobStatus"`

	PodStatus PodStatus `json:"podStatus"`
}

type PodStatus struct {
	// Represents time when the job controller started processing a job. When a
	// Job is created in the suspended state, this field is not set until the
	// first time it is resumed. This field is reset every time a Job is resumed
	// from suspension. It is represented in RFC3339 form and is in UTC.
	// +optional
	StartTime *meta.Time `json:"startTime"`

	// Represents time when the job was completed. It is not guaranteed to
	// be set in happens-before order across separate operations.
	// It is represented in RFC3339 form and is in UTC.
	// The completion time is only set when the job finishes successfully.
	// +optional
	CompletionTime *meta.Time `json:"completionTime"`

	// The number of actively running pods.
	// +optional
	Active int32 `json:"active"`

	// The number of pods which reached phase Succeeded.
	// +optional
	Succeeded int32 `json:"succeeded"`

	// The number of pods which reached phase Failed.
	// +optional
	Failed int32 `json:"failed"`
}

// GetJobList returns a list of all Jobs in the cluster.
func GetJobList(client *kubernetes.Clientset, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*JobList, error) {
	common.LOG.Info("Getting list of all jobs in the cluster")

	channels := &k8scommon.ResourceChannels{
		JobList:   k8scommon.GetJobListChannel(client, nsQuery, 1),
		PodList:   k8scommon.GetPodListChannel(client, nsQuery, 1),
		EventList: k8scommon.GetEventListChannel(client, nsQuery, 1),
	}

	return GetJobListFromChannels(channels, dsQuery)
}

// GetJobListFromChannels returns a list of all Jobs in the cluster reading required resource list once from the channels.
func GetJobListFromChannels(channels *k8scommon.ResourceChannels, dsQuery *dataselect.DataSelectQuery) (*JobList, error) {

	jobs := <-channels.JobList.List
	err := <-channels.JobList.Error
	if err != nil {
		return nil, err
	}

	pods := <-channels.PodList.List
	err = <-channels.PodList.Error
	if err != nil {
		return nil, err
	}

	events := <-channels.EventList.List
	err = <-channels.EventList.Error
	if err != nil {
		return nil, err
	}

	jobList := ToJobList(jobs.Items, pods.Items, events.Items, dsQuery)
	jobList.Status = getStatus(jobs, pods.Items)
	return jobList, nil
}

func ToJobList(jobs []batch.Job, pods []v1.Pod, events []v1.Event, dsQuery *dataselect.DataSelectQuery) *JobList {

	jobList := &JobList{
		Jobs:     make([]Job, 0),
		ListMeta: k8s.ListMeta{TotalItems: len(jobs)},
	}

	jobCells, filteredTotal := dataselect.GenericDataSelectWithFilter(ToCells(jobs), dsQuery)
	jobs = FromCells(jobCells)
	jobList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, job := range jobs {
		matchingPods := k8scommon.FilterPodsForJob(job, pods)
		podInfo := k8scommon.GetPodInfo(job.Status.Active, job.Spec.Completions, matchingPods)
		podInfo.Warnings = event.GetPodsEventWarnings(events, matchingPods)
		jobList.Jobs = append(jobList.Jobs, toJob(&job, &podInfo))
	}

	return jobList
}

func toJob(job *batch.Job, podInfo *k8scommon.PodInfo) Job {

	return Job{
		ObjectMeta:          k8s.NewObjectMeta(job.ObjectMeta),
		TypeMeta:            k8s.NewTypeMeta(k8s.ResourceKindJob),
		ContainerImages:     k8scommon.GetContainerImages(&job.Spec.Template.Spec),
		InitContainerImages: k8scommon.GetInitContainerImages(&job.Spec.Template.Spec),
		Pods:                *podInfo,
		JobStatus:           getJobStatus(job),
		PodStatus:           getPodStatus(job),
		Parallelism:         job.Spec.Parallelism,
	}
}

func getJobStatus(job *batch.Job) JobStatus {
	jobStatus := JobStatus{Status: JobStatusRunning, Conditions: getJobConditions(job)}
	for _, condition := range job.Status.Conditions {
		if condition.Type == batch.JobComplete && condition.Status == v1.ConditionTrue {
			jobStatus.Status = JobStatusComplete
			break
		} else if condition.Type == batch.JobFailed && condition.Status == v1.ConditionTrue {
			jobStatus.Status = JobStatusFailed
			jobStatus.Message = condition.Message
			break
		}
	}
	return jobStatus
}

func getJobConditions(job *batch.Job) []k8scommon.Condition {
	var conditions []k8scommon.Condition
	for _, condition := range job.Status.Conditions {
		conditions = append(conditions, k8scommon.Condition{
			Type:               string(condition.Type),
			Status:             meta.ConditionStatus(condition.Status),
			LastProbeTime:      condition.LastProbeTime,
			LastTransitionTime: condition.LastTransitionTime,
			Reason:             condition.Reason,
			Message:            condition.Message,
		})
	}
	return conditions
}

func getPodStatus(job *batch.Job) PodStatus {

	return PodStatus{
		Active:         job.Status.Active,
		Succeeded:      job.Status.Succeeded,
		Failed:         job.Status.Failed,
		StartTime:      job.Status.StartTime,
		CompletionTime: job.Status.CompletionTime,
	}

}

func DeleteJob(client *kubernetes.Clientset, namespace, name string) (err error) {
	return client.BatchV1().Jobs(namespace).Delete(context.TODO(), name, meta.DeleteOptions{})
}

func DeleteCollectionJob(client *kubernetes.Clientset, jobList []k8s.JobData) (err error) {
	common.LOG.Info("批量删除job开始")
	for _, v := range jobList {
		common.LOG.Info(fmt.Sprintf("delete job：%v, ns: %v", v.Name, v.Namespace))
		err := client.BatchV1().Jobs(v.Namespace).Delete(
			context.TODO(),
			v.Name,
			meta.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除job已完成")
	return nil
}

func ScaleJob(client *kubernetes.Clientset, namespace, name string, scaleNumber *int32) (err error) {
	job, err := client.BatchV1().Jobs(namespace).Get(context.TODO(), name, meta.GetOptions{})
	if err != nil {
		return err
	}
	job.Spec.Parallelism = scaleNumber
	_, err = client.BatchV1().Jobs(namespace).Update(context.TODO(), job, meta.UpdateOptions{})
	if err != nil {
		return err
	}
	return nil
}
