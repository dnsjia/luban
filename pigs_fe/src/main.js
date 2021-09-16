import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from "@/store/index";

// 导入antd
import Antd from 'ant-design-vue';
import "ant-design-vue/dist/antd.css";


createApp(App).use(router).use(Antd).use(store).mount('#app')
