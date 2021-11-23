<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.jobData.objectMeta.name" @back="() => $router.go(-1)" v-if="data.jobData.objectMeta">
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
            <span>{{ data.jobData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">: </span>
            <span>{{ data.jobData.objectMeta.namespace }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>状态</span>
            <span class="margin-right">: </span>
            <span>活跃{{ data.jobData.podStatus.active }}, 成功{{ data.jobData.podStatus.succeeded }}, 失败{{ data.jobData.podStatus.failed }}</span>
          </td>
          <td>
            <span>创建时间</span>
            <span class="margin-right">: </span>
            <span> {{ $filters.fmtTime(data.jobData.objectMeta.creationTimestamp) }}</span>
          </td>
        </tr>

        <tr>
          <td>
            <span>注解</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                <span v-for="(k, v, i) in data.jobData.objectMeta.annotations" :key="i">
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
                    <a-tag v-for="(label_k, label_v, index) in data.jobData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
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
            :columns="statusConditionsColumns"
            :data-source="data.jobData.status"
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
      <a-tabs v-model:activeKey="data.workload" @change="callback">

        <a-tab-pane key="1" tab="容器组">
          <a-table
              :columns="jobPodColumns"
              :data-source="data.jobPodData"
              :pagination="false"
              :rowKey="item=>JSON.stringify(item)"
              :locale="{emptyText: '暂无数据'}"
          >
            <template #name="{text}">
              <div>
                <img style="width:14px;margin-right:2px" src="//g.alicdn.com/aliyun/cos/1.38.27/images/icon_docker.png">
                <a @click="detailPod(text)">{{text.objectMeta.name}}</a>
              </div>
            </template>
            <template #podStatus="{text}">
              <span>
                <a-tag color="#090" v-if="text.status==='Running'">Running</a-tag>
                <a-tag color="default" v-else-if="text.status==='Completed'">Completed</a-tag>
                <a-tag color="red" v-else>{{text.status}}</a-tag>
              </span>
            </template>

            <template #nodeName="{text}">
              <a @click="nodeDetail(text.nodeName)">{{text.nodeName}}</a>
            </template>

            <template #creationTimestamp="{text}">
              <span>
               {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
              </span>
            </template>

            <template #action="{text}">
              <a-divider type="vertical"/>
              <a @click="detailPod(text)">详情</a>
              <a-divider type="vertical"/>
              <a>终端</a>
              <a-divider type="vertical"/>
              <a>日志</a>
              <a-divider type="vertical"/>
              <a-dropdown :trigger="['click']">
                <a class="ant-dropdown-link" @click.prevent>
                  更多
                  <DownOutlined/>
                </a>
                <template #overlay>
                  <a-menu>
                    <a-menu-item><span @click="editDeployment(text)">编辑容器</span></a-menu-item>
                    <a-menu-item><span @click="removeOnePod(text)" style="color: red">删除容器</span></a-menu-item>
                  </a-menu>
                </template>
              </a-dropdown>
            </template>
          </a-table>
        </a-tab-pane>
      </a-tabs>
      <br/>
    </a-page-header>

    <template>
      <div>
        <a-modal v-model:visible="data.removeOnePodVisible" title="容器 (Container) "
                 @ok="removeOnPodOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除 {{ data.removeOnePodData.objectMeta.name }} 容器？</p>
          </a-space>
        </a-modal>
      </div>
    </template>

  </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {GetStorage} from "../../plugin/state/stroge";
import {DeletePod, JobDetail} from "../../api/k8s";
import routers from "../../router";

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
const statusConditionsColumns = [
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
const jobPodColumns = [
  {
    title: '名称',
    slots: {customRender: 'name'},
  },
  {
    title: '状态',
    slots: {customRender: 'podStatus'},
  },
  {
    title: '重启次数',
    dataIndex: 'restartCount',
  },
  {
    title: 'Pod IP',
    dataIndex: 'podIP',
  },
  {
    title: '调度节点',
    slots: {customRender: 'nodeName'},
  },
  {
    title: '创建时间',
    slots: {customRender: 'creationTimestamp'},
  },
  {
    title: '操作',
    slots: {customRender: 'action'},
  },
]
export default {
  name: "JobDetail",
  setup() {
    const data = reactive({
      jobData: [],
      eventData: [],
      jobPodData: [],
      removeOnePodData: [],
      removeOnePodVisible: false,
    })
    const message = inject('$message');
    let router = useRoute()
    const detail = (params) => {
      let cs = GetStorage()
      JobDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.jobData = res.data
          data.jobPodData = res.data.podList.pods
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const nodeDetail = (name) => {
      let cs = GetStorage()
      let routeData = routers.resolve({ name: 'NodeDetail', query: {name: name, clusterId: cs.clusterId} });
      window.open(routeData.href, '_blank');
    };
    const removeOnePod = (text) => {
      data.removeOnePodData = text
      data.removeOnePodVisible = true
    }
    const removeOnPodOnSubmit = () => {
      let cs = GetStorage()
      let delParams = {
        "name": data.removeOnePodData.objectMeta.name,
        "namespace": data.removeOnePodData.objectMeta.namespace,
      }
      DeletePod(cs.clusterId, delParams).then(res => {
        if (res.errCode === 0) {
          message.success("删除成功")
          data.removeOnePodVisible = false
          detail(router.query)
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const detailPod = (text) => {
      let cs = GetStorage()
      routers.push({
        name: 'PodDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    onMounted(() => {
      detail(router.query);
    });
    return {
      data,
      detail,
      eventsColumns,
      statusConditionsColumns,
      jobPodColumns,
      nodeDetail,
      removeOnePod,
      removeOnPodOnSubmit,
      detailPod,
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
/* 先画个圆圈 */
.circular {
  width: 30px;
  height: 30px;
  background-color: #F90;
  border-radius: 50px;
}

/* 再画个感叹号 */
.exclamation-point {
  height: 15px;
  line-height: 30px;
  display: block;
  color: #FFF;
  text-align: center;
  font-size: 20px
}
</style>