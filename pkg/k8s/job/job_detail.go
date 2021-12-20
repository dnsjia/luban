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

package job

import (
	"context"
	"github.com/dnsjia/luban/pkg/k8s/common"
	batch "k8s.io/api/batch/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
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
