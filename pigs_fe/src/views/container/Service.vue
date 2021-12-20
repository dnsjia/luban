<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnService" style="min-width: 180px">
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
          @search="serviceSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between"
              align="bottom" @click="getServiceList()">
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
    </a-spin>

    <div style="float:left;padding: 10px 0 0 20px">
      <a-space>
        <a-button :disabled="!hasSelected" @click="CollectionRemoveService">批量删除</a-button>
      </a-space>
    </div>

    <template>
      <div>
        <a-modal v-model:visible="data.removeServiceVisible" title="服务 (Service) "
                 @ok="removeServiceOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" width="640px">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下服务？</p>
          </a-space>
          <a-table :columns="removeServiceColumns" :data-source="data.removeServiceData" size="middle"
                   :pagination="false">
            <template #removeCreationTimestamp="{text}">
              {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
            </template>
          </a-table>
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
  DeleteCollectionService,
  DeleteService,
  GetNamespaces,
  GetServiceList
} from "../../api/k8s";
import router from "../../router";
import {SyncOutlined} from "@ant-design/icons-vue";

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
const removeServiceColumns = [
  {
    title: '名称',
    dataIndex: 'objectMeta.name',
  },
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '创建时间',
    slots: {customRender: 'removeCreationTimestamp'},
  },
]

export default {
  name: "Service",
  setup() {

    const data = reactive({
      namespaceData: [],
      loading: false,
      serviceData: [],
      selectedRows: [],
      searchValue: "",

      total: 0,
      pageSizeOptions: ['10', '20', '30', '40'],

      removeServiceVisible: false,
      removeServiceData: [],


      removeOneServiceVisible: false,
      removeOneServiceData: [],

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
      data.removeServiceData = toRaw(data.selectedRows)
    };

    const filterByNamespaceOnService = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      data.removeServiceData = []
      data.selectedRows = []
      state.selectedRowKeys = []
      getServiceList()
    }

    const getServiceList = () => {
      // filterBy=name,ur&itemsPerPage=10&name=&page=1&sortBy=d,creationTimestamp&namespace=default
      data.loading = true
      let cs = GetStorage()
      GetServiceList(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.serviceData = res.data.services
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error(res.errMsg)
        }
      })
    }

    const serviceSearch = (value) => {
      queryInfo.page = 1
      data.total = 0
      data.searchValue = value
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetServiceList(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.serviceData = res.data.services
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
        getServiceList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getServiceList()

    };

    const CollectionRemoveService = () => {
      data.removeServiceVisible = true
    }
    const removeServiceOnSubmit = () => {
      let cs = GetStorage()
      const serviceList = []
      for (let i = 0; i < data.removeServiceData.length; i++) {
        serviceList.push({
          "namespace": data.removeServiceData[i].objectMeta.namespace,
          "name": data.removeServiceData[i].objectMeta.name
        })
      }
      DeleteCollectionService(cs.clusterId, serviceList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.removeServiceVisible = false
          getServiceList()
          data.removeServiceData = []
          data.selectedRows = []
          state.selectedRowKeys = []
        } else {
          message.error(res.errMsg)
        }
      })
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
          getServiceList()

        } else {
          message.error(res.errMsg)
        }
      })
    }


    const serviceDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'ServiceDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    onMounted(() => {
      GetNamespaceList()
      getServiceList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      columns,
      GetNamespaceList,
      hasSelected,
      onSelectChange,
      filterByNamespaceOnService,
      getServiceList,
      serviceSearch,
      onShowSizeChangePage,
      onChangePage,
      CollectionRemoveService,
      removeServiceOnSubmit,
      removeServiceColumns,
      removeOneService,

      removeOnServiceOnSubmit,
      serviceDetail,
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