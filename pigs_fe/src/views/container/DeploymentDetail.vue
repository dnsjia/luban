<template>
    <div style="background-color: #FFFFFF">
      <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.DetailData.objectMeta.name" @back="() => $router.go(-1)" v-if="data.DetailData.objectMeta">
<!--        <template>-->
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
                <span>{{ data.DetailData.objectMeta.name }}</span>
              </td>
              <td>
                <span>命名空间</span>
                <span class="margin-right">: </span>
                <span>{{ data.DetailData.objectMeta.namespace }}</span>
              </td>
            </tr>
            <tr>
              <td style="width: 50%">
                <span>状态</span>
                <span class="margin-right">: </span>
                <span>
                  就绪：{{ data.DetailData.statusInfo.available }}/{{ data.DetailData.statusInfo.replicas }}个，
                  已更新：{{ data.DetailData.statusInfo.updated }}个，可用：{{ data.DetailData.statusInfo.available }}个，
                  不可用：{{ data.DetailData.statusInfo.unavailable }}个
                </span>
              </td>
              <td>
                <span>创建时间</span>
                <span class="margin-right">: </span>
                <span> {{ $filters.fmtTime(data.DetailData.objectMeta.creationTimestamp) }}</span>
              </td>
            </tr>
            <tr>
              <td style="width: 50%">
                <span>策略</span>
                <span class="margin-right">: </span>
                <span>{{ data.DetailData.strategy }}</span>
              </td>
              <td colspan="2">
                <span>选择器</span>
                <span class="margin-right">: </span>
                <span style="font-size: 12px; display: inline-block;  margin-bottom: 5px;" >
                <a-tag v-for="(label_k, label_v, index) in data.DetailData.selector" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
              </span>
              </td>
            </tr>

            <tr>
              <td style="width: 50%">
                <span>滚动升级策略</span>
                <span class="margin-right">: </span>
                <div v-if="data.DetailData.rollingUpdateStrategy">
                  <span>超过期望的Pod数量: {{ data.DetailData.rollingUpdateStrategy.maxSurge }}</span>
                  <span style="padding-left: 30px">不可用Pod最大数量: {{ data.DetailData.rollingUpdateStrategy.maxUnavailable }}</span>
                </div>
              </td>
              <td>
                <span>注解</span>
                <span class="margin-right">: </span>
                <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                <span v-for="(k, v, i) in data.DetailData.objectMeta.annotations" :key="i">
                  <a-tag v-if="v !== 'kubectl.kubernetes.io/last-applied-configuration'" :key="i">
                    {{ v }}: {{ k }}
                  </a-tag>
                </span>
              </span>
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <span>标签</span>
                <span class="margin-right">: </span>
                <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                    <a-tag v-for="(label_k, label_v, index) in data.DetailData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
                  </span>
              </td>
            </tr>
            </tbody>
          </table>
          <!-- 状态 -->
          <div class="console-sub-title custom-sub-title top-sub clearfix">
            <div class="pull-left">
              <h4>现状详情</h4>
            </div>
          </div>
          <div id="components-table-demo-size">

            <a-table
                :columns="deploymentStatusConditionsColumns"
                :data-source="data.DetailData.conditions"
                :pagination="false"
                :rowKey="item=>JSON.stringify(item)"
                :locale="{emptyText: '暂无数据'}"
            >
              <!-- 	更新时间 -->
              <template #lastProbeTime="{text}">
                {{ $filters.fmtTime(text.lastProbeTime) }}
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
                :data-source="data.deploymentEventData"
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
          <a-tabs v-model:activeKey="data.workload" @change="callback">

            <a-tab-pane key="1" tab="容器组">
              功能开发中
            </a-tab-pane>

            <a-tab-pane key="2" tab="访问方式" force-render>
              功能开发中
            </a-tab-pane>

            <a-tab-pane key="3" tab="历史版本" force-render>
              <a-table :columns="historyColumns" :data-source="data.historyData" size="middle" :rowKey="(record,index)=>{return index}" :pagination="false">
                <!-- 	更新时间 -->
                <template #create_time="{text}">
                  <span class="level-assess">
                     <span> {{ $filters.fmtTime(text.create_time) }}</span>
                  </span>
                </template>

                <template #action="{text}">
                  <a-popconfirm placement="left" ok-text="确定" cancel-text="取消" @confirm="rolloutDeployment(text)">
                    <template #title>
                      <span>你确定要回退应用版本吗？</span><br/>
                      <span>版本号： {{ text.version }} </span>
                    </template>
                    <a>回滚到该版本</a>
                  </a-popconfirm>

                </template>

              </a-table>
            </a-tab-pane>
          </a-tabs>
          <br/>
      </a-page-header>
    </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {DeploymentDetail, DeploymentRollBack} from "../../api/k8s";
import {GetStorage} from "../../plugin/state/stroge";

const deploymentStatusConditionsColumns = [
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '状态',
    dataIndex: 'status',
  },
  {
    title: '更新时间',
    slots: {customRender: 'lastProbeTime'},
  },
  {
    title: '原因',
    dataIndex: 'reason',
  },
  {
    title: '消息',
    dataIndex: 'message',
  },
]
const historyColumns = [
  {
    title: '版本',
    dataIndex: 'version',
  },
  {
    title: '镜像',
    dataIndex: 'image',
  },
  {
    title: '创建时间',
    slots: {customRender: 'create_time'},
  },
  {
    title: '操作',
    slots: {customRender: 'action'},
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
  name: "DeploymentDetail",
  setup(){
    const message = inject('$message');
    const data = reactive({
      DetailData: [],
      deploymentEventData: [],
      historyData: [],
    })

    let router = useRoute()

    const getDetail = (params) => {
      DeploymentDetail(params).then(res => {
        if (res.errCode === 0){
          data.DetailData = res.data
          data.deploymentEventData = res.data.events.items
          data.historyData = res.data.historyVersion
        }else {
          message.error(res.errMsg)
        }
      })
    }

    const rolloutDeployment = (params) => {
      let cs = GetStorage()
      DeploymentRollBack(cs.clusterId, {"namespace": params.namespace, "deploymentName": params.name, "reVersion": params.version}).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          getDetail(router.query)
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
      deploymentStatusConditionsColumns,
      historyColumns,
      eventsColumns,
      rolloutDeployment,
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