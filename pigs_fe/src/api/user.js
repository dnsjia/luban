import {post} from "@/plugin/utils/request";

export const login = (params) => post('/user/login', params)

