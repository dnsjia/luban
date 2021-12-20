import {post} from "@/plugin/utils/request";

export const login = (params) => post('/api/v1/user/login', params)

