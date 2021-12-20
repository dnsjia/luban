<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnDaemonSet" style="min-width: 180px">
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
          @search="daemonSetSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;left: -10px;margin-bottom: 10px" gutter={40} type="flex" justify="space-between" align="bottom" @click="getDaemonSetList()">
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
          :data-source="data.daemonSetData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="daemonSetDetail(text)">{{ text.objectMeta.name }}</a>
        </template>

        <template #labels="{text}">
          <span v-for="(v, k, i) in text.objectMeta.labels" :key="i">
            <a-tag color="cyan">{{ k }}: {{ v }}</a-tag>
          </span>
        </template>

        <template #replicas="{text}">
          <span>
           {{ text.podInfo.running }} / {{ text.podInfo.desired }}
          </span>
        </template>

        <template #creationTimestamp="{text}">
          <span>
           {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
          </span>
        </template>

        <template #action="{text}">

          <a @click="daemonSetDetail(text)">详情</a>
          <a-divider type="vertical"/>

          <a-popconfirm placement="left" ok-text="确定" cancel-text="取消" @confirm="restartDaemonSetOk(text)">
            <template #title>
              <span>你确定要重启应用吗？</span><br/>
              <span>{{ text.objectMeta.name }}</span>
            </template>
            <a>重启</a>
          </a-popconfirm>

          <a-divider type="vertical"/>

          <a-dropdown :trigger="['click']">
            <a class="ant-dropdown-link" @click.prevent>
              更多
              <DownOutlined/>
            </a>
            <template #overlay>
              <a-menu>
                <a-menu-item><span @click="editDaemonSet(text)">编辑应用</span></a-menu-item>
                <a-menu-item><span @click="removeOneDaemonSet(text)" style="color: red">删除应用</span></a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>


        </template>
      </a-table>
      <div style="float:left;padding: 10px 0 0 20px">
        <a-space>
          <a-button :disabled="!hasSelected" @click="CollectionRemoveDaemonSet">批量删除</a-button>
        </a-space>
      </div>
    </a-spin>
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
        <a-modal v-model:visible="data.CollectionRemoveDaemonSetVisible" title="守护进程集 (DaemonSet) "
                 @ok="CollectionRemoveDaemonSetOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" width="820px">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下应用？</p>
          </a-space>
          <a-table :columns="CollectionRemoveDaemonSetColumns" :data-source="data.CollectionRemoveDaemonSetData" size="middle"
                   :pagination="false">
            <template #CollectionRemoveDaemonSetCreationTimestamp="{text}">
              {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
            </template>
          </a-table>
        </a-modal>
      </div>
    </template>
    <template>
      <div>
        <a-modal v-model:visible="data.removeOneDaemonSetVisible" title="守护进程集 (DaemonSet) "
                 @ok="removeOneDaemonSetOk" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除 {{ data.removeDaemonSetData.objectMeta.name }} 应用？</p>
          </a-space>

          <br/>
        </a-modal>
      </div>
    </template>
  </div>
</template>

<script>
import {computed, inject, onMounted, reactive, toRaw, toRefs} from "vue";
import {GetStorage} from "../../plugin/state/stroge";
import {SyncOutlined} from '@ant-design/icons-vue';
import {
  DaemonSetDetail,
  DeleteCollectionDaemonSet,
  DeleteDaemonSet,
  GetDaemonSet,
  GetNamespaces,
  RestartDaemonSet
} from "../../api/k8s";
import router from "../../router";
const columns = [
  {
    title: '名称',
    slots: {customRender: 'name'},
  },
  {
    title: '标签',
    slots: {customRender: 'labels'},
  },
  {
    title: '副本数',
    slots: {customRender: 'replicas'},
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
    title: '操作',
    slots: {customRender: 'action'},
  },
]
const CollectionRemoveDaemonSetColumns = [
  {
    title: '名称',
    dataIndex: 'objectMeta.name',
  },
  {
    title: '版本',
    dataIndex: 'containerImages[0]',
  },
  {
    title: '创建时间',
    slots: {customRender: 'CollectionRemoveDaemonSetCreationTimestamp'},
  },
]
export default {
  name: "DaemonSet",
  setup(){

    const queryInfo = reactive({
      page: 1,
      itemsPerPage: 10,
      namespace: "default",
      filterBy: "",
      sortBy: "d,creationTimestamp",
    });
    const message = inject('$message');
    const state = reactive({
      selectedRowKeys: [],
    })
    const data = reactive({
      total: 0,
      pageSizeOptions: ['10', '20', '30', '40'],
      namespaceData: "",
      selectedRows: [],
      removeDaemonSetData: [],
      removeOneDaemonSetVisible: false,

      daemonSetData: [],
      loading: false,
      searchValue: undefined,
      CollectionRemoveDaemonSetVisible: false,
      CollectionRemoveDaemonSetData: [],
    })
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
    const hasSelected = computed(() => state.selectedRowKeys.length > 0);
    const onSelectChange = (selectedRowKeys, selectedRows) => {
      state.selectedRowKeys = selectedRowKeys;
      data.selectedRows = selectedRows
      data.CollectionRemoveDaemonSetData = toRaw(data.selectedRows)
    };
    const filterByNamespaceOnDaemonSet = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      data.CollectionRemoveDaemonSetData = []
      data.selectedRows = []
      state.selectedRowKeys = []
      getDaemonSetList()
    }
    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        getDaemonSetList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getDaemonSetList()
    };

    const getDaemonSetList = () => {
      // filterBy=name,ur&itemsPerPage=10&name=&page=1&sortBy=d,creationTimestamp&namespace=default
      data.loading = true
      let cs = GetStorage()
      GetDaemonSet(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.daemonSetData = res.data.daemonSets
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error("获取守护进程集失败")
        }
      })
    }
    const daemonSetDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'DaemonSetDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    const daemonSetSearch = (keyword) => {
      queryInfo.page = 1
      data.total = 0
      data.searchValue = keyword
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetDaemonSet(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.daemonSetData = res.data.daemonSets
          data.total = res.data.listMeta.totalItems
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const CollectionRemoveDaemonSet = () => {
      data.CollectionRemoveDaemonSetVisible = true
    }
    const CollectionRemoveDaemonSetOnSubmit = () => {
      let cs = GetStorage()
      const daemonSetList = []
      for (let i = 0; i < data.CollectionRemoveDaemonSetData.length; i++) {
        daemonSetList.push({
          "namespace": data.CollectionRemoveDaemonSetData[i].objectMeta.namespace,
          "name": data.CollectionRemoveDaemonSetData[i].objectMeta.name
        })
      }
      DeleteCollectionDaemonSet(cs.clusterId, daemonSetList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.CollectionRemoveDaemonSetVisible = false
          getDaemonSetList()
          data.CollectionRemoveDaemonSetData = []
          data.selectedRows = []
          state.selectedRowKeys = []
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const restartDaemonSetOk = (text) => {
      let cs = GetStorage()
      let params = {
        "namespace": text.objectMeta.namespace,
        "name": text.objectMeta.name
      }
      RestartDaemonSet(cs.clusterId, params).then(res => {
        if (res.errCode ===0) {
          message.success("重启任务已下发,请到容器组查看详情")
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const removeOneDaemonSet = (text) => {
      data.removeDaemonSetData = text
      data.removeOneDaemonSetVisible = true
    }
    const removeOneDaemonSetOk = () => {
      let cs = GetStorage()
      DeleteDaemonSet(cs.clusterId, {
            "namespace": data.removeDaemonSetData.objectMeta.namespace,
            "name": data.removeDaemonSetData.objectMeta.name
          }).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          data.removeOneDaemonSetVisible = false
          getDaemonSetList()
        }else {
          message.error(res.errMsg)
        }
      })
    }

    onMounted(() => {
      GetNamespaceList()
      getDaemonSetList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      GetNamespaceList,
      onSelectChange,
      hasSelected,
      filterByNamespaceOnDaemonSet,
      getDaemonSetList,
      columns,
      daemonSetDetail,
      daemonSetSearch,
      CollectionRemoveDaemonSet,
      onShowSizeChangePage,
      onChangePage,
      CollectionRemoveDaemonSetOnSubmit,
      CollectionRemoveDaemonSetColumns,
      removeOneDaemonSet,
      removeOneDaemonSetOk,
      restartDaemonSetOk,
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
.scale {
  padding-left: 150px;
  color: #737373
}
</style>