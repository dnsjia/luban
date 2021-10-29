import {createApp} from 'vue'
import App from './App.vue'
import router from './router'
import store from "@/store/index";

// 导入antd
import Antd, {message} from 'ant-design-vue';
import "ant-design-vue/dist/antd.css";
import {VueCookieNext} from 'vue-cookie-next'
import filter from "./plugin/filter";



const app = createApp(App)
app.config.globalProperties.$filters = {
    fmtTime(value) {
        return filter.fmtTime(value)
    },
    addZero(value) {
        return filter.addZero(value)
    },
    sizeType(value) {
        return filter.sizeType(value)
    },
    aliyunEcsMemory(value) {
        if (value === 0) return '0';
        var k = 1024,
            sizes = ['MB', 'GB', 'TB'],
            i = Math.floor(Math.log(value) / Math.log(k));
        return (value / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
    },

}

app.provide('$message', message)
app.use(router).use(Antd).use(store).use(VueCookieNext).mount('#app')