<template>
  <a-layout class="layout">
    <a-layout-sider :style="{ overflow: 'auto', height: '100vh', position: 'fixed', left: 0 }">
      <div class="logo" />
      <a-menu theme="dark" mode="inline" v-model:selectedKeys="selectedKeys">
        <a-menu-item key="1">
          <icon-font type="icon-twitter" />
          <span class="nav-text">仪表盘</span>
        </a-menu-item>
        <a-menu-item key="2">
          <video-camera-outlined />
          <span class="nav-text">nav 2</span>
        </a-menu-item>
        <a-menu-item key="3">
          <upload-outlined />
          <span class="nav-text">nav 3</span>
        </a-menu-item>
        <a-menu-item key="4">
          <bar-chart-outlined />
          <span class="nav-text">nav 4</span>
        </a-menu-item>
        <a-menu-item key="5">
          <cloud-outlined />
          <span class="nav-text">nav 5</span>
        </a-menu-item>
        <a-menu-item key="6">
          <appstore-outlined />
          <span class="nav-text">nav 6</span>
        </a-menu-item>
        <a-menu-item key="7">
          <team-outlined />
          <span class="nav-text">nav 7</span>
        </a-menu-item>
        <a-menu-item key="8">
          <shop-outlined />
          <span class="nav-text">nav 8</span>
        </a-menu-item>
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

      <a-layout-content :style="{ margin: '24px 16px 0', overflow: 'initial' }">
        <div :style="{ padding: '24px', background: '#fff', textAlign: 'center' }">

          ...
          <br />
          Really
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          long
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          ...
          <br />
          content
        </div>
      </a-layout-content>
      <a-layout-footer :style="{ textAlign: 'center' }">
        <a href="">官网</a>
        <GithubOutlined />
        <a href="">文档</a><br/>
        Ant Design ©2018 Created by Ant UED
      </a-layout-footer>
    </a-layout>
  </a-layout>
</template>
<script>
import {
  VideoCameraOutlined,
  UploadOutlined,
  BarChartOutlined,
  CloudOutlined,
  AppstoreOutlined,
  TeamOutlined,
  ShopOutlined,
  LogoutOutlined,
  UserOutlined,
  createFromIconfontCN,
  GithubOutlined,


} from '@ant-design/icons-vue';
import { defineComponent, ref } from 'vue';



const IconFont = createFromIconfontCN({
  scriptUrl: '//at.alicdn.com/t/font_8d5l8fzk5b87iudi.js',
});
export default defineComponent({
  setup() {
    return {
      selectedKeys: ref(['4']),
      userCenter(){
       alert('来了老弟')
      },
      Logout(){
        alert('退出')
      }
    };
  },

  components: {
    VideoCameraOutlined,
    UploadOutlined,
    BarChartOutlined,
    CloudOutlined,
    AppstoreOutlined,
    TeamOutlined,
    ShopOutlined,
    IconFont,
    LogoutOutlined,
    UserOutlined,
    GithubOutlined,
  },
});
</script>
<style>
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