
#### kubectl rollout restart deployment your_deployment_name

#### 支持的对象 "deployment", "daemonset", "statefulset"

 - 运行时kubectl rollout restart deployment，它会添加一个kubectl.kubernetes.io/restartedAt包含时间戳的注释，如下所示：

```azure
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/restartedAt: "2021-10-28T11:12:54-05:00"

```
#### Go代码示例：
```azure
data := fmt.Sprintf(`{"spec":{"template":{"metadata":{"annotations":{"kubectl.kubernetes.io/restartedAt":"%s"}}}}}`, time.Now().String())
    resultDeployment, err = p.Client.AppsV1().Deployments(p.Namespace).Patch(context.Background(), deployment.Name, types.StrategicMergePatchType, []byte(data), metav1.PatchOptions{FieldManager: "kubectl-rollout"})
```
#### Python代码示例：

```azure
from kubernetes import client, config
from kubernetes.client.rest import ApiException
import datetime

def restart_deployment(v1_apps, deployment, namespace):
    now = datetime.datetime.utcnow()
    now = str(now.isoformat("T") + "Z")
    body = {
        'spec': {
            'template':{
                'metadata': {
                    'annotations': {
                        'kubectl.kubernetes.io/restartedAt': now
                    }
                }
            }
        }
    }
    try:
        v1_apps.patch_namespaced_deployment(deployment, namespace, body, pretty='true')
    except ApiException as e:
        print("Exception when calling AppsV1Api->read_namespaced_deployment_status: %s\n" % e)


def main():
    config.load_kube_config()
    # Enter name of deployment and "namespace"
    deployment = "dashboard-kubernetes-dashboard"
    namespace = "default"
    v1_apps = client.AppsV1Api()
    restart_deployment(v1_apps, deployment, namespace)


if __name__ == '__main__':
    main()

```