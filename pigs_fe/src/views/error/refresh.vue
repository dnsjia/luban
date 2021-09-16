<template>
  <div class="refresh" v-if="!changeNetwork">
    <a-result status="warning" title="网络出现异常,请检查网络!">
      <p>(1). 本地防火墙、杀毒软件、浏览器插件的拦截、网络翻墙设置</p>
      <p>(2). 客户端网络是否正常</p>
      <p>(3). 浏览器长期未重启和清理缓存</p>
      <p>(4). 在等待结果返回前，让电脑处理休眠状态或电脑长期未重启</p>

      <template #extra>
        <a-button key="console" type="primary" @click="onRefresh()">点我刷新</a-button>
      </template>
    </a-result>

  </div>
</template>

<script>
import {mapState } from 'vuex';

export default {
name: "refresh.vue",
  data() {
    return {
    }
  },
  methods: {
    onRefresh(){
      this.$router.go(-1)//返回之前点击的页面
    },
  },
  computed:{
    ...mapState(['changeNetwork'])
  },
}
</script>

<style scoped>

</style>