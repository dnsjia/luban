<template>
  <div>
    <a-divider/>
    <a-space>
      <a-select
          v-model:value="cluster.clusterName" style="width: 120px"
          @focus="focus"
          @change="handleChange"
          placeholder="请选择集群"
      >
        <a-select-option v-for="clusters in cluster.data" :key="clusters.id" :label="clusters.clusterName">
          {{ clusters.clusterName }}
        </a-select-option>
      </a-select>

      <a-input-search
          v-model:value="value"
          placeholder="根据名称过滤"
          style="width: 200px"
          @search="onSearch"
      />

<!--      &lt;!&ndash;标签过滤开始&ndash;&gt;-->
<!--      <a-dropdown-button>-->
<!--        标签过滤-->
<!--        <a-menu @click="FilterLabelMenuClick">-->
<!--          <a-menu-item v-for="(labelKey, labelValue) in cluster.data.objectMeta.labels" :key="labelValue + '=' + labelKey">-->
<!--            {{ labelValue }}={{ labelKey }}-->
<!--          </a-menu-item>-->
<!--        </a-menu>-->
<!--      </a-dropdown-button>-->

<!--      &lt;!&ndash;当标签被选中时页面显示tags&ndash;&gt;-->
<!--      <template>-->
<!--        <div>-->
<!--          <template v-for="(tag) in tags" :key="tag">-->
<!--            <a-tag :closable="true" @close="() => removeTagClose(tag)" style="background: #fff; border-style: dashed;">-->
<!--              {{ tag }}-->
<!--            </a-tag>-->
<!--          </template>-->
<!--          <a v-if="tags.length!==0" @click="removeAllTags()">清除标签</a>-->
<!--        </div>-->

<!--      </template>-->
<!--      &lt;!&ndash;标签过滤结束&ndash;&gt;-->
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between" align="bottom" @click="getNode()">
      <template #icon>
        <SyncOutlined />
      </template>
      刷新
    </a-button>
    <br/>
    <br/>

    <a-spin :spinning="page.loading" size="large">
    <a-table
        :row-selection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
        :columns="columns"
        :data-source="cluster.nodeData"
        :pagination="false"
        :rowKey="item=>JSON.stringify(item)"
        :locale="{emptyText: '暂无数据'}"
    >

      <template #name="{text }">
        <a-space>
          <a @click="nodeDetail(text.objectMeta.name)">{{ text.objectMeta.name }}</a>
          <a-tooltip color="#ffffff" :overlayStyle="{'font-size': '12px', 'max-width': '400px'}">
            <template #title>
              <div v-for="(v,k, i) in text.objectMeta.labels" :key="i">
               <span style="color: #666"> {{k}}: {{v}}</span>
              </div>
            </template>

            <TagOutlined />
          </a-tooltip>
        </a-space>
        <p>{{ text.nodeIP }}</p>
      </template>

      <template #ready="{text}">
        <span>
          <a-tag color="#090" v-if="text.ready==='True'">运行中</a-tag>
          <a-tag color="#f50" v-else-if="text.ready==='False'">异常</a-tag>
          <a-tag color="red" v-else>未知</a-tag>
        </span>
        <br/>
        <br/>
        <p v-if="text.unschedulable===true">不可调度</p>
        <p v-else>可调度</p>
      </template>

      <template #containerGroup="">
        <span>容器组<br>（已分配量/总额度）</span>
      </template>
      <template #allocatedPods="{text}">
        {{ text.allocatedResources.allocatedPods }}/{{ text.allocatedResources.podCapacity }}
      </template>

      <template #cpuGroup="">
        <span>CPU<br>请求/限制(核)</span>
      </template>
      <template #cpuResources="{text}">
        <p>{{ text.allocatedResources.cpuRequests / 1000 }} ({{ $filters.addZero(text.allocatedResources.cpuRequestsFraction) }}%)</p>
        <p>{{ text.allocatedResources.cpuLimits / 1000 }} ({{ $filters.addZero(text.allocatedResources.cpuLimitsFraction) }}%)</p>
      </template>

      <template #memGroup="">
        <span>内存<br>请求/限制(字节)</span>
      </template>
      <template #memResources="{text}">
        <p>{{ $filters.sizeType(text.allocatedResources.memoryRequests) }} ({{ $filters.addZero(text.allocatedResources.memoryRequestsFraction) }}%)</p>
        <p>{{ $filters.sizeType(text.allocatedResources.memoryLimits) }} ({{ $filters.addZero(text.allocatedResources.memoryLimitsFraction) }}%)</p>
      </template>

      <template #runTimeTitle="">
        <span>Kubelet版本<br>Runtime版本/OS</span>
      </template>
      <template #runtime="{text}">
        <div style="text-align: center">
          <span>{{ text.nodeInfo.kubeletVersion }}</span><br/>
          <span>{{ text.nodeInfo.containerRuntimeVersion }}</span><br/>
          <span>{{ text.nodeInfo.osImage }}</span>
        </div>
      </template>

      <template #creationTimestamp="{text}">
        <p>{{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}</p>
      </template>

      <template #action="{text}">
        <a-dropdown :trigger="['click']">
          <a class="ant-dropdown-link" @click.prevent>
            更多
            <DownOutlined />
          </a>
          <template #overlay>
            <a-menu>
              <a-menu-item><span @click="nodeDetail(text.objectMeta.name)">详情</span></a-menu-item>
              <a-menu-item><span @click="removeNode(text)">移除</span></a-menu-item>
              <a-menu-item><span @click="drainNode(text)">节点排水</span></a-menu-item>
              <a-menu-item><span @click="scheduleSetup(text)">调度设置</span></a-menu-item>
            </a-menu>
          </template>
        </a-dropdown>

      </template>
    </a-table>
    </a-spin>

    <!-- 调度设置 开始 -->
    <template>
      <div>
        <a-modal v-model:visible="scheduleVisible" title="调度设置" cancel-text="取消" ok-text="确认" @ok="scheduleSetupOk(cluster.nodeName.unschedulable)">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p v-if="cluster.nodeName.unschedulable===true">请确认是否要将以下节点设置为可调度？</p>
            <p v-else>请确认是否要将以下节点设置为不可调度？</p>
          </a-space>
          <br/>
          <p class="nodeName" v-if="cluster.nodeName.objectMeta">{{ cluster.nodeName.objectMeta.name }}</p>
        </a-modal>
      </div>
    </template>
    <!-- 调度设置 结束 -->

    <!-- 节点排水 开始 -->
    <template>
      <div>
        <a-modal v-model:visible="drainNodeVisible"
                 title="节点排水"
                 cancel-text="取消" ok-text="确认"
                 @ok="drainNodeOk(cluster.nodeName.objectMeta.name)"
                 :confirm-loading="drainLoading">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>请确认是否要将以下节点进行排空操作（同时设置为不可调度）？</p>
          </a-space>
          <br/>
          <p class="nodeName" v-if="cluster.nodeName.objectMeta">
            {{ cluster.nodeName.objectMeta.name }}
<!--            <span style="color: red;font-size: 8px">节点上由 DaemonSet 控制的 Pod 不会被排水</span>-->
          </p>

          <div style="background: #f8e6e9;width: 480px;height: 100px;">
            <span style="color: red; padding-left: 8px">注意：</span>
            <p style="color: red; margin-left:18px; font-size: 12px">1. 节点上由 DaemonSet 控制的 Pod 不会被排水。</p>
            <p style="color: red; margin-left:18px; font-size: 12px">2. 命名空间 kube-system 的下 Pod 不会被排水。</p>

          </div>
        </a-modal>
      </div>
    </template>
    <!-- 节点排水 结束 -->

    <!-- 节点移除 开始 -->
    <template>
      <div>
        <a-modal v-model:visible="removeNodeVisible" title="移除节点" cancel-text="取消" ok-text="确认" @ok="removeNodeOk()">
            <span style="color: red">Warning: 您正在进行高危操作！</span><br/><br/>
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确定要移除节点吗？</p>
          </a-space>
          <br/>
          <p class="nodeName" v-if="cluster.nodeName.objectMeta">{{ cluster.nodeName.objectMeta.name }}</p>
          <div style="background: #f8e6e9;width: 480px;height: 160px;">
            <span style="color: red; padding-left: 8px">注意：</span>
            <p style="color: red; margin-left:18px; font-size: 12px">1. 此操作可能会对业务产生影响，建议在业务低峰期进行</p>
            <p style="color: red; margin-left:18px; font-size: 12px">2. 如果节点上存在 Pod，将会“自动排空节点”，请确保集群资源充足，Pod 将自动迁移到其他节点。</p>
            <p style="color: red; margin-left:18px; font-size: 12px">3. 移除节点是异步操作，请稍后再来查看。</p>
            <p style="color: red; margin-left:18px; font-size: 12px">4. 节点移除后需要手动添加。</p>

          </div>
        </a-modal>
      </div>
    </template>
    <!-- 节点移除 结束 -->



    <br/>
    <div style="float:left;padding: 10px 0 0 20px">
      <a-space>
<!--        <a-button :disabled="!hasSelected" @click="CollectionNodeRemove">批量移除</a-button>-->
        <a-button :disabled="!hasSelected" @click="CollectionNodeCordon">节点排水</a-button>
        <a-button :disabled="!hasSelected" @click="CollectionNodeUnschedule">设置不可调度</a-button>
      </a-space>
    </div>

    <!--批量设置调度开始-->
    <a-modal
        v-model:visible="data.CollectionNodeUnscheduleVisible"
        title="设置不可调度"
        :confirm-loading="data.CollectionNodeUnscheduleConfirmLoading"
        @ok="CollectionNodeUnscheduleHandleOk"
    >
      <div v-if="data.selectedRows.length>0">
        <h4 style="font-size: 18px">确定更改以下 <span style="color: red">{{data.selectedRows.length}}</span> 个节点状态?</h4>
        <div v-for="v in data.selectedRows" :key="v">{{ v.objectMeta.name }}
          <span v-if="v.unschedulable">不可调度</span>
          <span v-else>可调度</span>
        </div>
        <br/>
      </div>
    </a-modal>
    <!--批量设置调度结束-->


    <!--批量节点排水开始-->
    <a-modal
        v-model:visible="data.CollectionNodeCordonVisible"
        title="设置节点排水"
        :confirm-loading="data.CollectionNodeCordonConfirmLoading"
        @ok="CollectionNodeCordonHandleOk"
    >
      <div v-if="data.selectedRows.length>0">
        <h4 style="font-size: 18px">确定排空以下 <span style="color: red">{{data.selectedRows.length}}</span> 个节点?</h4>
        <div v-for="v in data.selectedRows" :key="v">{{ v.objectMeta.name }}
          <span v-if="v.unschedulable">不可调度</span>
          <span v-else>可调度</span>
        </div>
        <a-radio :checked="true">排空节点（同时设置为不可调度）</a-radio>
        <br/>
      </div>
    </a-modal>
    <!--批量节点排水结束-->

    <div class="float-right" style="padding: 10px 0;">
      <a-pagination size="md" :show-total="total => `共 ${page.total} 条数据`" :v-model="page.total"
                    :page-size-options="page.pageSizeOptions"
                    :total="page.total"
                    show-size-changer
                    :pageSize="page.pageSize"
                    show-less-items align="right"
                    @change="onChange"
                    @showSizeChange="onShowSizeChange"
                    v-model:current="page.current"
      >
        <template #buildOptionText="props">
          <span v-if="props.value !== '50'">{{ props.value }}条/页</span>
          <span v-else>全部</span>
        </template>
      </a-pagination>
    </div>


  </div>
</template>

<script>
import {computed, reactive, ref, inject, onMounted, h, toRefs} from 'vue';
import {
  CollectionCordonNode,
  CollectionNodeSchedule,
  fetchK8SCluster,
  getNodes,
  NodeCordon,
  NodeSchedule,
  RemoveNode
} from '../../api/k8s'
import { DownOutlined,TagOutlined,SyncOutlined } from '@ant-design/icons-vue';
import router from "../../router";
import { Modal } from 'ant-design-vue';
const columns = [
  {
    title: '名称/IP',
    // dataIndex: 'objectMeta.name',
    slots: {customRender: 'name'},
  },
  {
    title: '状态',
    slots: {customRender: 'ready'},
  },
  {
    title: '角色',
    dataIndex: 'typeMeta.kind',
  },
  {
    // title: '容器组（已分配量/总额度）',
    slots: {customRender: 'allocatedPods', title: 'containerGroup'},
    align: 'center'
  },
  {
    slots: {customRender: 'cpuResources', title: 'cpuGroup'},
    align: 'center'
  },
  {
    slots: {customRender: 'memResources', title: 'memGroup'},
    align: 'center'
  },
  {
    slots: {customRender: 'runtime', title: 'runTimeTitle'},
    align: 'center'
  },
  {
    title: '创建时间',
    // dataIndex: 'objectMeta.creationTimestamp'
    slots: {customRender: 'creationTimestamp'},
  },
  {
    title: '操作',
    slots: {customRender: 'action'},
  },
];


export default {
  name: "Nodes",
  setup() {
    const handleChange = (key, value) => {
      // if (cluster.clusterId === "" || cluster.clusterId === undefined || cluster.clusterId === null) {
        localStorage.setItem("cluster", JSON.stringify({"clusterId": value.value, "clusterName": value.label}))
      // }
      getNode()
    };
    const focus = () => {
      console.log('focus');
    };

    const value = ref('');
    // 节点搜索
    const onSearch = searchValue => {

      if (cluster.clusterName === undefined ){
          message.warning("你未选择集群")
          return;
      }
      if (cluster.clusterName !== undefined && searchValue === "") {
        message.warning("请输入搜索内容")
        return;
      }
      let cs = GetStorage()
      if (cs) {
        cs = cluster.clusterId
        page.loading = true
        getNodes({'clusterId': cs, 'itemsPerPage': page.pageSize, 'page': page.current, 'filterBy': 'name,' + searchValue}).then(res => {
          if (res.errCode === 0) {
            cluster.nodeData = res.data.nodes
            page.total = res.data.listMeta.totalItems
            page.loading = false
          }else {
            message.error("获取节点异常！")
          }
        })
      }
    };

    const cluster = reactive({
      clusterName: undefined,
      data: [],
      nodeData: [],
      clusterId: "",
      // 节点名称
      nodeName: "",

    })

    const page = reactive({
      pageSize: 10,
      current: 1,
      total: null,
      pageSizeOptions: ['10', '20', '30', '40'],
      loading: false,
    })
    const state = reactive({
      selectedRowKeys: [],
    });

    const scheduleVisible = ref(false);
    const drainNodeVisible = ref(false);
    const drainLoading = ref(false);
    const removeNodeVisible = ref(false);

    const data = reactive(
        {
          CollectionNodeUnscheduleVisible: false,
          CollectionNodeUnscheduleConfirmLoading: false,
          selectedRows: [],
          unscheduleData: [],

          CollectionNodeCordonVisible: false,
          CollectionNodeCordonConfirmLoading: false,
        }
    )


    const hasSelected = computed(() => state.selectedRowKeys.length > 0);


    const onSelectChange = (selectedRowKeys, selectedRows) => {
      state.selectedRowKeys = selectedRowKeys;
      data.selectedRows = selectedRows
      for (let i = 0; i < selectedRows.length; i ++) {
        data.unscheduleData.push(selectedRows[i].objectMeta.name)
      }
    };
    // 查看集群
    const getK8SCluster = async () => {
      const {data} = await fetchK8SCluster()
      cluster.data = data.data
    }
    const message = inject('$message');
    const GetStorage = () => {
      const cs = JSON.parse(localStorage.getItem("cluster"))
      if (cs !== null && cs !== undefined && cs !== ""){
        cluster.clusterId = cs.clusterId
        cluster.clusterName = cs.clusterName
        return cluster
      }
    }
    const getNode = () => {
      let cs = GetStorage()
      if (cs) {
        cs = cluster.clusterId
        page.loading = true
        getNodes({'clusterId': cs, 'itemsPerPage': page.pageSize, 'page': page.current}).then(res => {
          if (res.errCode === 0) {
            cluster.nodeData = res.data.nodes
            page.total = res.data.listMeta.totalItems
            page.loading = false
          }else {
            message.error("获取节点异常！")
          }
        })
      }
    }
    const nodeDetail = (name) => {
      let cs = GetStorage()
      let routeData = router.resolve({ name: 'NodeDetail', query: {name: name, clusterId: cs.clusterId} });
      window.open(routeData.href, '_blank');
    }
    // const filterLabel = (e) => {
    //   const FilterLabelMenuClick(e) {
    //     const inputValue = e.key;
    //     let tags = this.tags;
    //     if (inputValue && tags.indexOf(inputValue) === -1) {
    //       tags = [...tags, inputValue];
    //     }
    //     Object.assign(this, {
    //       tags
    //     });
    //     const label = tags.join(',')
    //     this.getNodeListLabel(label)
    //   },
    // }  // 标签过滤
    // 显示条数
    const onShowSizeChange = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        cs = cluster.clusterId
        page.loading = true
        getNodes({'clusterId': cs, 'itemsPerPage': pageSize, 'page': current}).then(res => {
          if (res.errCode === 0) {
            cluster.nodeData = res.data.nodes
            page.total = res.data.listMeta.totalItems
            page.pageSize = pageSize
            page.current = current
            page.loading = false
          }else {
            message.error("获取节点异常！")
          }
        })
      }


    };
    // 翻页
    const onChange = async (pageNumber) => {
      let cs = GetStorage()
      if (cs) {
        cs = cluster.clusterId
      }
      page.loading = true
      getNodes({'clusterId': cs, 'itemsPerPage': page.pageSize, 'page': pageNumber}).then(res => {
        if (res.errCode === 0) {
          cluster.nodeData = res.data.nodes
          page.total = res.data.listMeta.totalItems
          page.current = pageNumber
          page.loading = false
        }else {
          message.error("获取节点异常！")
        }
      })

    };

    const scheduleSetup = (text) => {
      scheduleVisible.value = true
      cluster.nodeName = text
    }
    const scheduleSetupOk = (unscheduled) => {
      let cs = GetStorage()
      // unscheduled = unscheduled ? false : true;
      unscheduled = unscheduled !== true;
      NodeSchedule({"node_name": cluster.nodeName.objectMeta.name, "unscheduled": unscheduled}, cs.clusterId).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          scheduleVisible.value = false
          getNode()
        }else {
          message.error("设置节点调度失败")
        }
      });
    }
    // 批量将Node设置为不可调度
    const CollectionNodeUnschedule = () => {
        data.CollectionNodeUnscheduleVisible = true
    }
    const CollectionNodeUnscheduleHandleOk = () => {
      let cs = GetStorage()
      data.CollectionNodeUnscheduleConfirmLoading = true
      CollectionNodeSchedule({"node_name": data.unscheduleData}, cs.clusterId).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          getNode()
        }else {
          message.error(res.errMsg)
        }
        data.CollectionNodeUnscheduleVisible = false
        data.CollectionNodeUnscheduleConfirmLoading = false
        data.unscheduleData = []
        state.selectedRowKeys = []
      })
    }

    const drainNode = (text) => {
      drainNodeVisible.value = true
      cluster.nodeName = text
    }
    const drainNodeOk = () => {
      let cs = GetStorage()
      drainLoading.value = true
      NodeCordon({"node_name": cluster.nodeName.objectMeta.name}, cs.clusterId).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          drainNodeVisible.value = false
          getNode()
        }else {
          message.error("设置节点排水失败")
        }
        drainLoading.value = false
      })
    }
    const CollectionNodeCordon = () => {
      data.CollectionNodeCordonVisible = true
    }
    const CollectionNodeCordonHandleOk = () => {
      let cs = GetStorage()
      data.CollectionNodeCordonConfirmLoading = true
      CollectionCordonNode({"node_name": data.unscheduleData}, cs.clusterId).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          getNode()
        } else {
          message.error(res.errMsg)
        }
        data.CollectionNodeCordonVisible = false
        data.CollectionNodeCordonConfirmLoading = false
        data.unscheduleData = []
        state.selectedRowKeys = []
      })
    }


    const CollectionNodeRemove = () => {
    }

    const removeNode = (text) => {
      removeNodeVisible.value = true
      cluster.nodeName = text
    }
    const removeNodeOk = () => {
      let cs = GetStorage()
      RemoveNode({"node_name": cluster.nodeName.objectMeta.name}, cs.clusterId).then(res => {
        if (res.errCode === 0){
          Modal.success({
            title: '节点移除已放入后台任务',
            content: h('div', {}, [h('p', '1.请稍后刷新该页面.'), h('p', '2.如果节点移除未成功,请检查后端日志.')]),
          });
        }else {
          message.error("节点移除失败")
        }
        removeNodeVisible.value = false
      })
    }

    onMounted(() => {
      GetStorage();
      getK8SCluster();
      getNode();
    });


    return {
      focus,
      handleChange,
      cluster,
      getNode,
      value,
      onSearch,

      columns,
      hasSelected,
      ...toRefs(state),
      page,
      // func
      onSelectChange,

      onShowSizeChange,
      onChange,
      nodeDetail,
      scheduleSetup,
      scheduleVisible,
      scheduleSetupOk,
      CollectionNodeUnschedule,
      CollectionNodeUnscheduleHandleOk,

      drainNode,
      drainNodeVisible,
      drainLoading,
      drainNodeOk,
      CollectionNodeCordon,
      CollectionNodeCordonHandleOk,

      CollectionNodeRemove,
      removeNodeVisible,
      removeNode,
      removeNodeOk,
      data,

    };
  },
  components: {
    DownOutlined,
    TagOutlined,
    SyncOutlined,
  }
}
</script>

<style scoped>
  /* 先画个圆圈 */
  .circular {
    width:30px;
    height:30px;
    background-color:#F90;
    border-radius:50px;
  }
  /* 再画个感叹号 */
  .exclamation-point {
    height:15px;
    line-height:30px;
    display:block;
    color:#FFF;
    text-align:center;
    font-size:20px
  }
  .nodeName {
    padding-left: 40px;
  }
</style>