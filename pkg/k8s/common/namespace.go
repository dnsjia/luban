package common

import api "k8s.io/api/core/v1"

// NamespaceQuery is a query for namespaces of a list of objects.
// There's three cases:
// 1. No namespace selected: this means "user namespaces" query, i.e., all except kube-system
// 2. Single namespace selected: this allows for optimizations when querying backends
// 3. More than one namespace selected: resources from all namespaces are queried and then
//    filtered here.
type NamespaceQuery struct {
	Namespaces []string
}

// ToRequestParam returns K8s API namespace query for list of objects from this namespaces.
// This is an optimization to query for single namespace if one was selected and for all
// namespaces otherwise.
func (n *NamespaceQuery) ToRequestParam() string {
	if len(n.Namespaces) == 1 {
		return n.Namespaces[0]
	}
	return api.NamespaceAll
}

// Matches returns true when the given namespace matches this query.
func (n *NamespaceQuery) Matches(namespace string) bool {
	if len(n.Namespaces) == 0 {
		return true
	}

	for _, queryNamespace := range n.Namespaces {
		if namespace == queryNamespace {
			return true
		}
	}
	return false
}

// NewSameNamespaceQuery creates new namespace query that queries single namespace.
func NewSameNamespaceQuery(namespace string) *NamespaceQuery {
	return &NamespaceQuery{[]string{namespace}}
}

// NewNamespaceQuery creates new query for given namespaces.
func NewNamespaceQuery(namespaces []string) *NamespaceQuery {
	return &NamespaceQuery{namespaces}
}
