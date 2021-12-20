<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnJob" style="min-width: 180px">
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
          @search="jobSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;left: -10px;margin-bottom: 10px" gutter={40} type="flex" justify="space-between" align="bottom" @click="getJobList()">
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
          :data-source="data.jobData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="jobDetail(text)">{{ text.objectMeta.name }}</a>
        </template>

        <template #labels="{text}">
          <span v-for="(v, k, i) in text.objectMeta.labels" :key="i">
            <a-tag color="cyan">{{ k }}: {{ v }}</a-tag>
          </span>
        </template>

        <template #status="{text}">
          <span>{{text.jobStatus.status}}</span>
<!--          <span v-if="text.jobStatus.status=='Complete'">-->
<!--            <a-tag color="success">已成功</a-tag>-->
<!--          </span>-->
<!--          <span v-else-if="text.jobStatus.status=='Running'">-->
<!--            <a-tag color="processing">运行中</a-tag>-->
<!--          </span>-->
<!--          <span v-else>-->
<!--            <a-tag color="error">失败</a-tag>-->
<!--          </span>-->
        </template>

        <template #pod_status="{text}">
          <p>活跃 {{text.podStatus.active}}</p>
          <p>成功 {{text.podStatus.succeeded}}</p>
          <p>失败 {{text.podStatus.failed}}</p>
        </template>

        <template #creationTimestamp="{text}">
          <span>
           {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
          </span>
        </template>

        <template #completionTime="{text}">
          <span v-if="text.podStatus.completionTime">
           {{ $filters.fmtTime(text.podStatus.completionTime) }}
          </span>
        </template>


        <template #action="{text}">

          <a @click="jobDetail(text)">详情</a>
          <a-divider type="vertical"/>


          <a-dropdown :trigger="['click']">
            <a class="ant-dropdown-link" @click.prevent>
              更多
              <DownOutlined/>
            </a>
            <template #overlay>
              <a-menu>
                <a-menu-item><span @click="editJob(text)">编辑</span></a-menu-item>
                <a-menu-item><span @click="scaleJob(text)">伸缩</span></a-menu-item>
                <a-menu-item><span @click="removeOneJob(text)" style="color: red">删除</span></a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>


        </template>
      </a-table>
      <div style="float:left;padding: 10px 0 0 20px">
        <a-space>
          <a-button :disabled="!hasSelected" @click="CollectionRemoveJob">批量删除</a-button>
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
        <a-modal v-model:visible="data.CollectionRemoveJobVisible" title="任务 (Job) "
                 @ok="CollectionRemoveJobOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" width="820px">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下任务？</p>
          </a-space>
          <a-table :columns="CollectionRemoveJobColumns" :data-source="data.CollectionRemoveJobData" size="middle"
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
        <a-modal v-model:visible="data.removeOneJobVisible" title="任务 (Job) "
                 @ok="removeOneJobOk" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>删除 {{ data.removeJobData.objectMeta.name }} ？</p>
          </a-space>

          <br/>
        </a-modal>
      </div>
    </template>

    <!-- 伸缩JOB -->
    <template>
      <div>
        <a-modal v-model:visible="data.scaleVisible" title="伸缩"
                 @ok="scaleJobOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            所需任务并行数<a-input-number style="width: 300px" v-model:value="data.scaleNumber"></a-input-number>
          </a-space>
        </a-modal>
      </div>
    </template>

  </div>
</template>

<script>
import {computed, inject, onMounted, reactive, toRaw, toRefs} from "vue";
import {GetStorage} from "../../plugin/state/stroge";
import {GetNamespaces, GetJob, DeleteCollectionJob, DeleteJob, ScaleJob} from "../../api/k8s";
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
    width: 140,
  },
  {
    title: '任务状态',
    slots: {customRender: 'status'},
  },
  {
    title: 'Pod 状态',
    slots: {customRender: 'pod_status'},
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
    title: '完成时间',
    slots: {customRender: 'completionTime'},
  },
  {
    title: '操作',
    slots: {customRender: 'action'},
  },
]
const CollectionRemoveJobColumns = [
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
  name: "Job",
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
      removeJobData: [],
      removeOneJobVisible: false,

      jobData: [],
      loading: false,
      searchValue: undefined,
      CollectionRemoveJobVisible: false,
      CollectionRemoveJobData: [],
      scaleData: [],
      scaleVisible: false,
      scaleNumber: undefined,
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
      data.CollectionRemoveJobData = toRaw(data.selectedRows)
    };
    const filterByNamespaceOnJob = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      data.CollectionRemoveJobData = []
      data.selectedRows = []
      state.selectedRowKeys = []
      getJobList()
    }
    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        getJobList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getJobList()
    };

    const getJobList = () => {
      // filterBy=name,ur&itemsPerPage=10&name=&page=1&sortBy=d,creationTimestamp&namespace=default
      data.loading = true
      let cs = GetStorage()
      GetJob(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.jobData = res.data.jobs
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const jobDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'JobDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    const jobSearch = (keyword) => {
      queryInfo.page = 1
      data.total = 0
      data.searchValue = keyword
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetJob(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.jobData = res.data.jobs
          data.total = res.data.listMeta.totalItems
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const CollectionRemoveJob = () => {
      data.CollectionRemoveJobVisible = true
    }
    const CollectionRemoveJobOnSubmit = () => {
      let cs = GetStorage()
      const jobList = []
      for (let i = 0; i < data.CollectionRemoveJobData.length; i++) {
        jobList.push({
          "namespace": data.CollectionRemoveJobData[i].objectMeta.namespace,
          "name": data.CollectionRemoveJobData[i].objectMeta.name
        })
      }
      DeleteCollectionJob(cs.clusterId, jobList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.CollectionRemoveJobVisible = false
          getJobList()
          data.CollectionRemoveJobData = []
          data.selectedRows = []
          state.selectedRowKeys = []
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const removeOneJob = (text) => {
      data.removeJobData = text
      data.removeOneJobVisible = true
    }
    const removeOneJobOk = () => {
      let cs = GetStorage()
      DeleteJob(cs.clusterId, {
        "namespace": data.removeJobData.objectMeta.namespace,
        "name": data.removeJobData.objectMeta.name
      }).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          data.removeOneJobVisible = false
          getJobList()
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const scaleJob = (text) => {
      data.scaleData = text
      data.scaleNumber = text.parallelism
      data.scaleVisible = true
    }
    const scaleJobOnSubmit = () => {
      let cs = GetStorage()
      let params = {
        "namespace": data.scaleData.objectMeta.namespace,
        "name": data.scaleData.objectMeta.name,
        "number": data.scaleNumber
      }
      ScaleJob(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          data.scaleVisible = false
          getJobList()
        }else {
          message.error(res.errMsg)
        }
      })
    }
    onMounted(() => {
      GetNamespaceList()
      getJobList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      GetNamespaceList,
      onSelectChange,
      hasSelected,
      filterByNamespaceOnJob,
      getJobList,
      columns,
      jobDetail,
      jobSearch,
      CollectionRemoveJob,
      onShowSizeChangePage,
      onChangePage,
      CollectionRemoveJobOnSubmit,
      CollectionRemoveJobColumns,
      removeOneJob,
      removeOneJobOk,
      scaleJob,
      scaleJobOnSubmit,
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