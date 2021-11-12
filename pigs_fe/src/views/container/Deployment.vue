<template>
  <div>
    <a-space style="padding-left: 10px">
      <!--          <span style="padding-top: 5px">命名空间：</span>-->
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnDeployment" style="min-width: 180px">
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
          @search="deploymentSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between"
              align="bottom" @click="getDeploymentList()">
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
          :data-source="data.deploymentData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="deploymentDetail(text)">{{ text.objectMeta.name }}</a>
        </template>

        <template #labels="{text}">
          <span v-for="(v, k, i) in text.objectMeta.labels" :key="i">
            <a-tag color="cyan">{{ k }}: {{ v }}</a-tag>
          </span>
        </template>

        <template #replicas="{text}">
          <span>
           {{ text.deploymentStatus.readyReplicas }} / {{ text.deploymentStatus.replicas }}
          </span>
        </template>

        <template #creationTimestamp="{text}">
          <span>
           {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
          </span>
        </template>

        <template #action="{text}">

          <a @click="deploymentDetail(text)">详情</a>
          <a-divider type="vertical"/>

          <a-popconfirm placement="left" ok-text="确定" cancel-text="取消" @confirm="RestartDeployment(text)">
            <template #title>
              <span>你确定要重启应用吗？</span><br/>
              <span>{{ text.objectMeta.name }}</span>
            </template>
            <a>重启</a>
          </a-popconfirm>

          <a-divider type="vertical"/>
          <a @click="scaleDeployment(text)">扩缩容</a>
          <a-divider type="vertical"/>
          <a-dropdown :trigger="['click']">
            <a class="ant-dropdown-link" @click.prevent>
              更多
              <DownOutlined/>
            </a>
            <template #overlay>
              <a-menu>
                <a-menu-item>
                  <a-popconfirm placement="left" ok-text="确定" cancel-text="取消" @confirm="rollbackVersion(text)">
                    <template #title>
                      <span>你确定要回退到上一个版本吗？</span><br/>
                      <span>应用： {{ text.objectMeta.name }} </span>
                    </template>
                    <a>回滚上一版本</a>
                  </a-popconfirm>

                </a-menu-item>
                <a-menu-item><span @click="editDeployment(text)">编辑应用</span></a-menu-item>
                <a-menu-item><span @click="removeOneDeployment(text)" style="color: red">删除应用</span></a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>

        </template>
      </a-table>
    </a-spin>

    <div style="float:left;padding: 10px 0 0 20px">
      <a-space>
        <a-button :disabled="!hasSelected" @click="CollectionRemoveDeployment">批量删除</a-button>
      </a-space>
    </div>

    <template>
      <div>
        <a-modal v-model:visible="data.removeDeploymentVisible" title="无状态应用 (Deployment) "
                 @ok="removeDeploymentOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false" width="820px">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除以下应用？</p>
          </a-space>
          <a-table :columns="removeDeploymentColumns" :data-source="data.removeDeploymentData" size="middle"
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
        <a-modal v-model:visible="data.removeOneDeploymentVisible" title="无状态应用 (Deployment) "
                 @ok="removeOnDeploymentOnSubmit" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>确认删除 {{ data.removeOneDeploymentData.objectMeta.name }} 应用？</p>
          </a-space>

          <br/>
          <template v-if="data.deploymentToServiceData.length>0">
            <div v-for="(v, i) in data.deploymentToServiceData" :key="i" style="padding-left: 20px">
              <a-checkbox v-model:checked="data.removeDeploymentToServiceChecked">删除关联的服务 (Service) {{
                  v.metadata.name
                }}
              </a-checkbox>
            </div>
          </template>


        </a-modal>
      </div>
    </template>

    <template>
      <div>
        <a-modal v-model:visible="data.scaleVisible"
                 title="伸缩"
                 @ok="scaleDeploymentOk()"
                 cancelText="取消"
                 okText="确定" :keyboard="false"
                 :maskClosable="false"
                 :confirm-loading="data.scaleDeploymentLoading"
        >
          <a-space :size="-1">
            <span style="padding: 20px; color: #737373">所需容器组数量：</span>
            <a-input-number id="inputNumber" v-model:value="data.scaleDeploymentNumber" :min="0" :max="20"/>
          </a-space>
          <br/>
          <span class="scaleDeployment" v-if="data.scaleDeploymentData!=''">更新资源 {{ data.scaleDeploymentData.objectMeta.name }} 的容器数量</span>
          <p class="scaleDeployment" v-if="data.scaleDeploymentData!=''">已创建 {{ data.scaleDeploymentData.pods.desired }} 个，
            总共需要 {{ data.scaleDeploymentNumber }} 个</p>
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
  DeleteCollectionDeployment,
  DeleteDeployment, DeploymentRollBack,
  GetDeployment,
  GetDeploymentToService,
  GetNamespaces,
  restartDeployment,
  ScaleDeployment
} from "../../api/k8s";
import {SyncOutlined} from '@ant-design/icons-vue';
import router from "../../router";
import {GetStorage} from "../../plugin/state/stroge";

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
    // slots: {customRender: 'name'},
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
const removeDeploymentColumns = [
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
    slots: {customRender: 'removeCreationTimestamp'},
  },
]

export default {
  name: "Deployment",
  setup() {

    const data = reactive({
      namespaceData: [],
      loading: false,
      deploymentData: [],
      selectedRows: [],
      searchValue: "",

      total: 0,
      pageSizeOptions: ['10', '20', '30', '40'],

      removeDeploymentVisible: false,
      removeDeploymentData: [],
      scaleVisible: false,
      scaleDeploymentLoading: false,
      scaleDeploymentData: "",
      scaleDeploymentNumber: undefined,

      removeOneDeploymentVisible: false,
      removeOneDeploymentData: [],

      deploymentToServiceData: [],
      removeDeploymentToServiceChecked: false,
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
      data.removeDeploymentData = toRaw(data.selectedRows)
    };

    const filterByNamespaceOnDeployment = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      getDeploymentList()
    }

    const getDeploymentList = () => {
      // filterBy=name,ur&itemsPerPage=10&name=&page=1&sortBy=d,creationTimestamp&namespace=default
      data.loading = true
      let cs = GetStorage()
      GetDeployment(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.deploymentData = res.data.deployments
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error("获取deployment失败")
        }
      })
    }

    const deploymentSearch = (value) => {
      // if (value === "") {
      //   message.warning("搜索内容不能为空")
      //   return
      // }
      data.searchValue = value
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetDeployment(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.deploymentData = res.data.deployments
          data.total = res.data.listMeta.totalItems
        } else {
          message.error("获取deployment失败")
        }
      })
    }

    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        getDeploymentList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getDeploymentList()

    };

    const CollectionRemoveDeployment = () => {
      data.removeDeploymentVisible = true
    }
    const removeDeploymentOnSubmit = () => {
      let cs = GetStorage()
      const deploymentList = []
      for (let i = 0; i < data.removeDeploymentData.length; i++) {
        deploymentList.push({
          "namespace": data.removeDeploymentData[i].objectMeta.namespace,
          "deploymentName": data.removeDeploymentData[i].objectMeta.name
        })
      }
      DeleteCollectionDeployment(cs.clusterId, deploymentList).then(res => {
        if (res.errCode === 0) {
          message.success(res.msg)
          data.removeDeploymentVisible = false
          getDeploymentList()
          data.removeDeploymentData = []
          data.selectedRows = []
          state.selectedRowKeys = []
        } else {
          message.error(res.errMsg)
        }
      })
    }

    const removeOneDeployment = (text) => {
      data.removeOneDeploymentData = text
      let cs = GetStorage()
      GetDeploymentToService(cs.clusterId, {
        "deploymentName": text.objectMeta.name,
        "namespace": text.objectMeta.namespace
      }).then(res => {
        if (res.errCode === 0) {
          data.deploymentToServiceData = res.data.items
        } else {
          message.warning(res.errMsg)
        }

      })
      data.removeOneDeploymentVisible = true
    }
    const removeOnDeploymentOnSubmit = () => {
      // TODO 如果关联多个Service 只会删除第一个
      let cs = GetStorage()
      let serviceName = ""
      if (data.deploymentToServiceData.length > 0) {
        serviceName = data.deploymentToServiceData[0].metadata.name
      }
      let delParams = {
        "deploymentName": data.removeOneDeploymentData.objectMeta.name,
        "namespace": data.removeOneDeploymentData.objectMeta.namespace,
        "isDeleteService": data.removeDeploymentToServiceChecked,
        "serviceName": serviceName
      }
      DeleteDeployment(cs.clusterId, delParams).then(res => {
        if (res.errCode === 0) {
          message.success("删除成功")
          data.removeOneDeploymentVisible = false
          getDeploymentList()

        } else {
          message.error(res.errMsg)
        }
      })
    }

    const scaleDeployment = (text) => {
      data.scaleVisible = true
      data.scaleDeploymentData = text
      data.scaleDeploymentNumber = text.pods.desired
    }
    const scaleDeploymentOk = () => {
      data.scaleDeploymentLoading = true
      let cs = GetStorage()
      let scaleParams = {
        "deploymentName": data.scaleDeploymentData.objectMeta.name,
        "namespace": data.scaleDeploymentData.objectMeta.namespace,
        "scaleNumber": data.scaleDeploymentNumber
      }
      ScaleDeployment(cs.clusterId, scaleParams).then(res => {
        // {"deploymentName": "nginx", "namespace": "default", "scaleNumber": 5}
        if (res.errCode === 0) {
          message.success(res.msg)
          data.scaleVisible = false
          getDeploymentList()
        } else {
          message.error(res.errMsg)
        }
        data.scaleDeploymentLoading = false
      })
    }
    const RestartDeployment = (text) => {
      let cs = GetStorage()
      restartDeployment(cs.clusterId, {
        "deploymentName": text.objectMeta.name,
        "namespace": text.objectMeta.namespace
      }).then(res => {
        if (res.errCode === 0) {
          message.success("重启任务已下发,请到容器组查看详情")
        } else {
          message.error(res.errMsg)
        }
      })
    }

    const deploymentDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'DeploymentDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    const rollbackVersion = (text) => {
      let cs = GetStorage()
      DeploymentRollBack(cs.clusterId, {"namespace": text.objectMeta.namespace, "deploymentName": text.objectMeta.name, "reVersion": 0}).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          getDeploymentList()
        }else {
          message.error(res.errMsg)
        }

      })
    }
    onMounted(() => {
      GetNamespaceList()
      getDeploymentList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      columns,
      GetNamespaceList,
      hasSelected,
      onSelectChange,
      filterByNamespaceOnDeployment,
      getDeploymentList,
      deploymentSearch,
      onShowSizeChangePage,
      onChangePage,
      CollectionRemoveDeployment,
      removeDeploymentOnSubmit,
      removeDeploymentColumns,
      removeOneDeployment,
      scaleDeployment,
      scaleDeploymentOk,
      RestartDeployment,
      removeOnDeploymentOnSubmit,
      deploymentDetail,
      rollbackVersion,
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

.scaleDeployment {
  padding-left: 150px;
  color: #737373
}
</style>