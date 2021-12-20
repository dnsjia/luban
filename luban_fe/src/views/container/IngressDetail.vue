<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.ingressData.objectMeta.name" @back="() => $router.go(-1)" v-if="data.ingressData.objectMeta">
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
            <span>{{ data.ingressData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">: </span>
            <span>{{ data.ingressData.objectMeta.namespace }}</span>
          </td>
        </tr>

        <tr>
          <td style="width: 50%">
            <span>端点</span>
            <span class="margin-right">: </span>
            <span>{{ data.ingressData.type }}</span>
          </td>

          <td>
            <span>创建时间</span>
            <span class="margin-right">: </span>
            <span> {{ $filters.fmtTime(data.ingressData.objectMeta.creationTimestamp) }}</span>
          </td>
        </tr>

        <tr>

          <td style="width: 50%">
            <span>注解</span>
            <span class="margin-right">: </span>
            <span v-for="(k, v, i) in data.ingressData.objectMeta.annotations" :key="i">
              <a-tag v-if="v !== 'kubectl.kubernetes.io/last-applied-configuration'" :key="i">
                {{ v }}: {{ k }}
              </a-tag>
            </span>
          </td>

          <td colspan="2">
            <span>标签</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
              <a-tag v-for="(label_k, label_v, index) in data.ingressData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
            </span>
          </td>
        </tr>
        </tbody>
      </table>
      <!-- 状态 -->
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>规则</h4>
        </div>
      </div>
      <div id="components-table-demo-size">

        <a-table
            :columns="ruleColumns"
            :data-source="data.ingressData.spec.rules"
            :pagination="false"
            :rowKey="item=>JSON.stringify(item)"
            :locale="{emptyText: '此服务目前未指定端点'}"
        >
          <template #path="{text}">
            <div v-if="text.http.paths.length>0 && text.http.paths!==undefined">
              <div v-for="(rule, k, i) in text.http.paths" :key="i">
                {{ rule.path }}
              </div>
            </div>
          </template>

          <template #serviceName="{text}">
            <div v-if="text.http.paths.length>0 && text.http.paths!==undefined">
              <div v-for="(rule, k, i) in text.http.paths" :key="i">
                {{ rule.backend.serviceName}}
              </div>
            </div>
          </template>

          <template #servicePort="{text}">
            <div v-if="text.http.paths.length>0 && text.http.paths!==undefined">
              <div v-for="(rule, k, i) in text.http.paths" :key="i">
                {{ rule.backend.servicePort}}
              </div>
            </div>
          </template>

        </a-table>
      </div>

      <!-- 事件 -->
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>事件信息</h4>
        </div>
      </div>
      <a-table
          :columns="eventsColumns"
          :data-source="data.eventData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '可能所有事件已过期'}"
          size="middle"
      >
        <!-- 	更新时间 -->
        <template #lastTimestamp="{text}">
          <span class="level-assess">
            <span> {{ $filters.fmtTime(text.lastTimestamp) }}</span>
          </span>
        </template>

      </a-table>

      <br/>
    </a-page-header>
  </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {GetStorage} from "../../plugin/state/stroge";
import {IngressDetail} from "../../api/k8s";
import routers from "../../router";

const ruleColumns = [
  {
    title: '域名',
    dataIndex: 'host',
  },
  {
    title: '路径',
    slots: {customRender: 'path'},
  },
  {
    title: '服务名称',
    slots: {customRender: 'serviceName'},
  },
  {
    title: '服务端口',
    slots: {customRender: 'servicePort'},
  },
]
const eventsColumns = [
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '对象',
    dataIndex: 'involvedObject.kind',
  },
  {
    title: '信息',
    dataIndex: 'message',
  },
  {
    title: '原因',
    dataIndex: 'reason',
  },
  {
    title: '时间',
    slots: {customRender: 'lastTimestamp'},
  },
]
export default {
  name: "IngressDetail",
  setup(){
    const message = inject('$message');
    const data = reactive({
      ingressData: [],
      eventData: [],
    })

    let router = useRoute()

    const getDetail = (params) => {
      let cs = GetStorage()
      IngressDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.ingressData = res.data
          data.eventData = res.data.eventList.events
        }else {
          message.error(res.errMsg)
        }
      })
    }

    onMounted(() => {
      getDetail(router.query);
    });

    return {
      data,
      getDetail,
      GetStorage,
      ruleColumns,
      eventsColumns,
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