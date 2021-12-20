import {get} from "@/plugin/utils/request";

export const queryHostGroups = (params) => get('/api/v1/cmdb/host/group?echo=1', params)