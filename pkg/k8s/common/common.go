package common

import v1 "k8s.io/apimachinery/pkg/apis/meta/v1"

// Condition represents a single condition of a pod or node.
type Condition struct {
	// Type of a condition.
	Type string `json:"type"`
	// Status of a condition.
	Status v1.ConditionStatus `json:"status"`
	// Last probe time of a condition.
	LastProbeTime v1.Time `json:"lastProbeTime"`
	// Last transition time of a condition.
	LastTransitionTime v1.Time `json:"lastTransitionTime"`
	// Reason of a condition.
	Reason string `json:"reason"`
	// Message of a condition.
	Message string `json:"message"`
}
