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
            <template v-if="data.detailData.objectMeta">
              <span> {{ $filters.fmtTime(data.detailData.objectMeta.creationTimestamp) }}</span>
            </template>

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
        <template #lastSeen="{text}">
            <span class="level-assess">
              <span> {{ $filters.fmtTime(text.lastSeen) }}</span>
            </span>
        </template>

      </a-table>

      <br/>
      <a-tabs v-model:activeKey="data.workload" @change="callback">

        <a-tab-pane key="1" tab="容器组">
          <a-table
              :columns="statefulSetPodColumns"
              :data-source="data.statefulSetPodData"
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
              <a @click="viewPodLog(text)">日志</a>
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

        <a-tab-pane key="2" tab="访问方式" force-render>
          <a-table
              :columns="serviceColumns"
              :data-source="data.serviceData"
              :pagination="false"
              :rowKey="item=>JSON.stringify(item)"
              :locale="{emptyText: '暂无数据'}"
          >
            <template #name="{text}">
              <a @click="serviceDetail(text)">{{ text.objectMeta.name }}</a>
            </template>

            <template #labels="{text}">
                  <span v-for="(v, k, i) in text.objectMeta.labels" :key="i">
                    <a-tag color="cyan">{{ k }}: {{ v }}</a-tag>
                  </span>
            </template>

            <template #internalEndpoint="{text}">
                  <span v-for="(v, k, i) in text.internalEndpoint.ports" :key="i">
                    {{ text.internalEndpoint.host }}: {{ v.port }} {{ v.protocol }}<br/>
                  </span>
            </template>

            <template #externalEndpoints="{text}">
              <div v-if="text.externalEndpoints.length <= 0 ||text.externalEndpoints===null && text.externalEndpoints===undefined">
                <span>-</span>
              </div>
              <div v-else>
                    <span v-for="(v, k, i) in text.externalEndpoints.ports" :key="i">
                      {{ text.externalEndpoints.host }}: {{ v.port }} {{ v.protocol }}<br/>
                    </span>
              </div>

            </template>

            <template #creationTimestamp="{text}">
                  <span>
                   {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
                  </span>
            </template>

            <template #action="{text}">

              <a @click="serviceDetail(text)">详情</a>
              <a-divider type="vertical"/>

              <a-dropdown :trigger="['click']">
                <a class="ant-dropdown-link" @click.prevent>
                  更多
                  <DownOutlined/>
                </a>
                <template #overlay>
                  <a-menu>
                    <a-menu-item><span @click="editService(text)">编辑服务</span></a-menu-item>
                    <a-menu-item><span @click="removeOneService(text)" style="color: red">删除服务</span></a-menu-item>
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

    <template>
      <div>
        <a-modal v-model:visible="data.removeOneServiceVisible" title="服务 (Service) "
                 @ok="removeOnServiceOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除 {{ data.removeOneServiceData.objectMeta.name }} 服务？</p>
          </a-space>

          <br/>

        </a-modal>
      </div>
    </template>

  </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {DeletePod, DeleteService, StatefulSetDetail} from "../../api/k8s";
import {useRoute} from "vue-router";
import {GetStorage} from "../../plugin/state/stroge";
import routers from "../../router";

const eventsColumns = [
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '对象',
    dataIndex: 'typeMeta.kind',
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
    slots: {customRender: 'lastSeen'},
  },
]
const statefulSetPodColumns = [
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
const serviceColumns = [
  {
    title: '名称',
    slots: {customRender: 'name'},
  },
  {
    title: '标签',
    slots: {customRender: 'labels'},
  },
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '集群IP',
    dataIndex: 'clusterIP',
  },
  {
    title: '内部端点',
    slots: {customRender: 'internalEndpoint'},
  },
  {
    title: '外部端点',
    slots: {customRender: 'externalEndpoints'},
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
  name: "StatefulSetDetail",
  setup() {
    const message = inject('$message');
    const data = reactive({
      detailData: [],
      eventData: [],
      historyData: [],
      statefulSetPodData: [],
      removeOnePodData: [],
      removeOnePodVisible: false,
      serviceData: [],
      removeOneServiceData: [],
      removeOneServiceVisible: false,
    })
    const getDetail = (params) => {
      StatefulSetDetail(params).then(res => {
        if (res.errCode === 0){
          data.detailData = res.data
          data.eventData = res.data.events.events
          data.statefulSetPodData = res.data.podList.pods
          data.serviceData = res.data.svcList.services
        }else {
          message.error(res.errMsg)
        }
      })
    }
    let router = useRoute()
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
          getDetail(router.query)
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
    const serviceDetail = (text) => {
      let cs = GetStorage()
      routers.push({
        name: 'ServiceDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    const removeOneService = (text) => {
      data.removeOneServiceData = text
      data.removeOneServiceVisible = true
    }
    const removeOnServiceOnSubmit = () => {
      let cs = GetStorage()
      let delParams = {
        "name": data.removeOneServiceData.objectMeta.name,
        "namespace": data.removeOneServiceData.objectMeta.namespace,
      }
      DeleteService(cs.clusterId, delParams).then(res => {
        if (res.errCode === 0) {
          message.success("删除成功")
          data.removeOneServiceVisible = false
          getDetail(router.query);

        } else {
          message.error(res.errMsg)
        }
      })
    }
    const viewPodLog = (text) => {
      let cs = GetStorage()
      routers.push({
        name: 'ContainerLog', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name,
          type: text.typeMeta.kind
        }
      });
    }
    onMounted(() => {
      getDetail(router.query);
    });

    return {
      data,
      getDetail,
      eventsColumns,
      statefulSetPodColumns,
      serviceColumns,
      nodeDetail,
      removeOnePod,
      removeOnPodOnSubmit,
      detailPod,
      serviceDetail,
      removeOneService,
      removeOnServiceOnSubmit,
      viewPodLog,
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