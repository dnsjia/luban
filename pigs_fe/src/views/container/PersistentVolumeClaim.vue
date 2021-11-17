<template>
  <div>
    <a-space style="padding-left: 10px">
      <a-select v-model:value="queryInfo.namespace" placeholder="请选择命名空间" show-search
                @change="filterByNamespaceOnPVC" style="min-width: 180px">
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
          @search="pvcSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between" align="bottom" @click="getPVCList()">
      <template #icon>
        <SyncOutlined/>
      </template>
      刷新
    </a-button>

    <!-- 页面加载中 动画效果 -->
    <a-spin :spinning="data.loading" size="large">
      <a-table
          :columns="columns"
          :data-source="data.pvcData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="pvcDetail(text)">{{ text.objectMeta.name }}</a>
        </template>

        <template #creationTimestamp="{text}">
          <span>
           {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
          </span>
        </template>

        <template #volume="{text}">
          <a @click="pvDetail(text)">{{ text.volume }}</a>
        </template>


        <template #action="{text}">

          <a @click="pvcDetail(text)">详情</a>
          <a-divider type="vertical"/>


          <a-dropdown :trigger="['click']">
            <a class="ant-dropdown-link" @click.prevent>
              更多
              <DownOutlined/>
            </a>
            <template #overlay>
              <a-menu>
                <a-menu-item><span @click="editPVC(text)">编辑</span></a-menu-item>
                <a-menu-item><span @click="removeOnePVC(text)" style="color: red">删除</span></a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>


        </template>
      </a-table>

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
        <a-modal v-model:visible="data.removeOnePVCVisible" title="存储声明 (PersistentVolumeClaim) "
                 @ok="removeOnePVCOk" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>删除 {{ data.removePVCData.objectMeta.name }} ？</p>
          </a-space>

          <br/>
        </a-modal>
      </div>
    </template>



  </div>
</template>

<script>
import {inject, onMounted, reactive, toRefs} from "vue";
import {GetStorage} from "../../plugin/state/stroge";
import {DeletePVC, GetNamespaces, GetPVC} from "../../api/k8s";
import router from "../../router";

const columns = [
  {
    title: '名称',
    slots: {customRender: 'name'},
  },
  {
    title: '容量',
    dataIndex: 'capacity.storage',
    width: 140,
  },
  {
    title: '访问模式',
    dataIndex: 'accessModes',
  },
  {
    title: '状态',
    dataIndex: 'status',
  },
  {
    title: '存储类型',
    dataIndex: "objectMeta.annotations['volume.beta.kubernetes.io/storage-class']",
  },
  {
    title: '关联存储卷',
    slots: {customRender: 'volume'},
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

export default {
  name: "PVC",
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
      removePVCData: [],
      removeOnePVCVisible: false,

      pvcData: [],
      loading: false,
      searchValue: undefined,

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

    const filterByNamespaceOnPVC = (e) => {
      queryInfo.namespace = e
      queryInfo.filterBy = ""
      localStorage.setItem("namespace", e)
      getPVCList()
    }
    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        getPVCList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getPVCList()
    };

    const getPVCList = () => {
      // filterBy=name,ur&itemsPerPage=10&name=&page=1&sortBy=d,creationTimestamp&namespace=default
      data.loading = true
      let cs = GetStorage()
      GetPVC(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.pvcData = res.data.items
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const pvcDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'PVCDetail', query: {
          clusterId: cs.clusterId,
          namespace: text.objectMeta.namespace,
          name: text.objectMeta.name
        }
      });
    }
    const pvcSearch = (keyword) => {
      data.searchValue = keyword
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetPVC(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.pvcData = res.data.items
          data.total = res.data.listMeta.totalItems
        } else {
          message.error(res.errMsg)
        }
      })
    }

    const removeOnePVC = (text) => {
      data.removePVCData = text
      data.removeOnePVCVisible = true
    }
    const removeOnePVCOk = () => {
      let cs = GetStorage()
      DeletePVC(cs.clusterId, {
        "namespace": data.removePVCData.objectMeta.namespace,
        "name": data.removePVCData.objectMeta.name
      }).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          data.removeOnePVCVisible = false
          getPVCList()
        }else {
          message.error(res.errMsg)
        }
      })
    }

    const pvDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'PVDetail', query: {
          clusterId: cs.clusterId,
          name: text.volume,
        }
      });
    }
    onMounted(() => {
      GetNamespaceList()
      getPVCList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      GetNamespaceList,
      filterByNamespaceOnPVC,
      getPVCList,
      columns,
      pvcDetail,
      pvcSearch,
      onShowSizeChangePage,
      onChangePage,
      removeOnePVC,
      removeOnePVCOk,
      pvDetail,
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