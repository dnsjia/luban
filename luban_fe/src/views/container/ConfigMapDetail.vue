<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.configMapData.objectMeta.name" @back="() => $router.go(-1)"
                   v-if="data.configMapData.objectMeta">
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>基本信息</h4>
        </div>
      </div>
      <table class="table-default-viewer">
        <tbody>
        <tr>
          <td style="width: 50%">
            <span>名称</span>
            <span class="margin-right">: </span>
            <span>{{ data.configMapData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">: </span>
            <span>{{ data.configMapData.objectMeta.namespace }}</span>
          </td>
        </tr>

        <tr>
          <td style="width: 50%">
            <span>创建时间</span>
            <span class="margin-right">: </span>
            <span>{{ $filters.fmtTime(data.configMapData.objectMeta.creationTimestamp) }}</span>
          </td>
          <td colspan="2">
            <span>标签</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
              <a-tag v-for="(label_k, label_v, index) in data.configMapData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
            </span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span>注解</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
              <a-html v-for="(label_k, label_v, index) in data.configMapData.objectMeta.annotations" :key="index">{{ label_v }}: {{ label_k }}</a-html>
            </span>
          </td>

        </tr>
        </tbody>
      </table>
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>配置数据</h4>
        </div>
      </div>
      <table class="table-default-viewer">
        <tbody>
        <th>
          <div>键</div>
        </th>
        <th>
          <div>值</div>
        </th>
          <template v-for="(map_v, map_k, i) in data.configMapData.data" :key="i">
        <tr>

            <td style="width: 50%">
              <div>{{map_k}}</div>
            </td>
            <td colspan="2">
              <div style="white-space: pre-wrap;">{{map_v}}</div>
            </td>
        </tr>
          </template>
        </tbody>
      </table>
      <br/>
    </a-page-header>
  </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {GetStorage} from "../../plugin/state/stroge";
import {ConfigMapDetail} from "../../api/k8s";

export default {
  name: "ConfigMapDetail",
  setup() {
  const data = reactive({
    configMapData: [],
  })
  const message = inject('$message');
  let router = useRoute()
  const detail = (params) => {
    let cs = GetStorage()
    ConfigMapDetail(cs.clusterId, params).then(res => {
      if (res.errCode === 0){
        data.configMapData = res.data
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
.table-viewer-header .table-viewer-topbar-title {
  font-size: 14px;
  color: #333333;
  display: inline-block;
  margin-left: 16px;
}
.table-default-viewer {
  width: 100%;
  background-color: #FFF;
}
.table-default-viewer td {
  padding: 11px 20px;
  border: 1px solid #eeeeee;
}

.console-sub-title.custom-sub-title {
  border: 0;
  background: none;
  /*border-top: 1px solid #ccc;*/
  margin-top: 10px;
  padding-top: 10px;
  padding-bottom: 10px;
}
</style>