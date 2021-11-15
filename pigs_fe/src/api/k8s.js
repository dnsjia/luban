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