<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.serviceData.objectMeta.name" @back="() => $router.go(-1)" v-if="data.serviceData.objectMeta">
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
            <span>{{ data.serviceData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">: </span>
            <span>{{ data.serviceData.objectMeta.namespace }}</span>
          </td>
        </tr>

        <tr>
          <td style="width: 50%">
            <span>类型</span>
            <span class="margin-right">: </span>
            <span>{{ data.serviceData.type }}</span>
          </td>

          <td>
            <span>创建时间</span>
            <span class="margin-right">: </span>
            <span> {{ $filters.fmtTime(data.serviceData.objectMeta.creationTimestamp) }}</span>
          </td>
        </tr>

        <tr>
          <td style="width: 50%">
            <span>内部端点</span>
            <span class="margin-right">: </span>
            <a-space>
              <template v-if="data.serviceData.internalEndpoint.length <= 0 ||data.serviceData.internalEndpoint===null && data.serviceData.internalEndpoint===undefined">
                <span>-</span>
              </template>
              <template v-else>
              <span v-for="(v, k, i) in data.serviceData.internalEndpoint.ports" :key="i">
                {{ data.serviceData.internalEndpoint.host }}: {{ v.port }} {{ v.protocol }}
              </span>
              </template>
            </a-space>
          </td>

          <td>
            <span>外部端点</span>
            <span class="margin-right">: </span>
            <a-space>
              <template v-if="data.serviceData.externalEndpoints.length <= 0 ||data.serviceData.externalEndpoints===null && data.serviceData.externalEndpoints===undefined">
                <span>-</span>
              </template>
              <template v-else>
              <span v-for="(v, k, i) in data.serviceData.externalEndpoints.ports" :key="i">
                {{ data.serviceData.externalEndpoints.host }}: {{ v.port }} {{ v.protocol }}
              </span>
              </template>
            </a-space>
          </td>
        </tr>

        <tr>

          <td style="width: 50%">
            <span>集群IP</span>
            <span class="margin-right">: </span>
            <span>{{ data.serviceData.clusterIP }}</span>
          </td>

          <td colspan="2">
            <span>标签</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
              <a-tag v-for="(label_k, label_v, index) in data.serviceData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
            </span>
          </td>
        </tr>
        </tbody>
      </table>
      <!-- 状态 -->
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>端点</h4>
        </div>
      </div>
      <div id="components-table-demo-size">

        <a-table
            :columns="endpointsColumns"
            :data-source="data.serviceData.endpointList.endpoints"
            :pagination="false"
            :rowKey="item=>JSON.stringify(item)"
            :locale="{emptyText: '此服务目前未指定端点'}"
        >
          <template #ports="{text}">
            <template v-if="text.ports.length <= 0 ||text.ports===null && text.ports===undefined">
              <span>-</span>
            </template>
            <template v-else>
              <span v-for="(v, k, i) in text.ports" :key="i">
                {{ v.name }}: {{ v.port }} {{ v.protocol }}
              </span>
            </template>
          </template>

          <template #ready="{text}">
            {{ text.ready }}
          </template>

          <template #container="{text}" v-if="data.serviceData.podList.pods.length>0">
            <template v-for="(k, i) in data.serviceData.podList.pods" :key="i">
              <!-- 根据endpoint的容器ip 展现容器名称 -->
              <div v-if="k.podIP===text.host">
                <a @click="podDetail(k.objectMeta)">{{ k.objectMeta.name }}</a>
              </div>
            </template>
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
import {ServiceDetail} from "../../api/k8s";
import {GetStorage} from "../../plugin/state/stroge";
import routers from "../../router";

const endpointsColumns = [
  {
    title: '主机',
    dataIndex: 'host',
  },
  {
    title: '端口 (名称、端口、协议)',
    slots: {customRender: 'ports'},
  },
  {
    title: '节点',
    dataIndex: 'nodeName',
  },
  {
    title: '目标容器组',
    slots: {customRender: 'container'},
  },
  {
    title: '就绪',
    slots: {customRender: 'ready'},
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
  name: "ServiceDetail",
  setup(){
    const message = inject('$message');
    const data = reactive({
      serviceData: [],
      eventData: [],
    })

    let router = useRoute()

    const getDetail = (params) => {
      let cs = GetStorage()
      ServiceDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.serviceData = res.data
          data.eventData = res.data.eventList.events
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const podDetail = (text) => {
      let cs = GetStorage()
      routers.push({
        name: 'PodDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.namespace,
          name: text.name
        }
      });
    }

    onMounted(() => {
      getDetail(router.query);
    });

    return {
      data,
      getDetail,
      GetStorage,
      endpointsColumns,
      eventsColumns,
      podDetail,
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