import {post, get} from "@/plugin/utils/request";

export const k8sCluster = (params) => post('/api/v1/k8s/cluster', params)
export const fetchK8SCluster = (params) => get('/api/v1/k8s/cluster', params)

