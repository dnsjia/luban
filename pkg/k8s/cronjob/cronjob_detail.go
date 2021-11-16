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

	ConcurrencyPolicy       string `json:"concurrencyPolicy"`
	StartingDeadLineSeconds *int64 `json:"startingDeadlineSeconds"`
}

// GetCronJobDetail gets Cron Job details.
func GetCronJobDetail(client *kubernetes.Clientset, namespace, name string) (*CronJobDetail, error) {

	rawObject, err := client.BatchV1beta1().CronJobs(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}
	j, _ := json.Marshal(rawObject)
	fmt.Printf("cronJob: %s\n", j)
	cj := toCronJobDetail(rawObject)
	return &cj, nil
}

func toCronJobDetail(cj *batch2.CronJob) CronJobDetail {
	return CronJobDetail{
		CronJob:                 toCronJob(cj),
		ConcurrencyPolicy:       string(cj.Spec.ConcurrencyPolicy),
		StartingDeadLineSeconds: cj.Spec.StartingDeadlineSeconds,
	}
}
