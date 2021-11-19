<template>
  <div style="background-color: #FFFFFF">
    <a-tabs v-model:activeKey="data.network" @change="callback">

      <a-tab-pane key="1" tab="服务">
        <Service></Service>
      </a-tab-pane>

      <a-tab-pane key="2" tab="路由" force-render>
        <Ingress></Ingress>
      </a-tab-pane>


    </a-tabs>
  </div>
</template>

<script>
import {onMounted, reactive} from "vue";
import Service from "./Service";
import Ingress from "./Ingress";

export default {
  name: "NetWork",
  setup() {

    const callback = val => {
      localStorage.setItem("network", val)
    };
    const data = reactive({
      network: 1,
    })

    const getStorageTable = () => {
      data.network = localStorage.getItem("network");
      if (data.network === "" || data.network === undefined) {
        data.network = 1
      }
    }

    onMounted(getStorageTable)

    return {
      callback,
      data,
    }
  },
  components: {
    Service,
    Ingress,
  }
}
</script>

<style scoped>

</style>