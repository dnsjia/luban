<template>

  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.daemonSetData.objectMeta.name" @back="() => $router.go(-1)" v-if="data.daemonSetData.objectMeta">
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
            <span>{{ data.daemonSetData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">: </span>
            <span>{{ data.daemonSetData.objectMeta.namespace }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>状态</span>
            <span class="margin-right">: </span>
            <span v-if="data.daemonSetData.statusInfo">
                  就绪：{{ data.daemonSetData.statusInfo.ready }}/{{ data.daemonSetData.statusInfo.current }}个，
                  已更新：{{ data.daemonSetData.statusInfo.updated }}个，可用：{{ data.daemonSetData.statusInfo.available }}个，
                  不可用：{{ data.daemonSetData.statusInfo.unavailable }}个
                </span>
          </td>
          <td>
            <span>创建时间</span>
            <span class="margin-right">: </span>
            <span> {{ $filters.fmtTime(data.daemonSetData.objectMeta.creationTimestamp) }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>策略</span>
            <span class="margin-right">: </span>
            <span>{{ data.daemonSetData.strategy.type }}</span>
          </td>
          <td colspan="2">
            <span>选择器</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block;  margin-bottom: 5px;" >
                <a-tag v-for="(label_k, label_v, index) in data.daemonSetData.labelSelector.matchLabels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
              </span>
          </td>
        </tr>

        <tr>
          <td>
            <span>注解</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                <span v-for="(k, v, i) in data.daemonSetData.objectMeta.annotations" :key="i">
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
                    <a-tag v-for="(label_k, label_v, index) in data.daemonSetData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
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
          <a-table
              :columns="daemonSetPodColumns"
              :data-source="data.daemonSetPodData"
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
import {GetStorage} from "../../plugin/state/stroge";
import {DaemonSetDetail, DeletePod, DeleteService} from "../../api/k8s";
import {useRoute} from "vue-router";
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
const daemonSetPodColumns = [
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
  name: "DaemonSetDetail",
  setup() {
    const data = reactive({
      daemonSetData: [],
      daemonSetPodData: [],
      removeOnePodData: [],
      removeOnePodVisible: false,
      serviceData: [],
      removeOneServiceData: [],
      removeOneServiceVisible: false,
    })
    const message = inject('$message');
    let router = useRoute()
    const detail = (params) => {
      let cs = GetStorage()
      DaemonSetDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.daemonSetData = res.data
          data.daemonSetPodData = res.data.podList.pods
          data.serviceData = res.data.svcList.services
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
          detail(router.query);

        } else {
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
      daemonSetPodColumns,
      serviceColumns,
      nodeDetail,
      removeOnePod,
      removeOnPodOnSubmit,
      detailPod,
      serviceDetail,
      removeOneService,
      removeOnServiceOnSubmit,
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