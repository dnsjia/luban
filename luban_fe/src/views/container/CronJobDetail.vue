<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.cronJobData.objectMeta.name" @back="() => $router.go(-1)"
                   v-if="data.cronJobData.objectMeta">
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
            <span>{{ data.cronJobData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">: </span>
            <span>{{ data.cronJobData.objectMeta.namespace }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>暂停</span>
            <span class="margin-right">: </span>
            <span>{{ data.cronJobData.suspend }}</span>
          </td>
          <td>
            <span>创建时间</span>
            <span class="margin-right">: </span>
            <span> {{ $filters.fmtTime(data.cronJobData.objectMeta.creationTimestamp) }}</span>
          </td>
        </tr>

        <tr>
          <td style="width: 50%">
            <span>计划</span>
            <span class="margin-right">: </span>
            <span>{{ data.cronJobData.schedule }}</span>
          </td>
          <td>
            <span>注解</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                <span v-for="(k, v, i) in data.cronJobData.objectMeta.annotations" :key="i">
                  <a-tag v-if="v !== 'kubectl.kubernetes.io/last-applied-configuration'" :key="i">
                    {{ v }}: {{ k }}
                  </a-tag>
                </span>
              </span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>最近调度</span>
            <span class="margin-right">: </span>
            <span>{{ $filters.fmtTime(data.cronJobData.lastSchedule) }}</span>
          </td>
          <td colspan="2">
            <span>标签</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
              <a-tag v-for="(label_k, label_v, index) in data.cronJobData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
            </span>
          </td>
        </tr>
        </tbody>
      </table>


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

        <a-tab-pane key="1" tab="任务列表">
          <a-table
              :columns="jobColumns"
              :data-source="data.jobData"
              :pagination="false"
              :rowKey="item=>JSON.stringify(item)"
              :locale="{emptyText: '暂无数据'}"
          >
            <template #name="{text}">
              <a @click="jobDetail(text)">{{ text.objectMeta.name }}</a>
            </template>

            <template #labels="{text}">
              <span v-for="(v, k, i) in text.objectMeta.labels" :key="i">
                <a-tag color="cyan">{{ k }}: {{ v }}</a-tag>
              </span>
            </template>

            <template #status="{text}">
              <span>{{text.jobStatus.status}}</span>
            </template>

            <template #creationTimestamp="{text}">
              <span>
               {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
              </span>
            </template>

            <template #completionTime="{text}">
              <span v-if="text.podStatus.completionTime">
               {{ $filters.fmtTime(text.podStatus.completionTime) }}
              </span>
            </template>

            <template #action="{text}">
              <a @click="jobDetail(text)">详情</a>
              <a-divider type="vertical"/>
              <a @click="removeOneJob(text)" style="color: red">删除</a>
            </template>
          </a-table>
        </a-tab-pane>
      </a-tabs>
      <br/>
    </a-page-header>

    <template>
      <div>
        <a-modal v-model:visible="data.removeOneJobVisible" title="任务 (Job) "
                 @ok="removeOneJobOk" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>删除 {{ data.removeJobData.objectMeta.name }} ？</p>
          </a-space>

          <br/>
        </a-modal>
      </div>
    </template>

  </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {GetStorage} from "../../plugin/state/stroge";
import {CronJobDetail, DeleteJob} from "../../api/k8s";
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
const jobColumns = [
  {
    title: '名称',
    slots: {customRender: 'name'},
  },
  {
    title: '标签',
    slots: {customRender: 'labels'},
    width: 140,
  },
  {
    title: '任务状态',
    slots: {customRender: 'status'},
  },
  {
    title: '版本',
    dataIndex: 'containerImages[0]',
  },
  {
    title: '创建时间',
    slots: {customRender: 'creationTimestamp'},
  },
  {
    title: '完成时间',
    slots: {customRender: 'completionTime'},
  },
  {
    title: '操作',
    slots: {customRender: 'action'},
  },
]

export default {
  name: "CronJobDetail",
  setup() {
    const data = reactive({
      cronJobData: [],
      eventData: [],
      jobData: [],
      removeJobData: [],
      removeOneJobVisible: false,
    })
    const message = inject('$message');
    let router = useRoute()
    const detail = (params) => {
      let cs = GetStorage()
      CronJobDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.cronJobData = res.data
          data.jobData = res.data.jobList.jobs
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const jobDetail = (text) => {
      let cs = GetStorage()
      routers.push({
        name: 'JobDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    const removeOneJob = (text) => {
      data.removeJobData = text
      data.removeOneJobVisible = true
    }
    const removeOneJobOk = () => {
      let cs = GetStorage()
      DeleteJob(cs.clusterId, {
        "namespace": data.removeJobData.objectMeta.namespace,
        "name": data.removeJobData.objectMeta.name
      }).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          data.removeOneJobVisible = false
          detail(router.query);
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
      eventsColumns,
      jobColumns,
      jobDetail,
      removeOneJob,
      removeOneJobOk,
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