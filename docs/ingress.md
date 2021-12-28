
#### Ingress
- Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress


ingres\ingress.go
```
import (
  v1 "k8s.io/api/extensions/v1beta1"
)
// line +54
ingressList, err := client.ExtensionsV1beta1().Ingresses(namespace.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
```

ingress\ingress_common.go
```
import (
  v1 "k8s.io/api/extensions/v1beta1"
)
```

ingress\ingress_detail.go
```
import (
  v1 "k8s.io/api/extensions/v1beta1"
)
// line +46
rawIngress, err := client.ExtensionsV1beta1().Ingresses(namespace).Get(context.TODO(), name, metaV1.GetOptions{})
```

- 集群版本大于1.22.x
```
import (
    v1 "k8s.io/api/networking/v1"
)
ingressList, err := client.NetworkingV1().Ingresses(namespace.ToRequestParam()).List(context.TODO(), k8s.ListEverything)
```