<template>
  <div class="page-container">
    <a-result status="403" title="403" sub-title="Sorry, you are not authorized to access this page.">
      <template #extra>
        <router-link to="/" class="ant-btn ant-btn-primary">回到首页</router-link>
      </template>
    </a-result>
  </div>
</template>

<script>
import {defineComponent} from 'vue'
export default defineComponent({
name: "403"
})
</script>

<style scoped>
</style>