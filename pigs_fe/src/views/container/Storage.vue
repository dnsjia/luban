<template>
  <div style="background-color: #FFFFFF">
    <a-tabs v-model:activeKey="data.storage" @change="callback">

      <a-tab-pane key="1" tab="存储声明">
        <PersistentVolumeClaim></PersistentVolumeClaim>
      </a-tab-pane>

      <a-tab-pane key="2" tab="存储卷" force-render>
        <PersistentVolume></PersistentVolume>
      </a-tab-pane>

      <a-tab-pane key="3" tab="存储类">
        <StorageClass></StorageClass>
      </a-tab-pane>

    </a-tabs>
  </div>
</template>

<script>
import {onMounted, reactive} from "vue";
import PersistentVolumeClaim from "./PersistentVolumeClaim";
import PersistentVolume from "./PersistentVolume";
import StorageClass from "./StorageClass";

export default {
  name: "Storage",
  setup() {

    const callback = val => {
      localStorage.setItem("storage", val)
    };
    const data = reactive({
      storage: 1,
    })

    const getStorageTable = () => {
      data.storage = localStorage.getItem("storage");
      if (data.storage === "" || data.storage === undefined) {
        data.storage = 1
      }
    }

    onMounted(getStorageTable)

    return {
      callback,
      data,
    }
  },
  components: {
    PersistentVolumeClaim,
    PersistentVolume,
    StorageClass,
  }
}
</script>

<style scoped>

</style>