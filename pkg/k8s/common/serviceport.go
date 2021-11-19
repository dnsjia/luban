package common

import api "k8s.io/api/core/v1"

// ServicePort is a pair of port and protocol, e.g. a service endpoint.
type ServicePort struct {
	// Positive port number.
	Port int32 `json:"port"`

	// Protocol name, e.g., TCP or UDP.
	Protocol api.Protocol `json:"protocol"`

	// The port on each node on which service is exposed.
	NodePort int32 `json:"nodePort"`
}

// GetServicePorts returns human readable name for the given service ports list.
func GetServicePorts(apiPorts []api.ServicePort) []ServicePort {
	var ports []ServicePort
	for _, port := range apiPorts {
		ports = append(ports, ServicePort{port.Port, port.Protocol, port.NodePort})
	}
	return ports
}
