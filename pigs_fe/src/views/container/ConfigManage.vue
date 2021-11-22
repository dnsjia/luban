<template>
  <div style="background-color: #FFFFFF">
    <a-tabs v-model:activeKey="data.config" @change="callback">

      <a-tab-pane key="1" tab="配置项">
        <ConfigMap></ConfigMap>
      </a-tab-pane>

      <a-tab-pane key="2" tab="保密字典" force-render>
        <Secret></Secret>
      </a-tab-pane>


    </a-tabs>
  </div>
</template>

<script>
import {onMounted, reactive} from "vue";
import Secret from "./Secret";
import ConfigMap from "./ConfigMap";


export default {
  name: "ConfigManage",
  setup() {

    const callback = val => {
      localStorage.setItem("config", val)
    };
    const data = reactive({
      config: 1,
    })

    const getConfigTable = () => {
      data.config = localStorage.getItem("config");
      if (data.config === "" || data.config === undefined) {
        data.config = 1
      }
    }

    onMounted(getConfigTable)

    return {
      callback,
      data,
    }
  },
  components: {
    ConfigMap,
    Secret,
  }
}
</script>

<style scoped>

</style>