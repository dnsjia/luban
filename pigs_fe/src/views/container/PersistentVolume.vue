<template>
  <div>
    <a-space style="padding-left: 10px">

      <a-input-search
          v-model:value="data.searchValue"
          placeholder="请输入搜索内容"
          style="width: 200px"
          @search="pvSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between" align="bottom" @click="getPVList()">
      <template #icon>
        <SyncOutlined/>
      </template>
      刷新
    </a-button>

    <!-- 页面加载中 动画效果 -->
    <a-spin :spinning="data.loading" size="large">
      <a-table
          :columns="columns"
          :data-source="data.pvData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="pvDetail(text)">{{ text.objectMeta.name }}</a>
        </template>

        <template #claim="{text}">
          <template v-if="text.claim===''||text.claim===null">
            暂无绑定的存储声明
          </template>
          <template v-else>
            <span>命名空间：{{ text.claim.split("/")[0] }}</span>
            <br/>
            <span>名称：<a @click="pvcDetail(text)">{{ text.claim.split("/")[1] }}</a></span>
          </template>

        </template>

        <template #creationTimestamp="{text}">
          <span>
           {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
          </span>
        </template>


        <template #action="{text}">

          <a @click="pvDetail(text)">详情</a>
          <a-divider type="vertical"/>


          <a-dropdown :trigger="['click']">
            <a class="ant-dropdown-link" @click.prevent>
              更多
              <DownOutlined/>
            </a>
            <template #overlay>
              <a-menu>
                <a-menu-item><span @click="editPV(text)">编辑</span></a-menu-item>
                <a-menu-item><span @click="removeOnePV(text)" style="color: red">删除</span></a-menu-item>
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
        <a-modal v-model:visible="data.removeOnePVVisible" title="存储卷 (PersistentVolume) "
                 @ok="removeOnePVOk" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>删除 {{ data.removePVData.objectMeta.name }} ？</p>
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
import {DeletePV, GetPV} from "../../api/k8s";
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
    title: '回收策略',
    dataIndex: 'reclaimPolicy',
  },
  {
    title: '状态',
    dataIndex: 'status',
  },
  {
    title: '存储类型',
    dataIndex: 'storageClass',
  },
  {
    title: '关联存储声明',
    slots: {customRender: 'claim'},
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
  name: "Volume",
  setup(){
    const queryInfo = reactive({
      page: 1,
      itemsPerPage: 10,
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

      selectedRows: [],
      removePVData: [],
      removeOnePVVisible: false,

      pvcData: [],
      loading: false,
      searchValue: undefined,

    })

    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        getPVList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getPVList()
    };

    const getPVList = () => {
      data.loading = true
      let cs = GetStorage()
      GetPV(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.pvData = res.data.items
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const pvDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'PVDetail', query: {
          clusterId: cs.clusterId,
          name: text.objectMeta.name
        }
      });
    }
    const pvSearch = (keyword) => {
      queryInfo.page = 1
      data.total = 0
      data.searchValue = keyword
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetPV(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.pvData = res.data.items
          data.total = res.data.listMeta.totalItems
        } else {
          message.error(res.errMsg)
        }
      })
    }

    const removeOnePV = (text) => {
      data.removePVData = text
      data.removeOnePVVisible = true
    }
    const removeOnePVOk = () => {
      let cs = GetStorage()
      DeletePV(cs.clusterId, {
        "name": data.removePVData.objectMeta.name
      }).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          data.removeOnePVVisible = false
          getPVList()
        }else {
          message.error(res.errMsg)
        }
      })
    }

    const pvcDetail = (text) => {
      let cs = GetStorage()
      let namespace = text.claim.split("/")[0]
      let name = text.claim.split("/")[1]
      router.push({
        name: 'PVCDetail', query: {
          clusterId: cs.clusterId,
          namespace: namespace,
          name: name
        }
      });
    }
    onMounted(() => {
      getPVList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      getPVList,
      columns,
      pvDetail,
      pvSearch,
      onShowSizeChangePage,
      onChangePage,
      removeOnePV,
      removeOnePVOk,
      pvcDetail,
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