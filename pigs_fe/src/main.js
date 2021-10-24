import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from "@/store/index";

// 导入antd
import Antd from 'ant-design-vue';
import "ant-design-vue/dist/antd.css";

import { message } from 'ant-design-vue'
import { VueCookieNext } from 'vue-cookie-next'

const app = createApp(App)
app.provide('$message', message)
app.use(router).use(Antd).use(store).use(VueCookieNext).mount('#app')