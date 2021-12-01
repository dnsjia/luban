package endpoint

import (
	"fmt"
	"github.com/dnsjia/luban/common"
	"github.com/dnsjia/luban/models/k8s"
	k8scommon "github.com/dnsjia/luban/pkg/k8s/common"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/fields"
	"k8s.io/apimachinery/pkg/labels"
	k8sClient "k8s.io/client-go/kubernetes"
)

type Endpoint struct {
	ObjectMeta k8s.ObjectMeta `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta   `json:"typeMeta"`

	// Hostname, either as a domain name or IP address.
	Host string `json:"host"`

	// Name of the node the endpoint is located
	NodeName *string `json:"nodeName"`

	// Status of the endpoint
	Ready bool `json:"ready"`

	// Array of endpoint ports
	Ports []v1.EndpointPort `json:"ports"`
}

// GetServiceEndpoints gets list of endpoints targeted by given label selector in given namespace.
func GetServiceEndpoints(client k8sClient.Interface, namespace, name string) (*EndpointList, error) {
	endpointList := &EndpointList{
		Endpoints: make([]Endpoint, 0),
		ListMeta:  k8s.ListMeta{TotalItems: 0},
	}

	serviceEndpoints, err := GetEndpoints(client, namespace, name)
	if err != nil {
		return endpointList, err
	}

	endpointList = toEndpointList(serviceEndpoints)
	common.LOG.Info(fmt.Sprintf("Found %d endpoints related to %s service in %s namespace", len(endpointList.Endpoints), name, namespace))
	return endpointList, nil
}

// GetEndpoints gets endpoints associated to resource with given name.
func GetEndpoints(client k8sClient.Interface, namespace, name string) ([]v1.Endpoints, error) {
	fieldSelector, err := fields.ParseSelector("metadata.name" + "=" + name)
	if err != nil {
		return nil, err
	}

	channels := &k8scommon.ResourceChannels{
		EndpointList: k8scommon.GetEndpointListChannelWithOptions(client,
			k8scommon.NewSameNamespaceQuery(namespace),
			metaV1.ListOptions{
				LabelSelector: labels.Everything().String(),
				FieldSelector: fieldSelector.String(),
			},
			1),
	}

	endpointList := <-channels.EndpointList.List
	if err := <-channels.EndpointList.Error; err != nil {
		return nil, err
	}

	return endpointList.Items, nil
}

// toEndpoint converts endpoint api Endpoint to Endpoint model object.
func toEndpoint(address v1.EndpointAddress, ports []v1.EndpointPort, ready bool) *Endpoint {

	return &Endpoint{
		TypeMeta: k8s.NewTypeMeta(k8s.ResourceKindEndpoint),
		Host:     address.IP,
		Ports:    ports,
		Ready:    ready,
		NodeName: address.NodeName,
	}
}
