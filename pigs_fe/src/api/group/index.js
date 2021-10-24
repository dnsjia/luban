import {get} from "@/plugin/utils/request";

export const getGroup = (params) => get('/api/v1/cmdb/host/group', params)