package common

import (
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"pigs/models/k8s"
)

// EventList is an events response structure.
type EventList struct {
	ListMeta k8s.ListMeta `json:"listMeta"`

	// List of events from given namespace.
	Events []Event `json:"events"`
}

// Event is a single event representation.
type Event struct {
	ObjectMeta k8s.ObjectMeta `json:"objectMeta"`
	TypeMeta   k8s.TypeMeta   `json:"typeMeta"`

	// A human-readable description of the status of related object.
	Message string `json:"message"`

	// Component from which the event is generated.
	SourceComponent string `json:"sourceComponent"`

	// Host name on which the event is generated.
	SourceHost string `json:"sourceHost"`

	// Reference to a piece of an object, which triggered an event. For example
	// "spec.containers{name}" refers to container within pod with given name, if no container
	// name is specified, for example "spec.containers[2]", then it refers to container with
	// index 2 in this pod.
	SubObject string `json:"object"`

	// Kind of the referent.
	// +optional
	SubObjectKind string `json:"objectKind,omitempty"`

	// Name of the referent.
	// +optional
	SubObjectName string `json:"objectName,omitempty"`

	// Namespace of the referent.
	// +optional
	SubObjectNamespace string `json:"objectNamespace,omitempty"`

	// The number of times this event has occurred.
	Count int32 `json:"count"`

	// The time at which the event was first recorded.
	FirstSeen v1.Time `json:"firstSeen"`

	// The time at which the most recent occurrence of this event was recorded.
	LastSeen v1.Time `json:"lastSeen"`

	// Short, machine understandable string that gives the reason
	// for this event being generated.
	Reason string `json:"reason"`

	// Event type (at the moment only normal and warning are supported).
	Type string `json:"type"`
}
