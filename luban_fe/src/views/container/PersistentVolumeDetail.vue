<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.pvData.objectMeta.name" @back="() => $router.go(-1)"
                   v-if="data.pvData.objectMeta">

      <a-tabs v-model:activeKey="activeKey">
        <a-tab-pane key="1" tab="基本信息">
          <a-card>
            <div>
              <a-descriptions title="元数据" :column="2">
                <a-descriptions-item label="名称">{{ data.pvData.objectMeta.name }}</a-descriptions-item>
                <a-descriptions-item label="创建时间">{{ $filters.fmtTime(data.pvData.objectMeta.creationTimestamp) }}</a-descriptions-item>
                <a-descriptions-item label="标签">
                  <template v-for="(v,k,i) in data.pvData.objectMeta.labels" :key="i">
                    <a-tag color="cyan">{{ k }}: {{ v }}</a-tag> <br/>
                  </template>
                </a-descriptions-item>
                <a-descriptions-item label="注解">
                  <template v-for="(v,k,i) in data.pvData.objectMeta.annotations" :key="i">
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
                <a-descriptions-item label="状态">{{ data.pvData.status }}</a-descriptions-item>
                <a-descriptions-item label="总量">{{ data.pvData.capacity.storage }}</a-descriptions-item>
                <a-descriptions-item label="访问模式">{{ data.pvData.accessModes[0] }}</a-descriptions-item>
                <a-descriptions-item label="回收策略">{{ data.pvData.reclaimPolicy }}</a-descriptions-item>
                <a-descriptions-item label="存储类型">{{ data.pvData.storageClass }}</a-descriptions-item>
                <a-descriptions-item label="关联存储声明">
                  <template v-if="data.pvData.claim===''||data.pvData.claim===null">
                    暂无绑定的存储声明
                  </template>
                  <template v-else>
                    <a @click="pvcDetail(data.pvData.claim)">{{ data.pvData.claim.split("/")[1] }}</a>
                  </template>
                </a-descriptions-item>
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
import {PVDetail} from "../../api/k8s";
import routers from "../../router";
export default {
  name: "PersistentVolumeDetail",
  setup() {
    const data = reactive({
      pvData: [],
    })
    const message = inject('$message');
    let router = useRoute()
    const detail = (params) => {
      let cs = GetStorage()
      PVDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.pvData = res.data
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const pvcDetail = (claim) => {
      let cs = GetStorage()
      if (claim===''||claim===null){
        return
      }
      let namespace = claim.split("/")[0]
      let name = claim.split("/")[1]
      routers.push({
        name: 'PVCDetail', query: {
          clusterId: cs.clusterId,
          namespace: namespace,
          name: name
        }
      });
    }

    onMounted(() => {
      detail(router.query);
    });
    return {
      data,
      detail,
      pvcDetail,
    }
  }
}
</script>

<style scoped>

</style>