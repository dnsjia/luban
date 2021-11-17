<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.pvcData.objectMeta.name" @back="() => $router.go(-1)"
                   v-if="data.pvcData.objectMeta">

      <a-tabs v-model:activeKey="activeKey">
        <a-tab-pane key="1" tab="基本信息">
          <a-card>
            <div>
              <a-descriptions title="元数据" :column="2">
                <a-descriptions-item label="命名空间">{{ data.pvcData.objectMeta.namespace }}</a-descriptions-item>
                <a-descriptions-item label="创建时间">{{ $filters.fmtTime(data.pvcData.objectMeta.creationTimestamp) }}</a-descriptions-item>
                <a-descriptions-item label="标签">
                  <template v-for="(v,k,i) in data.pvcData.objectMeta.labels" :key="i">
                    <a-tag color="cyan">{{ k }}: {{ v }}</a-tag> <br/>
                  </template>
                </a-descriptions-item>
                <a-descriptions-item label="注解">
                  <template v-for="(v,k,i) in data.pvcData.objectMeta.annotations" :key="i">
                    <template v-if="k!=='kubectl.kubernetes.io/last-applied-configuration'">
                      {{ k }}: {{ v }} <br/>
                    </template>

                  </template>
                </a-descriptions-item>
              </a-descriptions>
            </div>
          </a-card>
          <br/>
          <a-card>
            <div>
              <a-descriptions title="资源信息" :column="2">
                <a-descriptions-item label="状态">{{ data.pvcData.status }}</a-descriptions-item>
                <a-descriptions-item label="存储类型">{{ data.pvcData.objectMeta.annotations['volume.beta.kubernetes.io/storage-class'] }}</a-descriptions-item>
                <a-descriptions-item label="总量">{{ data.pvcData.capacity.storage }}</a-descriptions-item>
                <a-descriptions-item label="访问模式">{{ data.pvcData.accessModes[0] }}</a-descriptions-item>
                <a-descriptions-item label="关联存储卷">{{ data.pvcData.volume }}</a-descriptions-item>
              </a-descriptions>
            </div>
          </a-card>

        </a-tab-pane>
      </a-tabs>
    </a-page-header>
  </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {GetStorage} from "../../plugin/state/stroge";
import {PVCDetail} from "../../api/k8s";

export default {
  name: "PersistentVolumeClaimDetail",
  setup() {
    const data = reactive({
      pvcData: [],
    })
    const message = inject('$message');
    let router = useRoute()
    const detail = (params) => {
      let cs = GetStorage()
      PVCDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.pvcData = res.data
        }else {
          message.error(res.errMsg)
        }
      })
    }
    onMounted(() => {
      detail(router.query);
    });
    return {
      data,
      detail,
    }
  }
}
</script>

<style scoped>

</style>