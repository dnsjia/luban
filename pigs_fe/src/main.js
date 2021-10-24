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
    }

}

app.provide('$message', message)
app.use(router).use(Antd).use(store).use(VueCookieNext).mount('#app')