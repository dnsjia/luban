<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnCronJob" style="min-width: 180px">
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
          @search="cronJobSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between" align="bottom" @click="getCronJobList()">
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
          :data-source="data.cronJobData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="cronJobDetail(text)">{{ text.objectMeta.name }}</a>
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

        <template #lastSchedule="{text}">
          <span v-if="text.lastSchedule">
           {{ $filters.fmtTime(text.lastSchedule) }}
          </span>
        </template>

        <template #suspend="{text}">
          {{text}}
        </template>

        <template #action="{text}">

          <a @click="cronJobDetail(text)">详情</a>
          <a-divider type="vertical"/>


          <a-dropdown :trigger="['click']">
            <a class="ant-dropdown-link" @click.prevent>
              更多
              <DownOutlined/>
            </a>
            <template #overlay>
              <a-menu>
                <a-menu-item><span @click="editCronJob(text)">编辑</span></a-menu-item>
                <a-menu-item><span @click="stopCronJob(text)">停止</span></a-menu-item>
                <a-menu-item><span @click="removeOneCronJob(text)" style="color: red">删除</span></a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>


        </template>
      </a-table>
      <div style="float:left;padding: 10px 0 0 20px">
        <a-space>
          <a-button :disabled="!hasSelected" @click="CollectionRemoveCronJob">批量删除</a-button>
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
        <a-modal v-model:visible="data.CollectionRemoveCronJobVisible" title="定时任务 (CronJob) "
                 @ok="CollectionRemoveCronJobOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" width="820px">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下任务？</p>
          </a-space>
          <a-table :columns="CollectionRemoveCronJobColumns" :data-source="data.CollectionRemoveCronJobData" size="middle"
                   :pagination="false">
            <template #CollectionRemoveJobCreationTimestamp="{text}">
              {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
            </template>
          </a-table>
        </a-modal>
      </div>
    </template>

    <template>
      <div>
        <a-modal v-model:visible="data.removeOneCronJobVisible" title="定时任务 (CronJob) "
                 @ok="removeOneCronJobOk" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>删除 {{ data.removeCronJobData.objectMeta.name }} ？</p>
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
import {
  DeleteCollectionCronJob,
  DeleteCronJob,
  GetCronJob,
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
    width: 140,
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
    title: '最近调度',
    slots: {customRender: 'lastSchedule'},
  },
  {
    title: '暂停',
    dataIndex: 'suspend',
    slots: {customRender: 'suspend'},
  },
  {
    title: '计划',
    dataIndex: 'schedule',
  },
  {
    title: '活跃',
    dataIndex: 'active',
  },
  {
    title: '操作',
    slots: {customRender: 'action'},
  },
]
const CollectionRemoveCronJobColumns = [
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
    slots: {customRender: 'CollectionRemoveJobCreationTimestamp'},
  },
]
export default {
  name: "CronJob",
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
      removeCronJobData: [],
      removeOneCronJobVisible: false,

      cronJobData: [],
      loading: false,
      searchValue: undefined,
      CollectionRemoveCronJobVisible: false,
      CollectionRemoveCronJobData: [],

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
      data.CollectionRemoveCronJobData = toRaw(data.selectedRows)
    };
    const filterByNamespaceOnCronJob = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      data.CollectionRemoveCronJobData = []
      data.selectedRows = []
      state.selectedRowKeys = []
      getCronJobList()
    }
    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        getCronJobList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getCronJobList()
    };

    const getCronJobList = () => {
      // filterBy=name,ur&itemsPerPage=10&name=&page=1&sortBy=d,creationTimestamp&namespace=default
      data.loading = true
      let cs = GetStorage()
      GetCronJob(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.cronJobData = res.data.items
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const cronJobDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'CronJobDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    const cronJobSearch = (keyword) => {
      data.searchValue = keyword
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetCronJob(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.cronJobData = res.data.items
          data.total = res.data.listMeta.totalItems
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const CollectionRemoveCronJob = () => {
      data.CollectionRemoveCronJobVisible = true
    }
    const CollectionRemoveCronJobOnSubmit = () => {
      let cs = GetStorage()
      const cronJobList = []
      for (let i = 0; i < data.CollectionRemoveCronJobData.length; i++) {
        cronJobList.push({
          "namespace": data.CollectionRemoveCronJobData[i].objectMeta.namespace,
          "name": data.CollectionRemoveCronJobData[i].objectMeta.name
        })
      }
      DeleteCollectionCronJob(cs.clusterId, cronJobList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.CollectionRemoveCronJobVisible = false
          getCronJobList()
          data.CollectionRemoveCronJobData = []
          data.selectedRows = []
          state.selectedRowKeys = []
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const removeOneCronJob = (text) => {
      data.removeCronJobData = text
      data.removeOneCronJobVisible = true
    }
    const removeOneCronJobOk = () => {
      let cs = GetStorage()
      DeleteCronJob(cs.clusterId, {
        "namespace": data.removeCronJobData.objectMeta.namespace,
        "name": data.removeCronJobData.objectMeta.name
      }).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          data.removeOneCronJobVisible = false
          getCronJobList()
        }else {
          message.error(res.errMsg)
        }
      })
    }

    onMounted(() => {
      GetNamespaceList()
      getCronJobList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      GetNamespaceList,
      onSelectChange,
      hasSelected,
      filterByNamespaceOnCronJob,
      getCronJobList,
      columns,
      cronJobDetail,
      cronJobSearch,
      CollectionRemoveCronJob,
      onShowSizeChangePage,
      onChangePage,
      CollectionRemoveCronJobOnSubmit,
      CollectionRemoveCronJobColumns,
      removeOneCronJob,
      removeOneCronJobOk,
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