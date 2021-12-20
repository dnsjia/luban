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

package service

import (
	"context"
	"fmt"
	"github.com/dnsjia/luban/common"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	"github.com/dnsjia/luban/pkg/k8s/dataselect"
	"github.com/dnsjia/luban/pkg/k8s/endpoint"
	"github.com/dnsjia/luban/pkg/k8s/pods"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
)

// ServiceDetail is a representation of a service.
type ServiceDetail struct {
	// Extends list item structure.
	Service `json:",inline"`

	// List of Endpoint obj. that are endpoints of this Service.
	EndpointList endpoint.EndpointList `json:"endpointList"`

	// Show the value of the SessionAffinity of the Service.
	SessionAffinity v1.ServiceAffinity `json:"sessionAffinity"`

	EventList *k8scommon.EventList `json:"eventList"`

	PodList *pods.PodList `json:"podList"`
}

// GetServiceDetail gets service details.
func GetServiceDetail(client *kubernetes.Clientset, namespace, name string, dsQuery *dataselect.DataSelectQuery) (*ServiceDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s service in %s namespace", name, namespace))
	serviceData, err := client.CoreV1().Services(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	endpointList, err := endpoint.GetServiceEndpoints(client, namespace, name)
	if err != nil {
		return nil, err
	}
	podList, err := GetServicePods(client, namespace, name, dsQuery)
	if err != nil {
		return nil, err
	}

	eventList, err := GetServiceEvents(client, dataselect.DefaultDataSelect, namespace, name)
	if err != nil {
		return nil, err
	}

	service := toServiceDetail(serviceData, *endpointList, podList, eventList)
	return &service, nil
}

func toServiceDetail(service *v1.Service, endpointList endpoint.EndpointList, podList *pods.PodList, eventList *k8scommon.EventList) ServiceDetail {
	return ServiceDetail{
		Service:         ToService(service),
		EndpointList:    endpointList,
		PodList:         podList,
		EventList:       eventList,
		SessionAffinity: service.Spec.SessionAffinity,
	}
}
