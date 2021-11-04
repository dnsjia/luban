package persistentvolumeclaim

import (
	"context"
	"fmt"
	api "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	client "k8s.io/client-go/kubernetes"
	"pigs/common"
	k8scommon "pigs/pkg/k8s/common"
	"pigs/pkg/k8s/dataselect"
	"strings"
)

// The code below allows to perform complex data section on []api.PersistentVolumeClaim

type PersistentVolumeClaimCell api.PersistentVolumeClaim

// GetPodPersistentVolumeClaims gets persistentvolumeclaims that are associated with this pod.
func GetPodPersistentVolumeClaims(client client.Interface, namespace string, podName string,
	dsQuery *dataselect.DataSelectQuery) (*PersistentVolumeClaimList, error) {

	pod, err := client.CoreV1().Pods(namespace).Get(context.TODO(), podName, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	claimNames := make([]string, 0)
	if pod.Spec.Volumes != nil && len(pod.Spec.Volumes) > 0 {
		for _, v := range pod.Spec.Volumes {
			persistentVolumeClaim := v.PersistentVolumeClaim
			if persistentVolumeClaim != nil {
				claimNames = append(claimNames, persistentVolumeClaim.ClaimName)
			}
		}
	}

	if len(claimNames) > 0 {
		channels := &k8scommon.ResourceChannels{
			PersistentVolumeClaimList: k8scommon.GetPersistentVolumeClaimListChannel(
				client, k8scommon.NewSameNamespaceQuery(namespace), 1),
		}

		persistentVolumeClaimList := <-channels.PersistentVolumeClaimList.List

		err = <-channels.PersistentVolumeClaimList.Error
		if err != nil {
			return nil, err
		}

		podPersistentVolumeClaims := make([]api.PersistentVolumeClaim, 0)
		for _, pvc := range persistentVolumeClaimList.Items {
			for _, claimName := range claimNames {
				if strings.Compare(claimName, pvc.Name) == 0 {
					podPersistentVolumeClaims = append(podPersistentVolumeClaims, pvc)
					break
				}
			}
		}

		common.LOG.Info(fmt.Sprintf("Found %d persistentvolumeclaims related to %s pod", len(podPersistentVolumeClaims), podName))

		return toPersistentVolumeClaimList(podPersistentVolumeClaims, dsQuery), nil
	}

	common.LOG.Warn(fmt.Sprintf("No persistentvolumeclaims found related to %s pod", podName))

	// No ClaimNames found in Pod details, return empty response.
	return &PersistentVolumeClaimList{}, nil
}

func (self PersistentVolumeClaimCell) GetProperty(name dataselect.PropertyName) dataselect.ComparableValue {
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

func toCells(std []api.PersistentVolumeClaim) []dataselect.DataCell {
	cells := make([]dataselect.DataCell, len(std))
	for i := range std {
		cells[i] = PersistentVolumeClaimCell(std[i])
	}
	return cells
}

func fromCells(cells []dataselect.DataCell) []api.PersistentVolumeClaim {
	std := make([]api.PersistentVolumeClaim, len(cells))
	for i := range std {
		std[i] = api.PersistentVolumeClaim(cells[i].(PersistentVolumeClaimCell))
	}
	return std
}
