import {get} from "@/plugin/utils/request";

export const getHost = (params) => get('/api/v1/cmdb/host/server', params)