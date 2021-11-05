<template>
  <div>
    <div class="table-viewer-header clearfix" style="clear: both">
      <span class="table-viewer-topbar-title">基本信息</span>
    </div>
    <p></p>
      <table class="table-default-viewer" v-if="state.nodeData.objectMeta">
        <tbody>
        <tr>
          <td style="width: 50%">
            <span>名称</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.objectMeta.name }}</span>
          </td>
          <td>
            <span>创建时间</span>
            <span class="margin-right">:</span>
            <span>{{ $filters.fmtTime(state.nodeData.objectMeta.creationTimestamp) }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>UID</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.uid }}</span>
          </td>
        </tr>
        <tr>
          <td>
                <span>
                  <span>容器组</span> CIDR
                </span>
            <span class="margin-right">:</span>
            <span> {{ state.nodeData.podCIDR }}</span>
          </td>
          <td>
            <span>调度状态：</span>
            <span v-if="state.nodeData.unschedulable==true">不可调度</span>
            <span v-else>可调度</span>
          </td>
        </tr>
        <tr>
          <td>
            <span>IP 地址</span>
            <span class="margin-right">:</span>
            <span>
              <a-space>
                  <span class="ng-scope" v-for="(ip_k, ip_v, ip_i) in state.nodeData.addresses" :key="ip_i">
                    {{ ip_k.type }}: {{ ip_k.address }}
                  </span>
              </a-space>
            </span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span>标签</span>
            <span class="margin-right">:</span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                      <a-tag v-for="(label_k, label_v, index) in state.nodeData.objectMeta.labels" style="background: #999999; color: white" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
                    </span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span>注释</span>
            <span class="margin-right">:</span>
            <span class="margin-right ng-scope" style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                  <a-tag v-for="(annotation_k, annotation_v, index) in state.nodeData.objectMeta.annotations" style="background: #999999; color: white" :key="index">{{ annotation_v }}: {{ annotation_k }}</a-tag>
                </span>
          </td>
        </tr>
        <tr>
          <td>
            <span>系统镜像</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.osImage }}</span>
          </td>
          <td>
            <span>内核版本</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.kernelVersion }}</span>
          </td>
        </tr>
        <tr>
          <td>
            <span>Kubelet 版本</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.kubeletVersion }}</span>
          </td>
          <td>
            <span>Kube-Proxy 版本</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.kubeProxyVersion }}</span>
          </td>
        </tr>
        <tr>
          <td>
            <span>机器 ID</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.machineID }}</span>
          </td>
          <td>
            <span>系统 UUID</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.systemUUID }}</span>
          </td>
        </tr>
        <tr>
          <td>
            <span>启动 ID</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.bootID }}</span>
          </td>
          <td>
            <span>容器运行时版本</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.containerRuntimeVersion }}</span>
          </td>
        </tr>
        <tr>
          <td>
            <span>操作系统</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.operatingSystem }}</span>
          </td>
          <td>
            <span>架构</span>
            <span class="margin-right">:</span>
            <span>{{ state.nodeData.nodeInfo.architecture}}</span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span>污点 （Taints）</span>
            <span class="margin-right">:</span>
            <a-tag v-for="(train, index) in state.nodeData.taints" style="background: #999999; color: white" :key="index">{{ train.key }}: {{ train.value }} Effect: {{ train.effect }}</a-tag>
          </td>
        </tr>
        </tbody>
      </table>

    <div class="table-viewer-header clearfix" style="clear: both">
      <span class="table-viewer-topbar-title">状态</span>
    </div>
    <p></p>
    <a-spin :spinning="state.loading" size="large">
      <a-table :columns="conditionsColumns" :data-source="state.conditionsData" :locale="{emptyText: '暂无数据'}">

        <template #lastProbeTime="{text}">
          <span>{{ $filters.fmtTime(text)}}</span>
        </template>

        <template #lastTransitionTime="{text}">
          <span>{{ $filters.fmtTime(text)}}</span>
        </template>

      </a-table>
    </a-spin>

    <div class="table-viewer-header clearfix" style="clear: both">
      <span class="table-viewer-topbar-title">容器组</span>
    </div>
    <p></p>
    <a-spin :spinning="state.loading" size="large">
      <a-table :columns="containerColumns" :data-source="state.containerData" :locale="{emptyText: '当前没有容器组被调度到此节点'}">
        <template #containerTitle="{text}">
          <a @click="podDetail(text)">{{text.metadata.name}}</a>
        </template>

        <template #containerStatus="{text}">
          <a-tooltip color="#ffffff" :overlayStyle="{'font-size': '12px', 'max-width': '400px'}">
            <template #title>
              <div v-for="(v, k, i) in text.status.conditions" :key="i">
                <span style="color: #666"> {{v.type}}: {{v.status}}</span>
              </div>
            </template>
            <a-tag color="#090" v-if="text.status.phase==='Running'">{{text.status.phase}}</a-tag>
            <a-tag color="#f50" v-else-if="text.status.phase==='Pending'">{{text.status.phase}}</a-tag>
            <a-tag color="red" v-else>{{text.status.phase}}</a-tag>
          </a-tooltip>
        </template>

        <template #containerStartTime="{text}">
          <span>{{ $filters.fmtTime(text)}}</span>
        </template>

        <template #containerAction="{text}">
          <a-space>
            <a @click="podDetail(text)">详情</a>
            <a>编辑</a>
            <a>终端</a>
            <a>日志</a>
            <a style="color:red;">删除</a>
          </a-space>
        </template>
      </a-table>
    </a-spin>

    <div class="table-viewer-header clearfix" style="clear: both">
      <span class="table-viewer-topbar-title">事件</span>
    </div>
    <p></p>
    <a-spin :spinning="state.loading" size="large">
      <a-table :columns="eventColumns" :data-source="state.eventData" :locale="{emptyText: '可能所有事件已过期'}">
        <template #lastTimestamp="{text}">
          <span>{{ $filters.fmtTime(text)}}</span>
        </template>
      </a-table>
    </a-spin>

  </div>
</template>

<script>
import {inject, onMounted, reactive,} from "vue";
import {useRoute} from "vue-router";
import {NodeDetail} from '../../api/k8s'
import {GetStorage} from "../../plugin/state/stroge"
import router from "../../router";
const containerColumns = [
  {
    title: '名称',
    slots: {customRender: 'containerTitle'},
  },
  {
    title: '状态',
    slots: {customRender: 'containerStatus'},
  },
  {
    title: '重启次数',
    dataIndex: 'status.containerStatuses[0].restartCount',
    slots: {customRender: 'containerRestartCount'},
  },
  {
    title: '容器 IP',
    dataIndex: 'status.podIP',
  },
  {
    title: '节点',
    dataIndex: 'status.hostIP',
  },
  {
    title: '创建时间',
    dataIndex: 'status.startTime',
    slots: {customRender: 'containerStartTime'},
  },
  {
    title: '操作',
    slots: {customRender: 'containerAction'},
  },
]
const eventColumns = [
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
    dataIndex: 'reason',
  },
  {
    title: '内容',
    dataIndex: 'message',
  },
  {
    title: '时间',
    dataIndex: 'lastTimestamp',
    slots: {customRender: 'lastTimestamp'},
  },
]
const conditionsColumns = [
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '状态',
    dataIndex: 'status',
  },
  {
    title: '最近心跳',
    dataIndex: 'lastProbeTime',
    slots: {customRender: 'lastProbeTime'},
  },
  {
    title: '最近更改',
    dataIndex: 'lastTransitionTime',
    slots: {customRender: 'lastTransitionTime'},
  },
  {
    title: '内容',
    dataIndex: 'reason',
  },
  {
    title: '信息',
    dataIndex: 'message',
  },
]

export default {
  name: "NodeDetail",
  setup() {
    let routers = useRoute()
    const state = reactive({
      nodeData: [],
      containerData: [],
      eventData: [],
      conditionsData: [],

      loading: true,

    });
    const message = inject('$message');
    const getNodeDetail = (params) => {
      NodeDetail(params).then(res => {
        if (res.errCode === 0){
          state.nodeData = res.data
          state.containerData = res.data.podList.items
          state.eventData = res.data.eventList.items
          state.conditionsData = res.data.conditions
          state.loading = false
        }else {
          message.error("获取节点信息异常")
        }

      })
    }
    const podDetail = (text) => {
      console.log(111,text)
      let cs = GetStorage()
      router.push({
        name: 'PodDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.metadata.namespace,
          name: text.metadata.name
        }
      });
    }

    onMounted(() => {
      getNodeDetail(routers.query)
    });

    return {
      state,
      containerColumns,
      eventColumns,
      conditionsColumns,
      podDetail,
    };
  }
}
</script>

<style scoped>
.table-viewer-header {
  margin-top: 10px;
  margin-bottom: -1px;
  height: 40px;
  background: #F5f6FA;
  line-height: 38px;
  border: 1px solid #e1e6eb;
  position: relative;
  border-left: 4px solid #6d7781;
}
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
.margin-right, .margin-right-1 {
  margin-right: 8px !important;
}
.resource-box-auto {
  border: 1px solid #ccd6e0;
  margin: 5px 0px 0px;
  min-height: 266px;
}
.text-explode {
  color: #CCC !important;
  font-weight: normal !important;
  margin: 0px 4px !important;
}

.pull-right {
  float: right !important;
}
.btn-xs {
  font-size: 12px;
  padding: 2px 8px;
  height: 20px;
  line-height: 14px;
}
.btn-link {
  color: #06C;
  text-shadow: none;
  border: none;
}
.btn {
  font-size: 12px;
  border-radius: 0px;
  padding: 8px 16px;
  height: 32px;
  line-height: 14px;
}
</style>