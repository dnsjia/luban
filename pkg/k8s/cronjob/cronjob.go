package cronjob

import (
	"context"
	"fmt"
	"k8s.io/api/batch/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	client "k8s.io/client-go/kubernetes"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
)

// CronJobList contains a list of CronJobs in the cluster.
type CronJobList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`
	Items    []CronJob    `json:"items"`

	// Basic information about resources status on the list.
	Status k8scommon.ResourceStatus `json:"status"`
}

// CronJob is a presentation layer view of Kubernetes Cron Job resource.
type CronJob struct {
	ObjectMeta   k8s.ObjectMeta `json:"objectMeta"`
	TypeMeta     k8s.TypeMeta   `json:"typeMeta"`
	Schedule     string         `json:"schedule"`
	Suspend      *bool          `json:"suspend"`
	Active       int            `json:"active"`
	LastSchedule *metav1.Time   `json:"lastSchedule"`

	// ContainerImages holds a list of the CronJob images.
	ContainerImages []string `json:"containerImages"`
}

// GetCronJobList returns a list of all CronJobs in the cluster.
func GetCronJobList(client client.Interface, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*CronJobList, error) {
	common.LOG.Info("Getting list of all cron jobs in the cluster")

	channels := &k8scommon.ResourceChannels{
		CronJobList: k8scommon.GetCronJobListChannel(client, nsQuery, 1),
	}

	return GetCronJobListFromChannels(channels, dsQuery)
}

// GetCronJobListFromChannels returns a list of all CronJobs in the cluster reading required resource
// list once from the channels.
func GetCronJobListFromChannels(channels *k8scommon.ResourceChannels, dsQuery *dataselect.DataSelectQuery) (*CronJobList, error) {

	cronJobs := <-channels.CronJobList.List
	err := <-channels.CronJobList.Error
	if err != nil {
		return nil, err
	}

	cronJobList := toCronJobList(cronJobs.Items, dsQuery)
	cronJobList.Status = getStatus(cronJobs)
	return cronJobList, nil
}

func toCronJobList(cronJobs []v1beta1.CronJob, dsQuery *dataselect.DataSelectQuery) *CronJobList {

	list := &CronJobList{
		Items:    make([]CronJob, 0),
		ListMeta: k8s.ListMeta{TotalItems: len(cronJobs)},
	}

	cronJobCells, filteredTotal := dataselect.GenericDataSelectWithFilter(ToCells(cronJobs), dsQuery)
	cronJobs = FromCells(cronJobCells)
	list.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, cronJob := range cronJobs {
		list.Items = append(list.Items, toCronJob(&cronJob))
	}

	return list
}

func toCronJob(cj *v1beta1.CronJob) CronJob {
	return CronJob{
		ObjectMeta:      k8s.NewObjectMeta(cj.ObjectMeta),
		TypeMeta:        k8s.NewTypeMeta(k8s.ResourceKindCronJob),
		Schedule:        cj.Spec.Schedule,
		Suspend:         cj.Spec.Suspend,
		Active:          len(cj.Status.Active),
		LastSchedule:    cj.Status.LastScheduleTime,
		ContainerImages: getContainerImages(cj),
	}
}

func DeleteCronJob(client *client.Clientset, namespace, name string) (err error) {
	// for k8s version < 1.21.0, use batch/v1beta1
	// if you use BatchV1  Will report an error: the server could not find the requested resource
	// BatchV1beta1
	return client.BatchV1beta1().CronJobs(namespace).Delete(context.TODO(), name, metav1.DeleteOptions{})
}

func DeleteCollectionCronJob(client *client.Clientset, jobList []k8s.JobData) (err error) {
	common.LOG.Info("批量删除cronjob开始")
	for _, v := range jobList {
		common.LOG.Info(fmt.Sprintf("delete cronjob：%v, ns: %v", v.Name, v.Namespace))
		err := client.BatchV1beta1().CronJobs(v.Namespace).Delete(
			context.TODO(),
			v.Name,
			metav1.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除cronjob已完成")
	return nil
}
