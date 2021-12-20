import {post, get, del} from "@/plugin/utils/request";

export const k8sCluster = (params) => post('/api/v1/k8s/cluster', params)
export const fetchK8SCluster = (params) => get('/api/v1/k8s/cluster', params)
export const clusterSecret = (params) => get('/api/v1/k8s/cluster/secret', params)
export const delK8SCluster = (params) => post('/api/v1/k8s/cluster/delete', params)
export const getK8SClusterDetail = (params) => get('/api/v1/k8s/cluster/detail', params)
export const getEvents = (params) => get('/api/v1/k8s/events', params)
export const getNodes = (params) => get('/api/v1/k8s/node', params)
export const NodeDetail = (params) => get('/api/v1/k8s/node/detail', params)
export const NodeSchedule = (params, clusterId) => post('/api/v1/k8s/node/schedule?clusterId=' + clusterId, params)
export const NodeCordon = (params, clusterId) => get('/api/v1/k8s/node/cordon?clusterId=' + clusterId, params)
export const RemoveNode = (params, clusterId) => del('/api/v1/k8s/node?clusterId=' + clusterId, params)
export const CollectionNodeSchedule = (params, clusterId) => post('/api/v1/k8s/node/collectionSchedule?clusterId=' + clusterId, params)
export const CollectionCordonNode = (params, clusterId) => post('/api/v1/k8s/node/collectionCordon?clusterId=' + clusterId, params)


export const GetNamespaces = (clusterId) => get('/api/v1/k8s/namespace?clusterId=' + clusterId)
export const GetDeployment = (clusterId, params) => get('/api/v1/k8s/deployment?clusterId=' + clusterId, params)
export const DeleteCollectionDeployment = (clusterId, params) => post('/api/v1/k8s/deployments?clusterId=' + clusterId, params)
export const DeleteDeployment = (clusterId, params) => post('/api/v1/k8s/deployment/delete?clusterId=' + clusterId, params)
export const ScaleDeployment = (clusterId, params) => post('/api/v1/k8s/deployment/scale?clusterId=' + clusterId, params)
export const restartDeployment = (clusterId, params) => post('/api/v1/k8s/deployment/restart?clusterId=' + clusterId, params)
export const DeploymentDetail = (params) => get('/api/v1/k8s/deployment/detail', params)
export const DeploymentRollBack = (clusterId, params) => post('/api/v1/k8s/deployment/rollback?clusterId=' + clusterId, params)

export const GetDeploymentToService = (clusterId, params) => post('/api/v1/k8s/deployment/service?clusterId=' + clusterId, params)

export const GetPodsList = (clusterId, params) => get('/api/v1/k8s/pod?clusterId=' + clusterId, params)
export const DeleteCollectionPods = (clusterId, params) => post('/api/v1/k8s/pods?clusterId=' + clusterId, params)
export const DeletePod = (clusterId, params) => del('/api/v1/k8s/pod?clusterId=' + clusterId, params)
export const PodDetail = (params) => get('/api/v1/k8s/pod/detail', params)

export const GetStatefulSet = (clusterId, params) => get('/api/v1/k8s/statefulset?clusterId=' + clusterId, params)
export const DeleteCollectionStatefulSet = (clusterId, params) => post('/api/v1/k8s/statefulsets?clusterId=' + clusterId, params)
export const DeleteStatefulSet = (clusterId, params) => del('/api/v1/k8s/statefulset?clusterId=' + clusterId, params)
export const restartStatefulSet = (clusterId, params) => post('/api/v1/k8s/statefulset/restart?clusterId=' + clusterId, params)
export const scaleStatefulSet = (clusterId, params) => post('/api/v1/k8s/statefulset/scale?clusterId=' + clusterId, params)
export const StatefulSetDetail = (params) => get('/api/v1/k8s/statefulset/detail', params)

export const GetDaemonSet = (clusterId, params) => get('/api/v1/k8s/daemonset?clusterId=' + clusterId, params)
export const DeleteCollectionDaemonSet = (clusterId, params) => post('/api/v1/k8s/daemonsets?clusterId=' + clusterId, params)
export const DeleteDaemonSet = (clusterId, params) => del('/api/v1/k8s/daemonset?clusterId=' + clusterId, params)
export const RestartDaemonSet = (clusterId, params) => post('/api/v1/k8s/daemonset/restart?clusterId=' + clusterId, params)
export const DaemonSetDetail = (clusterId, params) => get('/api/v1/k8s/daemonset/detail?clusterId=' + clusterId, params)

export const GetJob = (clusterId, params) => get('/api/v1/k8s/job?clusterId=' + clusterId, params)
export const DeleteCollectionJob = (clusterId, params) => post('/api/v1/k8s/jobs?clusterId=' + clusterId, params)
export const DeleteJob = (clusterId, params) => del('/api/v1/k8s/job?clusterId=' + clusterId, params)
export const ScaleJob = (clusterId, params) => post('/api/v1/k8s/job/scale?clusterId=' + clusterId, params)
export const JobDetail = (clusterId, params) => get('/api/v1/k8s/job/detail?clusterId=' + clusterId, params)

export const GetCronJob = (clusterId, params) => get('/api/v1/k8s/cronjob?clusterId=' + clusterId, params)
export const DeleteCollectionCronJob = (clusterId, params) => post('/api/v1/k8s/cronjobs?clusterId=' + clusterId, params)
export const DeleteCronJob = (clusterId, params) => del('/api/v1/k8s/cronjob?clusterId=' + clusterId, params)
export const CronJobDetail = (clusterId, params) => get('/api/v1/k8s/cronjob/detail?clusterId=' + clusterId, params)

export const GetPVC = (clusterId, params) => get('/api/v1/k8s/storage/pvc?clusterId=' + clusterId, params)
export const DeletePVC = (clusterId, params) => del('/api/v1/k8s/storage/pvc?clusterId=' + clusterId, params)
export const PVCDetail = (clusterId, params) => get('/api/v1/k8s/storage/pvc/detail?clusterId=' + clusterId, params)

export const GetPV = (clusterId, params) => get('/api/v1/k8s/storage/pv?clusterId=' + clusterId, params)
export const DeletePV = (clusterId, params) => del('/api/v1/k8s/storage/pv?clusterId=' + clusterId, params)
export const PVDetail = (clusterId, params) => get('/api/v1/k8s/storage/pv/detail?clusterId=' + clusterId, params)

export const GetStorageClass = (clusterId, params) => get('/api/v1/k8s/storage/sc?clusterId=' + clusterId, params)
export const DeleteStorageClass = (clusterId, params) => del('/api/v1/k8s/storage/sc?clusterId=' + clusterId, params)
export const StorageClassDetail = (clusterId, params) => get('/api/v1/k8s/storage/sc/detail?clusterId=' + clusterId, params)

export const GetServiceList = (clusterId, params) => get('/api/v1/k8s/network/service?clusterId=' + clusterId, params)
export const DeleteCollectionService = (clusterId, params) => post('/api/v1/k8s/network/services?clusterId=' + clusterId, params)
export const DeleteService = (clusterId, params) => del('/api/v1/k8s/network/service?clusterId=' + clusterId, params)
export const ServiceDetail = (clusterId, params) => get('/api/v1/k8s/network/service/detail?clusterId=' + clusterId, params)

export const GetIngressList = (clusterId, params) => get('/api/v1/k8s/network/ingress?clusterId=' + clusterId, params)
export const DeleteCollectionIngress = (clusterId, params) => post('/api/v1/k8s/network/ingresss?clusterId=' + clusterId, params)
export const DeleteIngress = (clusterId, params) => del('/api/v1/k8s/network/ingress?clusterId=' + clusterId, params)
export const IngressDetail = (clusterId, params) => get('/api/v1/k8s/network/ingress/detail?clusterId=' + clusterId, params)

export const GetConfigMapList = (clusterId, params) => get('/api/v1/k8s/config/configmap?clusterId=' + clusterId, params)
export const DeleteCollectionConfigMap = (clusterId, params) => post('/api/v1/k8s/config/configmaps?clusterId=' + clusterId, params)
export const DeleteConfigMap = (clusterId, params) => del('/api/v1/k8s/config/configmap?clusterId=' + clusterId, params)
export const ConfigMapDetail = (clusterId, params) => get('/api/v1/k8s/config/configmap/detail?clusterId=' + clusterId, params)

export const GetSecretList = (clusterId, params) => get('/api/v1/k8s/config/secret?clusterId=' + clusterId, params)
export const DeleteCollectionSecret = (clusterId, params) => post('/api/v1/k8s/config/secrets?clusterId=' + clusterId, params)
export const DeleteSecret = (clusterId, params) => del('/api/v1/k8s/config/secret?clusterId=' + clusterId, params)
export const SecretDetail = (clusterId, params) => get('/api/v1/k8s/config/secret/detail?clusterId=' + clusterId, params)

// /api/v1/k8s/log/source/develop/nginx-5468c8b895-nj8sx/pod?clusterId=24
export const GetLogSource = (params) => get('/api/v1/k8s/log/source', params)