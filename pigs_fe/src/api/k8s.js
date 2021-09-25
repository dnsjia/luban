import {post, get} from "@/plugin/utils/request";

export const k8sCluster = (params) => post('/k8s/cluster', params)
export const fetchK8SCluster = () => get('/k8s/cluster', '')
