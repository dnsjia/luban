package job

import (
	batch "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	"pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
)

// The code below allows to perform complex data section on []batch.Job

type JobCell batch.Job

func (self JobCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
	switch name {
	case dataselect.NameProperty:
		return dataselect.StdComparableString(self.ObjectMeta.Name)
	case dataselect.CreationTimestampProperty:
		return dataselect.StdComparableTime(self.ObjectMeta.CreationTimestamp.Time)
	case dataselect.NamespaceProperty:
		return dataselect.StdComparableString(self.ObjectMeta.Namespace)
	default:
		// if name is not supported then just return a constant dummy value, sort will have no effect.
		return nil
	}
}

func ToCells(std []batch.Job) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = JobCell(std[i])
	}
	return cells
}

func FromCells(cells []dataselect.DataCell) []batch.Job {
	std := make([]batch.Job, len(cells))
	for i := range std {
		std[i] = batch.Job(cells[i].(JobCell))
	}
	return std
}

func getStatus(list *batch.JobList, pods []v1.Pod) common.ResourceStatus {
	info := common.ResourceStatus{}
	if list == nil {
		return info
	}

	for _, job := range list.Items {
		matchingPods := common.FilterPodsForJob(job, pods)
		podInfo := common.GetPodInfo(job.Status.Active, job.Spec.Completions, matchingPods)
		jobStatus := GetJobStatus(&job)

		if jobStatus.Status == JobStatusFailed {
			info.Failed++
		} else if jobStatus.Status == JobStatusComplete {
			info.Succeeded++
		} else if podInfo.Running > 0 {
			info.Running++
		} else {
			info.Pending++
		}
	}

	return info
}
