<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnSecret" style="min-width: 180px">
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
          @search="secretSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between"
              align="bottom" @click="getSecretList()">
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
          :data-source="data.secretData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="secretDetail(text)">{{ text.objectMeta.name }}</a>
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

          <a @click="secretDetail(text)">详情</a>
          <a-divider type="vertical"/>
          <a @click="editSecret(text)">编辑</a>
          <a-divider type="vertical"/>
          <a @click="removeOneSecret(text)" style="color: red">删除</a>
          <a-divider type="vertical"/>


        </template>
      </a-table>
    </a-spin>

    <div style="float:left;padding: 10px 0 0 20px">
      <a-space>
        <a-button :disabled="!hasSelected" @click="collectionRemoveSecret">批量删除</a-button>
      </a-space>
    </div>

    <template>
      <div>
        <a-modal v-model:visible="data.collectionRemoveSecretVisible" title="保密字典 (Secret) "
                 @ok="collectionRemoveSecretOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" width="620px">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下保密字典？</p>
          </a-space>
          <a-table :columns="collectionRemoveSecretColumns" :data-source="data.collectionRemoveSecretData" size="middle"
                   :pagination="false">
            <template #collectionRemoveSecretCreationTimestamp="{text}">
              {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
            </template>
          </a-table>
        </a-modal>
      </div>
    </template>

    <template>
      <div>
        <a-modal v-model:visible="data.removeOneSecretVisible" title="保密字典 (Secret) "
                 @ok="removeOnSecretOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除 {{ data.removeOneSecretData.objectMeta.name }} 配置项？</p>
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
import {DeleteCollectionSecret, DeleteSecret, GetNamespaces, GetSecretList} from "../../api/k8s";
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
    title: '类型',
    dataIndex: 'type',
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
const collectionRemoveSecretColumns = [
  {
    title: '名称',
    dataIndex: 'objectMeta.name',
  },
  {
    title: '创建时间',
    slots: {customRender: 'collectionRemoveSecretCreationTimestamp'},
  },
]
export default {
  name: "Secret",
  setup(){
    const data = reactive({
      namespaceData: [],
      loading: false,
      secretData: [],
      selectedRows: [],
      searchValue: "",

      total: 0,
      pageSizeOptions: ['10', '20', '30', '40'],

      collectionRemoveSecretVisible: false,
      collectionRemoveSecretData: [],
      removeOneSecretData: [],
      removeOneSecretVisible: false,
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
      data.collectionRemoveSecretData = toRaw(data.selectedRows)
    };

    const filterByNamespaceOnSecret = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      data.collectionRemoveSecretData = []
      data.selectedRows = []
      state.selectedRowKeys = []
      getSecretList()
    }
    const secretSearch = (value) => {
      queryInfo.page = 1
      data.total = 0
      data.searchValue = value
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetSecretList(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.secretData = res.data.secrets
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
        getSecretList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getSecretList()
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
    const getSecretList = () => {
      data.loading = true
      let cs = GetStorage()
      GetSecretList(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.secretData = res.data.secrets
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error(res.Msg)
        }
      })
    }
    const collectionRemoveSecret = () => {
      data.collectionRemoveSecretVisible = true
    }
    const collectionRemoveSecretOnSubmit = () => {
      let cs = GetStorage()
      const secretList = []
      for (let i = 0; i < data.collectionRemoveSecretData.length; i++) {
        secretList.push({
          "namespace": data.collectionRemoveSecretData[i].objectMeta.namespace,
          "name": data.collectionRemoveSecretData[i].objectMeta.name
        })
      }
      DeleteCollectionSecret(cs.clusterId, secretList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.collectionRemoveSecretVisible = false
          data.collectionRemoveSecretData = []
          data.selectedRows = []
          state.selectedRowKeys = []
          getSecretList()
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const secretDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'SecretDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }

    const removeOneSecret = (text) => {
      data.removeOneSecretData = text
      data.removeOneSecretVisible = true
    }
    const removeOnSecretOnSubmit = () => {
      let cs = GetStorage()
      let delParams = {
        "name": data.removeOneSecretData.objectMeta.name,
        "namespace": data.removeOneSecretData.objectMeta.namespace,
      }
      DeleteSecret(cs.clusterId, delParams).then(res => {
        if (res.errCode === 0) {
          message.success("删除成功")
          data.removeOneSecretVisible = false
          getSecretList()

        } else {
          message.error(res.errMsg)
        }
      })
    }

    onMounted(() => {
      GetNamespaceList()
      getSecretList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      columns,
      GetNamespaceList,
      hasSelected,
      onSelectChange,
      filterByNamespaceOnSecret,
      secretSearch,
      onShowSizeChangePage,
      onChangePage,
      getSecretList,
      collectionRemoveSecret,
      collectionRemoveSecretOnSubmit,
      collectionRemoveSecretColumns,
      secretDetail,
      removeOneSecret,
      removeOnSecretOnSubmit,

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