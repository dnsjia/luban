package secret

import (
	"context"
	"fmt"
	v1 "k8s.io/api/core/v1"
	metaV1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"pigs/common"
)

// SecretDetail API resource provides mechanisms to inject containers with configuration data while keeping
// containers agnostic of Kubernetes
type SecretDetail struct {
	// Extends list item structure.
	Secret `json:",inline"`

	// Data contains the secret data.  Each key must be a valid DNS_SUBDOMAIN
	// or leading dot followed by valid DNS_SUBDOMAIN.
	// The serialized form of the secret data is a base64 encoded string,
	// representing the arbitrary (possibly non-string) data value here.
	Data map[string][]byte `json:"data"`
}

// GetSecretDetail returns detailed information about a secret
func GetSecretDetail(client kubernetes.Interface, namespace, name string) (*SecretDetail, error) {
	common.LOG.Info(fmt.Sprintf("Getting details of %s secret in %s namespace", name, namespace))

	rawSecret, err := client.CoreV1().Secrets(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
	if err != nil {
		return nil, err
	}

	return getSecretDetail(rawSecret), nil
}

func getSecretDetail(rawSecret *v1.Secret) *SecretDetail {
	return &SecretDetail{
		Secret: toSecret(rawSecret),
		Data:   rawSecret.Data,
	}
}
