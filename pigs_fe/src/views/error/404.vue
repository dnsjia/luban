<template>
  <div class="page-container">
    <a-result status="404" title="404" sub-title="Sorry, the page you visited does not exist.">
      <template #extra>
        <router-link to="/" class="ant-btn ant-btn-primary">回到首页</router-link>
      </template>
    </a-result>
  </div>
</template>

<script>
import { defineComponent } from 'vue'
export default defineComponent({
  name: "404",
})
</script>

<style scoped>
.page-container {
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: white;
}
</style>