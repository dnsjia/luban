<template>

    <div>
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
<!--              <td colspan="2">-->
<!--                <span>选择器</span>-->
<!--                <span class="margin-right">: </span>-->
<!--                <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >-->
<!--                <a-tag v-for="(label_k, label_v, index) in deploymentData.spec.selector.match_labels" style="background: #999999; color: white" :key="index">{{ label_v }}: {{ label_k }}</a-tag>-->
<!--              </span>-->
<!--              </td>-->
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

              </a-table>
            </div>

<!--          &lt;!&ndash; 事件 &ndash;&gt;-->
<!--          <div class="console-sub-title custom-sub-title top-sub clearfix">-->
<!--            <div class="pull-left">-->
<!--              <h4>事件信息</h4>-->
<!--            </div>-->
<!--          </div>-->
<!--          <template>-->
<!--            <a-spin size="large" :spinning="eventsLoading" >-->
<!--              <a-table :columns="eventsColumns" :data-source="deploymentEventData.items" size="middle" :rowKey="(record,index)=>{return index}" :pagination="false">-->
<!--                &lt;!&ndash; 	更新时间 &ndash;&gt;-->
<!--                <span class="level-assess" slot="last_timestamp" slot-scope="text,record">-->
<!--              <p>{{record.last_timestamp|fmtTime}}</p>-->
<!--            </span>-->
<!--              </a-table>-->
<!--            </a-spin>-->
<!--          </template>-->

<!--          <div class="console-sub-title custom-sub-title top-sub clearfix">-->
<!--            <div class="pull-left">-->
<!--              <h4>历史版本</h4>-->
<!--            </div>-->
<!--          </div>-->
<!--          <template>-->
<!--            <div>-->
<!--              <a-spin size="large" :spinning="historyLoading" >-->
<!--                <a-table :columns="historyColumns" :data-source="historyData" size="middle" :rowKey="(record,index)=>{return index}" :pagination="false">-->
<!--                  &lt;!&ndash; 	更新时间 &ndash;&gt;-->
<!--                  <span class="level-assess" slot="create_time" slot-scope="text,record">-->
<!--              <p>{{record.create_time|fmtTime}}</p>-->
<!--            </span>-->
<!--                  <span class="level-assess" slot="action" slot-scope="text,record">-->
<!--              <p>-->
<!--                <a @click="rolloutDeployment(record)">回滚到该版本</a>-->
<!--              </p>-->
<!--            </span>-->
<!--                </a-table>-->
<!--              </a-spin>-->
<!--            </div>-->
<!--          </template>-->
<!--        </template>-->
      </a-page-header>
    </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {DeploymentDetail} from "../../api/k8s";
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
    // dataIndex: 'lastProbeTime',
    slots: {customRender: 'lastProbeTime'},
  },
  {
    title: '原因',
    dataIndex: 'reason',
    // slots: {customRender: 'reason'},
  },
  {
    title: '消息',
    dataIndex: 'message',
    // slots: {customRender: 'message'},
  },
]
const historyColumns = [
  {
    title: '版本',
    dataIndex: 'version',
  },
  {
    title: '镜像',
    dataIndex: 'images',
  },
  {
    title: '创建时间',
    dataIndex: 'create_time',
    scopedSlots: { customRender: 'create_time' }
  },
  {
    title: '操作',
    dataIndex: 'action',
    scopedSlots: { customRender: 'action' }
  },
]
const eventsColumns = [
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '对象',
    dataIndex: 'involved_object.kind',
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
    dataIndex: 'last_timestamp',
    scopedSlots: { customRender: 'last_timestamp' }
  },
]
export default {
  name: "DeploymentDetail",
  setup(){
    const message = inject('$message');
    const data = reactive({
      DetailData: [],
    })
    let router = useRoute()
    const GetStorage = () => {
      const cs = JSON.parse(localStorage.getItem("cluster"))
      if (cs !== null && cs !== undefined && cs !== "") {
        cluster.clusterId = cs.clusterId
        cluster.clusterName = cs.clusterName
        return cluster
      }
    }
    const cluster = reactive({
      clusterId: "",
      clusterName: ""
    })
    const getDetail = (params) => {
      console.log("param", router.query)
      DeploymentDetail(params).then(res => {
        if (res.errCode === 0){
          data.DetailData = res.data
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