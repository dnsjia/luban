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

package cronjob

import (
	"context"
	"encoding/json"
	"fmt"
	batch2 "k8s.io/api/batch/v1beta1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

// CronJobDetail contains Cron Job details.
type CronJobDetail struct {
	// Extends list item structure.
	CronJob `json:",inline"`

	ConcurrencyPolicy string `json:"concurrencyPolicy"`

	StartingDeadLineSeconds *int64 `json:"startingDeadlineSeconds"`

	JobList *JobList `json:"jobList"`
}

// GetCronJobDetail gets Cron Job details.
func GetCronJobDetail(client *kubernetes.Clientset, namespace, name string) (*CronJobDetail, error) {

	rawObject, err := client.BatchV1beta1().CronJobs(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}
	j, _ := json.Marshal(rawObject)
	fmt.Printf("cronJob: %s\n", j)
	cj := toCronJobDetail(rawObject, client, name)
	return &cj, nil
}

func toCronJobDetail(cj *batch2.CronJob, client *kubernetes.Clientset, name string) CronJobDetail {

	return CronJobDetail{
		CronJob:                 toCronJob(cj),
		ConcurrencyPolicy:       string(cj.Spec.ConcurrencyPolicy),
		StartingDeadLineSeconds: cj.Spec.StartingDeadlineSeconds,
		JobList:                 getJobList(client, cj, name),
	}
}
