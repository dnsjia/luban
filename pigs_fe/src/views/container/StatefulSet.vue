<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnStatefulSet" style="min-width: 180px">
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
          @search="statefulSetSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;left: -10px;margin-bottom: 10px" gutter={40} type="flex" justify="space-between"
              align="bottom" @click="GetStatefulSetList()">
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
          :data-source="data.statefulSetData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="StatefulSetDetail(text)">{{ text.objectMeta.name }}</a>
        </template>

        <template #labels="{text}">
          <span v-for="(v, k, i) in text.objectMeta.labels" :key="i">
            <a-tag color="cyan">{{ k }}: {{ v }}</a-tag>
          </span>
        </template>

        <template #replicas="{text}">
          <span>
           {{ text.podInfo.current }} / {{ text.podInfo.desired }}
          </span>
        </template>

        <template #creationTimestamp="{text}">
          <span>
           {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
          </span>
        </template>

        <template #action="{text}">

          <a @click="StatefulSetDetail(text)">详情</a>
          <a-divider type="vertical"/>

          <a-popconfirm placement="left" ok-text="确定" cancel-text="取消" @confirm="RestartStatefulSet(text)">
            <template #title>
              <span>你确定要重启应用吗？</span><br/>
              <span>{{ text.objectMeta.name }}</span>
            </template>
            <a>重启</a>
          </a-popconfirm>

          <a-divider type="vertical"/>
          <a @click="ScaleStatefulSet(text)">扩缩容</a>
          <a-divider type="vertical"/>
          <a-dropdown :trigger="['click']">
            <a class="ant-dropdown-link" @click.prevent>
              更多
              <DownOutlined/>
            </a>
            <template #overlay>
              <a-menu>
                <a-menu-item><span @click="EditStatefulSet(text)">编辑应用</span></a-menu-item>
                <a-menu-item><span @click="RemoveOneStatefulSet(text)" style="color: red">删除应用</span></a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>

        </template>
      </a-table>
    </a-spin>

    <div style="float:left;padding: 10px 0 0 20px">
      <a-space>
        <a-button :disabled="!hasSelected" @click="CollectionRemoveStatefulSet">批量删除</a-button>
      </a-space>
    </div>

    <template>
      <div>
        <a-modal v-model:visible="data.CollectionRemoveStatefulSetVisible" title="有状态应用 (StatefulSet) "
                 @ok="CollectionRemoveStatefulSetOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" width="820px">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下应用？</p>
          </a-space>
          <a-table :columns="CollectionRemoveStatefulSetColumns" :data-source="data.CollectionRemoveStatefulSetData" size="middle"
                   :pagination="false">
            <template #CollectionRemoveStatefulSetCreationTimestamp="{text}">
              {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
            </template>
          </a-table>
        </a-modal>
      </div>
    </template>

    <template>
      <div>
        <a-modal v-model:visible="data.ScaleStatefulSetVisible"
                 title="伸缩"
                 @ok="ScaleStatefulSetOk()"
                 cancelText="取消"
                 okText="确定" :keyboard="false"
                 :maskClosable="false"
                 :confirm-loading="data.ScaleStatefulSetLoading"
        >
          <a-space :size="-1">
            <span style="padding: 20px; color: #737373">所需容器组数量：</span>
            <a-input-number id="inputNumber" v-model:value="data.ScaleStatefulSetNumber" :min="0" :max="20"/>
          </a-space>
          <br/>
          <span class="scale" v-if="data.ScaleStatefulSetData!=''">更新资源 {{data.ScaleStatefulSetData.objectMeta.name }} 的容器数量</span>
          <p class="scale" v-if="data.ScaleStatefulSetData!=''">已创建 {{ data.ScaleStatefulSetData.podInfo.desired }} 个，
            总共需要 {{ data.ScaleStatefulSetNumber }} 个</p>
        </a-modal>
      </div>
    </template>

    <template>
      <div>
        <a-modal v-model:visible="data.RemoveOneStatefulSetVisible" title="有状态应用 (StatefulSet) "
                 @ok="RemoveOnStatefulSetOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除 {{ data.RemoveOneStatefulSetData.objectMeta.name }} 应用？</p>
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
import {
  GetStatefulSet,
  GetNamespaces,
  DeleteCollectionStatefulSet,
  DeleteStatefulSet, restartStatefulSet,
  scaleStatefulSet
} from "../../api/k8s";
import {GetStorage} from "../../plugin/state/stroge";
import {SyncOutlined} from '@ant-design/icons-vue';
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
const CollectionRemoveStatefulSetColumns = [
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
    slots: {customRender: 'CollectionRemoveStatefulSetCreationTimestamp'},
  },
]
export default {
  name: "StatefulSet",
  setup(){
    const data = reactive({
      namespaceData: [],
      loading: false,
      statefulSetData: [],
      selectedRows: [],
      searchValue: "",

      total: 0,
      pageSizeOptions: ['10', '20', '30', '40'],

      CollectionRemoveStatefulSetVisible: false,
      CollectionRemoveStatefulSetData: [],
      RemoveOneStatefulSetData: [],
      RemoveOneStatefulSetVisible: false,
      ScaleStatefulSetNumber: undefined,
      ScaleStatefulSetData: [],
      ScaleStatefulSetVisible: false,
      ScaleStatefulSetLoading: false,
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
      data.CollectionRemoveStatefulSetData = toRaw(data.selectedRows)
    };

    const filterByNamespaceOnStatefulSet = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      data.CollectionRemoveStatefulSetData = []
      data.selectedRows = []
      state.selectedRowKeys = []
      GetStatefulSetList()
    }
    const statefulSetSearch = (value) => {
      data.searchValue = value
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetStatefulSet(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.statefulSetData = res.data.statefulSets
          data.total = res.data.listMeta.totalItems
        } else {
          message.error("获取statefulset异常")
        }
      })
    }

    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        GetStatefulSetList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      GetStatefulSetList()
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
    const GetStatefulSetList = () => {
      // filterBy=name,ur&itemsPerPage=10&name=&page=1&sortBy=d,creationTimestamp&namespace=default
      data.loading = true
      let cs = GetStorage()
      GetStatefulSet(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.statefulSetData = res.data.statefulSets
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error("获取deployment失败")
        }
      })
    }
    const CollectionRemoveStatefulSet = () => {
      data.CollectionRemoveStatefulSetVisible = true
    }
    const CollectionRemoveStatefulSetOnSubmit = () => {
      let cs = GetStorage()
      const statefulSetList = []
      for (let i = 0; i < data.CollectionRemoveStatefulSetData.length; i++) {
        statefulSetList.push({
          "namespace": data.CollectionRemoveStatefulSetData[i].objectMeta.namespace,
          "name": data.CollectionRemoveStatefulSetData[i].objectMeta.name
        })
      }
      DeleteCollectionStatefulSet(cs.clusterId, statefulSetList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.CollectionRemoveStatefulSetVisible = false
          GetStatefulSetList()
          data.CollectionRemoveStatefulSetData = []
          data.selectedRows = []
          state.selectedRowKeys = []
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const StatefulSetDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'StatefulSetDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    const RestartStatefulSet = (text) => {
      let cs = GetStorage()
      restartStatefulSet(cs.clusterId, {
        "name": text.objectMeta.name,
        "namespace": text.objectMeta.namespace
      }).then(res => {
        if (res.errCode === 0) {
          message.success("重启任务已下发,请到容器组查看详情")
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const RemoveOneStatefulSet = (text) => {
      data.RemoveOneStatefulSetData = text
      data.RemoveOneStatefulSetVisible = true
    }
    const RemoveOnStatefulSetOnSubmit = () => {
      let cs = GetStorage()
      let delParams = {
        "name": data.RemoveOneStatefulSetData.objectMeta.name,
        "namespace": data.RemoveOneStatefulSetData.objectMeta.namespace,
      }
      DeleteStatefulSet(cs.clusterId, delParams).then(res => {
        if (res.errCode === 0) {
          message.success("删除成功")
          data.RemoveOneStatefulSetVisible = false
          GetStatefulSetList()

        } else {
          message.error(res.errMsg)
        }
      })
    }
    const ScaleStatefulSet = (text) => {
      data.ScaleStatefulSetData = text
      data.ScaleStatefulSetNumber = text.podInfo.desired
      data.ScaleStatefulSetVisible = true
    }
    const ScaleStatefulSetOk = () => {
      data.ScaleStatefulSetLoading = true
      let cs = GetStorage()
      let scaleParams = {
        "name": data.ScaleStatefulSetData.objectMeta.name,
        "namespace": data.ScaleStatefulSetData.objectMeta.namespace,
        "scaleNumber": data.ScaleStatefulSetNumber
      }
      scaleStatefulSet(cs.clusterId, scaleParams).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.ScaleStatefulSetVisible = false
          GetStatefulSetList()
        } else {
          message.error(res.errMsg)
        }
        data.ScaleStatefulSetLoading = false
      })
    }
    onMounted(() => {
      GetNamespaceList()
      GetStatefulSetList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      columns,
      GetNamespaceList,
      hasSelected,
      onSelectChange,
      filterByNamespaceOnStatefulSet,
      statefulSetSearch,
      onShowSizeChangePage,
      onChangePage,
      GetStatefulSetList,
      CollectionRemoveStatefulSet,
      CollectionRemoveStatefulSetOnSubmit,
      CollectionRemoveStatefulSetColumns,
      StatefulSetDetail,
      RemoveOneStatefulSet,
      RemoveOnStatefulSetOnSubmit,
      RestartStatefulSet,
      ScaleStatefulSet,
      ScaleStatefulSetOk,
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