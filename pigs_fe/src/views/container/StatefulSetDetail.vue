<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.detailData.objectMeta.name" @back="() => $router.go(-1)" v-if="data.detailData.objectMeta">
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>基本信息</h4>
        </div>
      </div>
      <table class="table-default-viewer">
        <tbody>
        <tr v-if="data.detailData.objectMeta">
          <td style="width: 50%">
            <span>名称</span>
            <span class="margin-right">: </span>
            <span>{{ data.detailData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">: </span>
            <span>{{ data.detailData.objectMeta.namespace }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>状态</span>
            <span class="margin-right">: </span>
            <span>
                  就绪：{{ data.detailData.statusInfo.readyReplicas }}/{{ data.detailData.podInfo.desired }}个，
                  已更新：{{ data.detailData.statusInfo.updated }}个，可用：{{ data.detailData.podInfo.running }}个
                </span>
          </td>
          <td>
            <span>创建时间</span>
            <span class="margin-right">: </span>
            <div v-if="data.detailData.objectMeta">
              <span> {{ $filters.fmtTime(data.detailData.objectMeta.creationTimestamp) }}</span>
            </div>

          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>策略</span>
            <span class="margin-right">: </span>
            <span>{{ data.detailData.strategy.type }}</span>
          </td>
          <td colspan="2">
            <span>选择器</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block;  margin-bottom: 5px;" v-if="data.detailData.selector">
                <a-tag v-for="(label_k, label_v, index) in data.detailData.selector.matchLabels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
            </span>
          </td>
        </tr>

        <tr>
          <td>
            <span>标签</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                <a-tag v-for="(label_k, label_v, index) in data.detailData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
              </span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span>注解</span>
            <span class="margin-right">: </span>

            <span v-for="(k, v, i) in data.detailData.objectMeta.annotations" :key="i">
                  <a-tag v-if="v !== 'kubectl.kubernetes.io/last-applied-configuration'" :key="i">
                    {{ v }}: {{ k }}
                  </a-tag>
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

        <a-tab-pane key="1" tab="容器组">
          功能开发中
        </a-tab-pane>

        <a-tab-pane key="2" tab="访问方式" force-render>
          功能开发中
        </a-tab-pane>

      </a-tabs>
      <br/>
    </a-page-header>
  </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {StatefulSetDetail} from "../../api/k8s";
import {useRoute} from "vue-router";

const eventsColumns = [

]
export default {
  name: "StatefulSetDetail",
  setup() {
    const message = inject('$message');
    const data = reactive({
      detailData: [],
      eventData: [],
      historyData: [],
    })
    const getDetail = (params) => {
      console.log(params)
      StatefulSetDetail(params).then(res => {
        if (res.errCode === 0){
          data.detailData = res.data
          // data.eventData = res.data.events.items
          // data.historyData = res.data.historyVersion
        }else {
          message.error(res.errMsg)
        }
      })
    }
    let router = useRoute()

    onMounted(() => {
      getDetail(router.query);
    });

    return {
      data,
      getDetail,
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