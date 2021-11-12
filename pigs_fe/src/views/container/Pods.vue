<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnPods" style="min-width: 180px">
        <a-select-option
            v-for="(item, index) in data.namespaceData"
            :key="index"
            :label="item.metadata.name"
            :value="item.metadata.name">
          {{ item.metadata.name }}
        </a-select-option>
      </a-select>

      <a-input-search
          v-model:value="data.searchValue"
          placeholder="请输入搜索内容"
          style="width: 200px"
          @search="podsSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between"
              align="bottom" @click="GetPods()">
      <template #icon>
        <SyncOutlined/>
      </template>
      刷新
    </a-button>

    <!-- 页面加载中 动画效果 -->
    <a-spin :spinning="data.loading" size="large">
      <a-table
          :row-selection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
          :columns="columns"
          :data-source="data.podsData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <div>
<!--            <svg class="icon" aria-hidden="true">-->
<!--              <use xlink:href="#pigs-icon-rongqi" style="width:14px;margin-right:2px"></use>-->
<!--            </svg>-->
             <img style="width:14px;margin-right:2px" src="//g.alicdn.com/aliyun/cos/1.38.27/images/icon_docker.png">
            <a @click="detailPod(text)">{{text.objectMeta.name}}</a>
          </div>

        </template>

        <template #podStatus="{text}">
        <span>
          <a-tag color="#090" v-if="text.status==='Running'">Running</a-tag>
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
    </a-spin>

    <div style="float:left;padding: 10px 0 0 20px">
      <a-space>
        <a-button :disabled="!hasSelected" @click="CollectionRemovePods">批量删除</a-button>
      </a-space>
    </div>
    <div class="float-right" style="padding: 10px 0;">
      <a-pagination size="md" :show-total="total => `共 ${data.total} 条数据`" :v-model="data.total"
                    :page-size-options="data.pageSizeOptions"
                    :total="data.total"
                    show-size-changer
                    :pageSize="queryInfo.itemsPerPage"
                    show-less-items align="right"
                    @change="onChangePage"
                    @showSizeChange="onShowSizeChangePage"
                    v-model:current="queryInfo.page"
      >
        <template #buildOptionText="props">
          <span v-if="props.value !== '50'">{{ props.value }}条/页</span>
          <span v-else>全部</span>
        </template>
      </a-pagination>
    </div>

    <template>
      <div>
        <a-modal v-model:visible="data.CollectionRemovePodsVisible" title="容器组 (Container Group) "
                 @ok="CollectionRemovePodsOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" >
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下容器？</p>
          </a-space>
          <a-table :columns="CollectionRemovePodsColumns" :data-source="data.CollectionRemovePodsData" size="middle"
                   :pagination="false">
            <template #podCreationTimestamp="{text}">
              {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
            </template>
          </a-table>
        </a-modal>
      </div>
    </template>

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
import {computed, inject, onMounted, reactive, toRaw, toRefs} from "vue";
import {
  DeleteCollectionPods,
  DeletePod,
  GetNamespaces,
  GetPodsList
} from "../../api/k8s";
import {SyncOutlined} from "@ant-design/icons-vue";
import router from "../../router";

const columns = [
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
const CollectionRemovePodsColumns = [
  {
    title: '名称',
    dataIndex: 'objectMeta.name',
  },
  {
    title: '创建时间',
    slots: {customRender: 'podCreationTimestamp'},
  },
]
export default {
  name: "Pods",
  setup(){
    const queryInfo = reactive({
      page: 1,
      itemsPerPage: 10,
      namespace: "default",
      filterBy: "",
      sortBy: "d,creationTimestamp",
    });
    const cluster = reactive({
      clusterId: "",
      clusterName: ""
    })
    const state = reactive({
      selectedRowKeys: [],
    })
    const onSelectChange = (selectedRowKeys, selectedRows) => {
      state.selectedRowKeys = selectedRowKeys;
      data.selectedRows = selectedRows
      data.CollectionRemovePodsData = toRaw(data.selectedRows)
    };
    const hasSelected = computed(() => state.selectedRowKeys.length > 0);
    const message = inject('$message');
    const data = reactive({
      namespaceData: [],
      searchValue: "",
      loading: false,
      total: 0,
      pageSizeOptions: ['10', '20', '30', '40'],
      podsData: [],
      selectedRows: [],
      CollectionRemovePodsData: [],
      CollectionRemovePodsVisible: false,
      removeOnePodData: [],
      removeOnePodVisible: false,

    });
    const podsSearch = (value) => {
      data.searchValue = value
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetPodsList(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.podsData = res.data.pods
          data.total = res.data.listMeta.totalItems
        } else {
          message.error("获取容器组失败")
        }
      })
    }
    const filterByNamespaceOnPods = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      GetPods()
    }
    const GetPods = () => {
      // filterBy=name,nginx&itemsPerPage=50&name=&page=1&sortBy=d,creationTimestamp&namespace=default
      data.loading = true
      let cs = GetStorage()
      GetPodsList(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.podsData = res.data.pods
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error("获取deployment失败")
        }
      })
    }
    const GetNamespaceList = () => {
      let cs = GetStorage()
      GetNamespaces(cs.clusterId).then(res => {
        if (res.errCode === 0) {
          data.namespaceData = res.data.items
        } else {
          message.error("获取命名空间异常")
        }
      })
      queryInfo.namespace = localStorage.getItem("namespace")
    }
    const GetStorage = () => {
      const cs = JSON.parse(localStorage.getItem("cluster"))
      if (cs !== null && cs !== undefined && cs !== "") {
        cluster.clusterId = cs.clusterId
        cluster.clusterName = cs.clusterName
        return cluster
      }
    }
    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        GetPods()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      GetPods()

    };
    const nodeDetail = (name) => {
      let cs = GetStorage()
      let routeData = router.resolve({ name: 'NodeDetail', query: {name: name, clusterId: cs.clusterId} });
      window.open(routeData.href, '_blank');
    };
    const CollectionRemovePods = () => {
      data.CollectionRemovePodsVisible = true
    }
    const CollectionRemovePodsOnSubmit = () => {
      let cs = GetStorage()
      const podList = []
      for (let i = 0; i < data.CollectionRemovePodsData.length; i++) {
        podList.push({
          "namespace": data.CollectionRemovePodsData[i].objectMeta.namespace,
          "podName": data.CollectionRemovePodsData[i].objectMeta.name
        })
      }
      DeleteCollectionPods(cs.clusterId, podList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.CollectionRemovePodsVisible = false
          GetPods()
          data.CollectionRemovePodsData = []
          data.selectedRows = []
          state.selectedRowKeys = []
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const removeOnePod = (text) => {
      data.removeOnePodData = text
      data.removeOnePodVisible = true
    }
    const removeOnPodOnSubmit = () => {
      let cs = GetStorage()
      let delParams = {
        "podName": data.removeOnePodData.objectMeta.name,
        "namespace": data.removeOnePodData.objectMeta.namespace,
      }
      DeletePod(cs.clusterId, delParams).then(res => {
        if (res.errCode === 0) {
          message.success("删除成功")
          data.removeOnePodVisible = false
          GetPods()
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const detailPod = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'PodDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    onMounted(() => {
      GetNamespaceList()
      GetPods()
    })

    return {
      data,
      queryInfo,
      cluster,
      message,
      podsSearch,
      filterByNamespaceOnPods,
      columns,
      ...toRefs(state),
      onSelectChange,
      onShowSizeChangePage,
      onChangePage,
      hasSelected,
      nodeDetail,
      CollectionRemovePods,
      CollectionRemovePodsColumns,
      CollectionRemovePodsOnSubmit,
      GetPods,
      removeOnePod,
      removeOnPodOnSubmit,
      detailPod,
    }
  },
  components: {
    SyncOutlined,
  }
}
</script>

<style scoped>
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