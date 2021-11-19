<template>
  <a-layout class="layout" style="min-height: 100vh">
    <a-layout-sider :style="{ overflow: 'auto', height: '100vh', position: 'fixed', left: 0 }">
      <div class="logo" >{{ title }}</div>
      <a-menu theme="dark" mode="inline" v-model:selectedKeys="selectedKeys">
        <a-menu-item key="1">
          <router-link :to="{path: '/'}">
          <IconFont type="pigs-icon-ziyuan"/>
            <span class="nav-text">仪表盘</span>
          </router-link>
        </a-menu-item>

        <a-sub-menu key="2">
          <template #icon>
            <IconFont type="pigs-icon-fuwuqi1"/>
          </template>
          <template #title>资产管理</template>
          <a-menu-item key="21">
            <router-link :to="{path: '/cmdb/server'}">
              服务器
            </router-link>
          </a-menu-item>
        </a-sub-menu>

        <a-sub-menu key="3">
          <template #icon>
            <IconFont type="pigs-icon-Kubernetes"/>
          </template>
          <template #title>容器管理</template>

          <a-menu-item key="31">
            <router-link :to="{path: '/k8s/cluster'}">
              集群管理
            </router-link>
          </a-menu-item>
          <a-menu-item key="32">
            <router-link :to="{path: '/k8s/node'}">
              节点管理
            </router-link>
          </a-menu-item>
          <a-menu-item key="33">
            <router-link :to="{path: '/k8s/workload'}">
              工作负载
            </router-link>
          </a-menu-item>
          <a-menu-item key="34">
            <router-link :to="{path: '/k8s/storage'}">
              存储管理
            </router-link>
          </a-menu-item>
          <a-menu-item key="35">
            <router-link :to="{path: '/k8s/networks'}">
              网络管理
            </router-link>
          </a-menu-item>
          <a-menu-item key="36">
            <router-link :to="{path: '/k8s/config'}">
              配置管理
            </router-link>
          </a-menu-item>
          <a-menu-item key="37">
            <router-link :to="{path: '/k8s/event'}">
              事件中心
            </router-link>
          </a-menu-item>
        </a-sub-menu>

        <a-sub-menu key="4">
          <template #icon>
            <IconFont type="pigs-icon-yunweipeizhiguanli"/>
          </template>
          <template #title>作业配置</template>

          <a-menu-item key="41">
            <router-link :to="{path: '/task/execute'}">
              执行任务
            </router-link>
          </a-menu-item>
          <a-menu-item key="42">
            <router-link :to="{path: '/task/template'}">
              任务模板
            </router-link>
          </a-menu-item>
        </a-sub-menu>

        <a-sub-menu key="5">
          <template #icon>
            <IconFont type="pigs-icon-gengduoyingyong"/>
          </template>
          <template #title>应用发布</template>

          <a-menu-item key="41">
            <router-link :to="{path: '/application/apps/manage'}">
              应用管理
            </router-link>
          </a-menu-item>
          <a-menu-item key="42">
            <router-link :to="{path: '/application/environment'}">
              环境管理
            </router-link>
          </a-menu-item>
          <a-menu-item key="42">
            <router-link :to="{path: '/application/apps/deploy/approval'}">
              发布申请
            </router-link>
          </a-menu-item>
        </a-sub-menu>

        <a-sub-menu key="6">
          <template #icon>
            <IconFont type="pigs-icon-yonghuzhongxin_shezhizhongxin"/>
          </template>
          <template #title>个人中心</template>

          <a-menu-item key="61">
            <router-link :to="{path: '/user/change/password'}">
              修改密码
            </router-link>
          </a-menu-item>
          <a-menu-item key="62">
            <router-link :to="{path: '/user/manage'}">
              用户管理
            </router-link>
          </a-menu-item>
          <a-menu-item key="63">
            <router-link :to="{path: '/system/settings'}">
              系统设置
            </router-link>
          </a-menu-item>
        </a-sub-menu>


      </a-menu>
    </a-layout-sider>
    <a-layout :style="{ marginLeft: '200px' }">
      <a-layout-header :style="{ background: '#fff', padding: 0 }" >
        <a-row>
          <a-col>
          </a-col>

          <a-col>
            <a-dropdown>
              <span class="ant-dropdown-link">
                <a-badge :count="1">
                  <a-avatar src="https://static-legacy.dingtalk.com/media/lADPBbCc1s5jzxHNBLnNBNo_1242_1209.jpg" icon="user">
                  </a-avatar>
                </a-badge>
                <span style="padding-left: 8px;"> 张三</span>
              </span>

              <template v-slot:overlay>
                <a-menu>
                  <a-menu-item @click="userCenter">
                    <UserOutlined />个人中心
                  </a-menu-item>
                  <a-menu-item @click="Logout()">
                    <LogoutOutlined />注销登录
                  </a-menu-item>
                </a-menu>
              </template>
            </a-dropdown>
          </a-col>
        </a-row>

      </a-layout-header>

      <a-layout-content :style="{ margin: '24px 16px 0', overflow: 'initial'}">
        <!--面包屑-->
        <a-breadcrumb  style="margin: 14px 0">
          <a-breadcrumb-item>     首页</a-breadcrumb-item>
          <a-breadcrumb-item v-if="$route.meta.module"><a href="">{{ $route.meta.module }}</a></a-breadcrumb-item>
          <a-breadcrumb-item>{{ $route.meta.title }}</a-breadcrumb-item>
        </a-breadcrumb>

        <div>
          <router-view></router-view>
        </div>

      </a-layout-content>
      <a-layout-footer :style="{ textAlign: 'center' }">
        <a-space :size="14">
        <a href="#">官网</a>
          <a href="https://github.com/small-flying-pigs/pigs">
            <GithubOutlined/>
          </a>
        <a href="#">文档</a>
        </a-space><br/>
        Copyright ©2020 By Small Flying Pigs.
      </a-layout-footer>



    </a-layout>
  </a-layout>
</template>
<script>
import {
  // VideoCameraOutlined,
  LogoutOutlined,
  UserOutlined,
  createFromIconfontCN,
  GithubOutlined,
} from '@ant-design/icons-vue';
import {defineComponent, ref} from 'vue';
import router from "./router";
import env from "@/store/env";



const IconFont = createFromIconfontCN({
  scriptUrl: '//at.alicdn.com/t/font_2828790_mybvy5yyuni.js',
});
export default defineComponent({
  setup() {
    return {
      selectedKeys: ref(['4']),
      userCenter(){
       alert('来了老弟')
      },
      Logout(){
        localStorage.removeItem('onLine')
        router.push('/user/login')

      },
      title: env.Title,
    };
  },

  components: {
    IconFont,
    LogoutOutlined,
    UserOutlined,
    GithubOutlined,
  },
});
</script>
<style scoped>
.layout .logo {
  height: 32px;
  line-height: 32px;
  /*background: rgba(255, 255, 255, 0.2);*/
  margin: 16px;
  text-align: center;
  letter-spacing: 8px;
  font-size: 12px;
  font-weight: bold;
  color: #fff;
}
.ant-row {
  display: flex;
  justify-content: space-between;
  padding: 0 120px;

}
</style>