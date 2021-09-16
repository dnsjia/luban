import {createRouter, createWebHistory} from 'vue-router'


const routes = [
    {
        path: '/',
        name: 'Home',
        component: () => import('../Layout.vue'),
        children: [
            {
                path: '',
                name: 'Index',
                component: () => import('../views/Index.vue'),
                meta: {
                    title: '仪表盘',
                }
            },
        ]
    },
    {
        path: '/user/login',
        name: 'Login',
        component: () => import('../views/user/Login.vue'),
        meta: {
            title: '用户登录',
            module: "用户登录"
        }
    },
    {
        path: '/403',
        name: '403',
        component: () => import('../views/error/403.vue'),
        meta: {
            title: '当前无权限操作, 请联系管理员!'
        }
    },
    {
        path: '/404',
        component: () => import('../views/error/404.vue'),
        meta: {
            title: 'Not Found 当前页面未找到!'
        }
    },
    {
        path: '/refresh',
        name: 'refresh',
        component: () => import('../views/error/refresh.vue'),
        meta: {
            title: '网络已断开'
        }
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router
