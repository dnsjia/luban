package deployment

import (
	"context"
	"encoding/json"
	"fmt"
	"go.uber.org/zap"
	apps "k8s.io/api/apps/v1"
	autoscalingv1 "k8s.io/api/autoscaling/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/kubernetes"
	deploymentutil "k8s.io/kubectl/pkg/util/deployment"
	"pigs/common"
	"pigs/models/k8s"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"pigs/pkg/k8s/event"
	"pigs/tools"
	"time"
)

// DeploymentList contains a list of Deployments in the cluster.
type DeploymentList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`
	// Basic information about resources status on the list.
	Status k8scommon.ResourceStatus `json:"status"`
	// Unordered list of Deployments.
	Deployments []Deployment `json:"deployments"`
}

// Deployment is a presentation layer view of Kubernetes Deployment resource. This means
// it is Deployment plus additional augmented data we can get from other sources
// (like services that target the same pods).
type Deployment struct {
	ObjectMeta k8s.ObjectMeta `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta   `json:"typeMeta"`

	// Aggregate information about pods belonging to this Deployment.
	Pods k8scommon.PodInfo `json:"pods"`

	// Container images of the Deployment.
	ContainerImages []string `json:"containerImages"`

	// Init Container images of the Deployment.
	InitContainerImages []string `json:"initContainerImages"`

	// Deployment replicas ready
	DeploymentStatus DeploymentStatus `json:"deploymentStatus"`
}

type DeploymentStatus struct {
	// Total number of non-terminated pods targeted by this deployment (their labels match the selector).
	// +optional
	Replicas int32 `json:"replicas"`

	// Total number of non-terminated pods targeted by this deployment that have the desired template spec.
	// +optional
	UpdatedReplicas int32 `json:"updatedReplicas"`

	// Total number of ready pods targeted by this deployment.
	// +optional
	ReadyReplicas int32 `json:"readyReplicas"`

	// Total number of available pods (ready for at least minReadySeconds) targeted by this deployment.
	// +optional
	AvailableReplicas int32 `json:"availableReplicas"`

	// Total number of unavailable pods targeted by this deployment. This is the total number of
	// pods that are still required for the deployment to have 100% available capacity. They may
	// either be pods that are running but not yet available or pods that still have not been created.
	// +optional
	UnavailableReplicas int32 `json:"unavailableReplicas"`
}

// GetDeploymentList 返回集群中所有deployment的列表
func GetDeploymentList(client *kubernetes.Clientset, nsQuery *k8scommon.NamespaceQuery, dsQuery *dataselect.DataSelectQuery) (*DeploymentList, error) {
	common.LOG.Info("Getting list of all deployments in the cluster")

	channels := &k8scommon.ResourceChannels{
		DeploymentList: k8scommon.GetDeploymentListChannel(client, nsQuery, 1),
		PodList:        k8scommon.GetPodListChannel(client, nsQuery, 1),
		EventList:      k8scommon.GetEventListChannel(client, nsQuery, 1),
		ReplicaSetList: k8scommon.GetReplicaSetListChannel(client, nsQuery, 1),
	}

	return GetDeploymentListFromChannels(channels, dsQuery)
}

// GetDeploymentListFromChannels returns a list of all Deployments in the cluster
// reading required resource list once from the channels.
func GetDeploymentListFromChannels(channels *k8scommon.ResourceChannels, dsQuery *dataselect.DataSelectQuery) (*DeploymentList, error) {

	deployments := <-channels.DeploymentList.List
	err := <-channels.DeploymentList.Error
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

	rs := <-channels.ReplicaSetList.List
	err = <-channels.ReplicaSetList.Error
	if err != nil {
		return nil, err
	}

	deploymentList := toDeploymentList(deployments.Items, pods.Items, events.Items, rs.Items, dsQuery)
	deploymentList.Status = getStatus(deployments, rs.Items, pods.Items, events.Items)
	return deploymentList, nil
}

func toDeploymentList(deployments []apps.Deployment, pods []v1.Pod, events []v1.Event, rs []apps.ReplicaSet, dsQuery *dataselect.DataSelectQuery) *DeploymentList {

	deploymentList := &DeploymentList{
		Deployments: make([]Deployment, 0),
		ListMeta:    k8s.ListMeta{TotalItems: len(deployments)},
	}

	deploymentCells, filteredTotal := dataselect.GenericDataSelectWithFilter(toCells(deployments), dsQuery)
	deployments = fromCells(deploymentCells)
	deploymentList.ListMeta = k8s.ListMeta{TotalItems: filteredTotal}

	for _, deployment := range deployments {
		deploymentList.Deployments = append(deploymentList.Deployments, toDeployment(&deployment, rs, pods, events))
	}

	return deploymentList
}

func toDeployment(deployment *apps.Deployment, rs []apps.ReplicaSet, pods []v1.Pod, events []v1.Event) Deployment {
	matchingPods := k8scommon.FilterDeploymentPodsByOwnerReference(*deployment, rs, pods)
	podInfo := k8scommon.GetPodInfo(deployment.Status.Replicas, deployment.Spec.Replicas, matchingPods)
	podInfo.Warnings = event.GetPodsEventWarnings(events, matchingPods)

	return Deployment{
		ObjectMeta:          k8s.NewObjectMeta(deployment.ObjectMeta),
		TypeMeta:            k8s.NewTypeMeta(k8s.ResourceKindDeployment),
		Pods:                podInfo,
		ContainerImages:     k8scommon.GetContainerImages(&deployment.Spec.Template.Spec),
		InitContainerImages: k8scommon.GetInitContainerImages(&deployment.Spec.Template.Spec),
		DeploymentStatus:    getDeploymentStatus(deployment),
	}
}

func getDeploymentStatus(deployment *apps.Deployment) DeploymentStatus {

	return DeploymentStatus{
		Replicas:            deployment.Status.Replicas,
		UpdatedReplicas:     deployment.Status.UpdatedReplicas,
		ReadyReplicas:       deployment.Status.ReadyReplicas,
		AvailableReplicas:   deployment.Status.AvailableReplicas,
		UnavailableReplicas: deployment.Status.UnavailableReplicas,
	}
}

func DeleteCollectionDeployment(client *kubernetes.Clientset, deploymentData []k8s.RemoveDeploymentData) (err error) {
	common.LOG.Info("批量删除deployment开始")
	for _, v := range deploymentData {
		common.LOG.Info(fmt.Sprintf("delete deployment：%v, ns: %v", v.DeploymentName, v.Namespace))
		err := client.AppsV1().Deployments(v.Namespace).Delete(
			context.TODO(),
			v.DeploymentName,
			metav1.DeleteOptions{},
		)
		if err != nil {
			common.LOG.Error(err.Error())
			return err
		}
	}
	common.LOG.Info("删除deployment已完成")
	return nil
}

func DeleteDeployment(client *kubernetes.Clientset, ns string, deploymentName string) (err error) {
	common.LOG.Info(fmt.Sprintf("请求删除单个deployment：%v, namespace: %v", deploymentName, ns))
	return client.AppsV1().Deployments(ns).Delete(
		context.TODO(),
		deploymentName,
		metav1.DeleteOptions{},
	)
}

func ScaleDeployment(client *kubernetes.Clientset, ns string, deploymentName string, scaleNumber int32) (err error) {

	common.LOG.Info(fmt.Sprintf("start scale of %v deployment in %v namespace", deploymentName, ns))

	scaleData, err := client.AppsV1().Deployments(ns).GetScale(
		context.TODO(),
		deploymentName,
		metav1.GetOptions{},
	)

	common.LOG.Info(fmt.Sprintf("The deployment has changed from %v to %v", scaleData.Spec.Replicas, scaleNumber))

	scale := autoscalingv1.Scale{
		TypeMeta:   scaleData.TypeMeta,
		ObjectMeta: scaleData.ObjectMeta,
		Spec:       autoscalingv1.ScaleSpec{Replicas: scaleNumber},
		Status:     scaleData.Status,
	}
	_, err = client.AppsV1().Deployments(ns).UpdateScale(
		context.TODO(),
		deploymentName,
		&scale,
		metav1.UpdateOptions{},
	)

	if err != nil {
		common.LOG.Error("扩缩容出现异常", zap.Any("err: ", err))
		return err
	}
	return nil
}

func RestartDeployment(client *kubernetes.Clientset, deploymentName string, namespace string) (err error) {
	common.LOG.Info(fmt.Sprintf("下发应用重启指令, 名称空间：%v, 无状态应用：%v", namespace, deploymentName))
	data := fmt.Sprintf(`{"spec":{"template":{"metadata":{"annotations":{"kubectl.kubernetes.io/restartedAt":"%s"}}}}}`, time.Now().String())
	_, err = client.AppsV1().Deployments(namespace).Patch(
		context.Background(),
		deploymentName,
		types.StrategicMergePatchType,
		[]byte(data),
		metav1.PatchOptions{
			FieldManager: "kubectl-rollout",
		})

	if err != nil {
		common.LOG.Error("应用重启失败", zap.Any("err: ", err))
		return err
	}
	return nil
}

func RollbackDeployment(client *kubernetes.Clientset, deploymentName string, namespace string, reVersion int64) (err error) {
	/*
		该Api方法已移除, 不推荐使用 client.ExtensionsV1beta1().Deployments(namespace).Rollback(v1beta1.DeploymentRollback{})
		https://github.com/kubernetes/kubernetes/pull/59970


		Because of the removal of /rollback endpoint in apps/v1.Deployments, the example and kubectl, if switched to apps/v1.Deployments, need to do the rollback logic themselves. That includes:

		1.List all ReplicaSets the Deployment owns
		2.Find the ReplicaSet of a specific revision
		3.Copy that ReplicaSet's template back to the Deployment's template

		The rollback logic currently lives in Deployment controller code, which still uses extensions/v1beta1 Deployment client:
		https://github.com/kubernetes/kubernetes/blob/ecc5eb67d965295db95ba2df5f3d3ff43a258a05/pkg/controller/deployment/rollback.go#L30-L69
	*/
	common.LOG.Info(fmt.Sprintf("应用：%v, 所属空间：%v, 版本回滚到%v", deploymentName, namespace, reVersion))
	if reVersion < 0 {
		return revisionNotFoundErr(reVersion)
	}

	deployment, err := client.AppsV1().Deployments(namespace).Get(context.TODO(), deploymentName, metav1.GetOptions{})
	if err != nil {
		return fmt.Errorf("failed to retrieve Deployment %s: %v", deploymentName, err)
	}
	if deployment.Spec.Paused {
		return fmt.Errorf("skipped rollback (deployment \"%s\" is paused)", deployment.Name)
	}
	// If rollback revision is 0, rollback to the last revision
	if reVersion == 0 {
		common.LOG.Warn("传递回滚版本号是：0, 默认回退上一次版本！")
		rsForRevision, err := deploymentRevision(deployment, client, reVersion)
		if err != nil {
			return err
		}
		rsJson, _ := json.Marshal(rsForRevision)
		fmt.Printf("rsJson:%s\n", rsJson)
		for k, _ := range rsForRevision.Annotations {
			if k == "deployment.kubernetes.io/revision" {
				deployment.Spec.Template = rsForRevision.Spec.Template
				if _, rollbackErr := client.AppsV1().Deployments(namespace).Update(context.TODO(), deployment, metav1.UpdateOptions{}); rollbackErr != nil {
					common.LOG.Error("版本回退失败", zap.Any("err: ", err))
					return rollbackErr
				}
				common.LOG.Info("The rollback task was executed successfully")
				return nil
			}
		}
	}

	selector, err := metav1.LabelSelectorAsSelector(deployment.Spec.Selector)
	if err != nil {
		return err
	}
	options := metav1.ListOptions{LabelSelector: selector.String()}

	replicaSetList, err := client.AppsV1().ReplicaSets(namespace).List(context.TODO(), options)
	if err != nil {
		return err
	}
	if len(replicaSetList.Items) <= 1 {
		return revisionNotFoundErr(reVersion)
	}

	for _, v := range replicaSetList.Items {
		// reVersion = nginx-56656dc477 Or  reVersion = 5
		// v.ObjectMeta.Name Or v.Annotations["deployment.kubernetes.io/revision"] == reVersion
		currentVersion := tools.ParseStringToInt64(v.Annotations["deployment.kubernetes.io/revision"])
		if currentVersion == reVersion {
			deployment.Spec.Template = v.Spec.Template
			if _, rollbackErr := client.AppsV1().Deployments(namespace).Update(context.TODO(), deployment, metav1.UpdateOptions{}); rollbackErr != nil {
				common.LOG.Error("版本回退失败", zap.Any("err: ", err))
				return rollbackErr
			}
			common.LOG.Info("The rollback task was executed successfully")
			return nil
		}
	}
	return nil
}

func deploymentRevision(deployment *apps.Deployment, c kubernetes.Interface, toRevision int64) (revision *apps.ReplicaSet, err error) {

	_, allOldRSs, newRS, err := deploymentutil.GetAllReplicaSets(deployment, c.AppsV1())
	if err != nil {
		return nil, fmt.Errorf("failed to retrieve replica sets from deployment %s: %v", deployment.Name, err)
	}
	allRSs := allOldRSs
	if newRS != nil {
		allRSs = append(allRSs, newRS)
	}

	var (
		latestReplicaSet   *apps.ReplicaSet
		latestRevision     = int64(-1)
		previousReplicaSet *apps.ReplicaSet
		previousRevision   = int64(-1)
	)
	for _, rs := range allRSs {
		if v, err := deploymentutil.Revision(rs); err == nil {
			if toRevision == 0 {
				if latestRevision < v {
					// newest one we've seen so far
					previousRevision = latestRevision
					previousReplicaSet = latestReplicaSet
					latestRevision = v
					latestReplicaSet = rs
				} else if previousRevision < v {
					// second newest one we've seen so far
					previousRevision = v
					previousReplicaSet = rs
				}
			} else if toRevision == v {
				return rs, nil
			}
		}
	}

	if toRevision > 0 {
		return nil, revisionNotFoundErr(toRevision)
	}

	if previousReplicaSet == nil {
		return nil, fmt.Errorf("no rollout history found for deployment %q", deployment.Name)
	}
	return previousReplicaSet, nil
}

func revisionNotFoundErr(r int64) error {
	common.LOG.Warn("没有找到可回滚的版本！")
	return fmt.Errorf("unable to find specified revision %v in history", r)
}
