<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnConfigMap" style="min-width: 180px">
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
          @search="configMapSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between"
              align="bottom" @click="getConfigMapList()">
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
          :data-source="data.configMapData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="configMapDetail(text)">{{ text.objectMeta.name }}</a>
        </template>

        <template #labels="{text}">
          <span v-for="(v, k, i) in text.objectMeta.labels" :key="i">
            <a-tag color="cyan">{{ k }}: {{ v }}</a-tag>
          </span>
        </template>


        <template #creationTimestamp="{text}">
          <span>
           {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
          </span>
        </template>

        <template #action="{text}">

          <a @click="configMapDetail(text)">详情</a>
          <a-divider type="vertical"/>
          <a @click="editConfigMap(text)">编辑</a>
          <a-divider type="vertical"/>
          <a @click="removeOneConfigMap(text)" style="color: red">删除</a>
          <a-divider type="vertical"/>


        </template>
      </a-table>
    </a-spin>

    <div style="float:left;padding: 10px 0 0 20px">
      <a-space>
        <a-button :disabled="!hasSelected" @click="collectionRemoveConfigMap">批量删除</a-button>
      </a-space>
    </div>

    <template>
      <div>
        <a-modal v-model:visible="data.collectionRemoveConfigMapVisible" title="配置项 (ConfigMap) "
                 @ok="collectionRemoveConfigMapOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" width="620px">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下配置项？</p>
          </a-space>
          <a-table :columns="collectionRemoveConfigMapColumns" :data-source="data.collectionRemoveConfigMapData" size="middle"
                   :pagination="false">
            <template #collectionRemoveConfigMapCreationTimestamp="{text}">
              {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
            </template>
          </a-table>
        </a-modal>
      </div>
    </template>

    <template>
      <div>
        <a-modal v-model:visible="data.removeOneConfigMapVisible" title="配置项 (ConfigMap) "
                 @ok="removeOnConfigMapOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除 {{ data.removeOneConfigMapData.objectMeta.name }} 配置项？</p>
          </a-space>

          <br/>

        </a-modal>
      </div>
    </template>
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
  </div>
</template>

<script>
import {computed, inject, onMounted, reactive, toRaw, toRefs} from "vue";
import {GetStorage} from "../../plugin/state/stroge";
import {
  DeleteCollectionConfigMap, DeleteConfigMap,
  GetConfigMapList,
  GetNamespaces,
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
    title: '创建时间',
    slots: {customRender: 'creationTimestamp'},
  },
  {
    title: '操作',
    slots: {customRender: 'action'},
  },
]
const collectionRemoveConfigMapColumns = [
  {
    title: '名称',
    dataIndex: 'objectMeta.name',
  },
  {
    title: '创建时间',
    slots: {customRender: 'collectionRemoveConfigMapCreationTimestamp'},
  },
]
export default {
  name: "ConfigMap",
  setup(){
    const data = reactive({
      namespaceData: [],
      loading: false,
      configMapData: [],
      selectedRows: [],
      searchValue: "",

      total: 0,
      pageSizeOptions: ['10', '20', '30', '40'],

      collectionRemoveConfigMapVisible: false,
      collectionRemoveConfigMapData: [],
      removeOneConfigMapData: [],
      removeOneConfigMapVisible: false,
    });

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
    const hasSelected = computed(() => state.selectedRowKeys.length > 0);

    const onSelectChange = (selectedRowKeys, selectedRows) => {
      state.selectedRowKeys = selectedRowKeys;
      data.selectedRows = selectedRows
      data.collectionRemoveConfigMapData = toRaw(data.selectedRows)
    };

    const filterByNamespaceOnConfigMap = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      data.collectionRemoveConfigMapData = []
      data.selectedRows = []
      state.selectedRowKeys = []
      getConfigMapList()
    }
    const configMapSearch = (value) => {
      queryInfo.page = 1
      data.total = 0
      data.searchValue = value
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetConfigMapList(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.configMapData = res.data.items
          data.total = res.data.listMeta.totalItems
        } else {
          message.error(res.errMsg)
        }
      })
    }

    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        getConfigMapList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getConfigMapList()
    };
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
    const getConfigMapList = () => {
      data.loading = true
      let cs = GetStorage()
      GetConfigMapList(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.configMapData = res.data.items
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error(res.Msg)
        }
      })
    }
    const collectionRemoveConfigMap = () => {
      data.collectionRemoveConfigMapVisible = true
    }
    const collectionRemoveConfigMapOnSubmit = () => {
      let cs = GetStorage()
      const configMapList = []
      for (let i = 0; i < data.collectionRemoveConfigMapData.length; i++) {
        configMapList.push({
          "namespace": data.collectionRemoveConfigMapData[i].objectMeta.namespace,
          "name": data.collectionRemoveConfigMapData[i].objectMeta.name
        })
      }
      DeleteCollectionConfigMap(cs.clusterId, configMapList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.collectionRemoveConfigMapVisible = false
          data.collectionRemoveConfigMapData = []
          data.selectedRows = []
          state.selectedRowKeys = []
          getConfigMapList()
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const configMapDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'ConfigMapDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }

    const removeOneConfigMap = (text) => {
      data.removeOneConfigMapData = text
      data.removeOneConfigMapVisible = true
    }
    const removeOnConfigMapOnSubmit = () => {
      let cs = GetStorage()
      let delParams = {
        "name": data.removeOneConfigMapData.objectMeta.name,
        "namespace": data.removeOneConfigMapData.objectMeta.namespace,
      }
      DeleteConfigMap(cs.clusterId, delParams).then(res => {
        if (res.errCode === 0) {
          message.success("删除成功")
          data.removeOneConfigMapVisible = false
          getConfigMapList()

        } else {
          message.error(res.errMsg)
        }
      })
    }

    onMounted(() => {
      GetNamespaceList()
      getConfigMapList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      columns,
      GetNamespaceList,
      hasSelected,
      onSelectChange,
      filterByNamespaceOnConfigMap,
      configMapSearch,
      onShowSizeChangePage,
      onChangePage,
      getConfigMapList,
      collectionRemoveConfigMap,
      collectionRemoveConfigMapOnSubmit,
      collectionRemoveConfigMapColumns,
      configMapDetail,
      removeOneConfigMap,
      removeOnConfigMapOnSubmit,

    }
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