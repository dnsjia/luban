import axios from "axios";
import router from '@/router'
import { message } from "ant-design-vue";
import Nprogress from 'nprogress'
import store from '@/store/index';

// 环境的切换
if (process.env.NODE_ENV === 'dev') {
    axios.defaults.baseURL = process.env.VUE_APP_BASE_URL;
} else if (process.env.NODE_ENV === 'test') {
    axios.defaults.baseURL = process.env.VUE_APP_BASE_URL;
} else if (process.env.NODE_ENV === 'prod') {
    axios.defaults.baseURL = process.env.VUE_APP_BASE_URL;
}

// 创建实例时配置的默认值
const instance = axios.create({
     // baseURL: baseurl,
     timeout: 60000
});
// 默认请求头信息
axios.defaults.headers.post['Content-Type'] = 'application/json;charset=UTF-8';
//axios.defaults.headers.post['X-CSRFToken'] = getCookie("csrftoken")
axios.defaults.headers.put['Content-Type'] = 'application/json;charset=UTF-8';
//axios.defaults.headers.put['X-CSRFToken'] = getCookie("csrftoken")

/**
 * 跳转登录页
 * 携带当前页面路由，以期在登录页面完成登录后返回当前页面
 */
const toLogin = () => {
      router.push({
        path: "/user/login",
        query: {
            redirect: router.currentRoute.fullPath
        }//从哪个页面跳转
      })
}


const errorHandle = (status) => {
    // 状态码判断
    switch (status) {
        case 401:
            message.error('登录过期，请重新登录!')
            localStorage.removeItem('token');
            localStorage.removeItem('onLine');
            toLogin();
            break;
        // 403 token过期, 清除token并跳转登录页
        case 403:
            message.warning('无权限访问！')
            // localStorage.removeItem('token');
            // localStorage.removeItem('onLine');
            //store.commit('loginSuccess', null);
            // setTimeout(() => {
            //     toLogin();
            // }, 1000);
            break;

        case 404:
            message.error('请求的资源不存在!')
            break;
        case 400:
            message.error("token验证失败!")
            toLogin();
            break;
        case 429:
            message.warning("当前访问太过频繁,请稍等再试!")
            break;
        case 500:
            message.error("服务端错误,请稍后再试!")
            break;
        case 502:
            message.error("网关错误,请稍后再试!")
            break;
        case 504:
            message.error("响应超时,请刷新后再试!")
            break;
        default:
            message.error("服务繁忙" + status)
        }}

/**
 * 请求拦截器
 * 每次请求前，如果存在token则在请求头中携带token
 */
instance.interceptors.request.use(
    config => {
        // 登录流程控制中，根据本地是否存在token判断用户的登录情况
        // 但是即使token存在，也有可能token是过期的，所以在每次的请求头中携带token
        // 后台根据携带的token判断用户的登录情况，并返回给我们对应的状态码
        // 而后我们可以在响应拦截器中，根据状态码进行一些统一的操作。
        const token = localStorage.getItem('token');
        token && (config.headers["token"] = 'jwt ' + token);
        Nprogress.start();
        return config;
    },
    error => Promise.error(error))


// 响应拦截器
instance.interceptors.response.use(function (response){
    // 请求成功
    Nprogress.done()
    if (response.status === 200){
        return Promise.resolve(response)
    }else {
        return Promise.reject(response)
    }

},function (error){
        // 请求失败
        const {response} = error;
        if (response) {
            // 请求已发出，但是不在2xx的范围
            errorHandle(response.status);
            return Promise.reject(response);
        } else {
            // 处理断网的情况
            // eg:请求超时或断网时，更新state的network状态
            // network状态在app.vue中控制着一个全局的断网提示组件的显示隐藏
            // 关于断网组件中的刷新重新获取数据，会在断网组件中说明
            if (!window.navigator.onLine) {
              store.commit('changeNetwork', false);
              message.warn("网络已断开,请检查网络后重试！")
              router.push({name:'refresh'})
            } else {
                message.error("系统异常")
                return Promise.reject(error);
            }
        }
});

/**
 * get方法，对应get请求
 * @param {String} url [请求的url地址]
 * @param {Object} params [请求时携带的参数]
 */
export function get(url, params){
    return new Promise((resolve, reject) =>{
        instance.get(url, {
            params: params
        }).then(res => {
            resolve(res.data);
        }).catch(err =>{
            reject(err.data)
        })
    });
}

/**
 * post方法，对post请求
 * @param {String} url [请求的url地址]
 * @param {Object} params [请求时携带的请求体内容]
 */
export function post(url, params) {
    return new Promise((resolve, reject) => {
         instance.post(url, params)
        .then(res => {
            resolve(res.data);
        })
        .catch(err =>{
            reject(err.data)
        })
    });
}


export default instance;