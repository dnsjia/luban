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

package common

import (
	apps "k8s.io/api/apps/v1"
	batch "k8s.io/api/batch/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// FilterDeploymentPodsByOwnerReference returns a subset of pods controlled by given deployment.
func FilterDeploymentPodsByOwnerReference(deployment apps.Deployment, allRS []apps.ReplicaSet,
	allPods []v1.Pod) []v1.Pod {
	var matchingPods []v1.Pod
	for _, rs := range allRS {
		if metav1.IsControlledBy(&rs, &deployment) {
			matchingPods = append(matchingPods, FilterPodsByControllerRef(&rs, allPods)...)
		}
	}

	return matchingPods
}

// FilterPodsByControllerRef returns a subset of pods controlled by given controller resource, excluding deployments.
func FilterPodsByControllerRef(owner metav1.Object, allPods []v1.Pod) []v1.Pod {
	var matchingPods []v1.Pod
	for _, pod := range allPods {
		if metav1.IsControlledBy(&pod, owner) {
			matchingPods = append(matchingPods, pod)
		}
	}
	return matchingPods
}

// GetContainerImages returns container image strings from the given pod spec.
func GetContainerImages(podTemplate *v1.PodSpec) []string {
	var containerImages []string
	for _, container := range podTemplate.Containers {
		containerImages = append(containerImages, container.Image)
	}
	return containerImages
}

// GetInitContainerImages returns init container image strings from the given pod spec.
func GetInitContainerImages(podTemplate *v1.PodSpec) []string {
	var initContainerImages []string
	for _, initContainer := range podTemplate.InitContainers {
		initContainerImages = append(initContainerImages, initContainer.Image)
	}
	return initContainerImages
}

// FilterPodsForJob returns a list of pods that matches to a job controller's selector
func FilterPodsForJob(job batch.Job, pods []v1.Pod) []v1.Pod {
	result := make([]v1.Pod, 0)
	for _, pod := range pods {
		if pod.Namespace == job.Namespace {
			selectorMatch := true
			for key, value := range job.Spec.Selector.MatchLabels {
				if pod.Labels[key] != value {
					selectorMatch = false
					break
				}
			}
			if selectorMatch {
				result = append(result, pod)
			}
		}
	}

	return result
}

// GetContainerNames returns the container image name without the version number from the given pod spec.
func GetContainerNames(podTemplate *v1.PodSpec) []string {
	var containerNames []string
	for _, container := range podTemplate.Containers {
		containerNames = append(containerNames, container.Name)
	}
	return containerNames
}

// GetInitContainerNames returns the init container image name without the version number from the given pod spec.
func GetInitContainerNames(podTemplate *v1.PodSpec) []string {
	var initContainerNames []string
	for _, initContainer := range podTemplate.InitContainers {
		initContainerNames = append(initContainerNames, initContainer.Name)
	}
	return initContainerNames
}

// GetNonduplicateContainerImages returns list of container image strings without duplicates
func GetNonduplicateContainerImages(podList []v1.Pod) []string {
	var containerImages []string
	for _, pod := range podList {
		for _, container := range pod.Spec.Containers {
			if noStringInSlice(container.Image, containerImages) {
				containerImages = append(containerImages, container.Image)
			}
		}
	}
	return containerImages
}

// GetNonduplicateInitContainerImages returns list of init container image strings without duplicates
func GetNonduplicateInitContainerImages(podList []v1.Pod) []string {
	var initContainerImages []string
	for _, pod := range podList {
		for _, initContainer := range pod.Spec.InitContainers {
			if noStringInSlice(initContainer.Image, initContainerImages) {
				initContainerImages = append(initContainerImages, initContainer.Image)
			}
		}
	}
	return initContainerImages
}

// GetNonduplicateContainerNames returns list of container names strings without duplicates
func GetNonduplicateContainerNames(podList []v1.Pod) []string {
	var containerNames []string
	for _, pod := range podList {
		for _, container := range pod.Spec.Containers {
			if noStringInSlice(container.Name, containerNames) {
				containerNames = append(containerNames, container.Name)
			}
		}
	}
	return containerNames
}

// GetNonduplicateInitContainerNames returns list of init container names strings without duplicates
func GetNonduplicateInitContainerNames(podList []v1.Pod) []string {
	var initContainerNames []string
	for _, pod := range podList {
		for _, initContainer := range pod.Spec.InitContainers {
			if noStringInSlice(initContainer.Name, initContainerNames) {
				initContainerNames = append(initContainerNames, initContainer.Name)
			}
		}
	}
	return initContainerNames
}

//noStringInSlice checks if string in array
func noStringInSlice(str string, array []string) bool {
	for _, alreadystr := range array {
		if alreadystr == str {
			return false
		}
	}
	return true
}
