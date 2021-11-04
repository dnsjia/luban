import {post} from "@/plugin/utils/request";

export const CloudAccount = (params) => post('/api/v1/cloud/account', params)