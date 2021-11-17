<template>
  <div>
    <a-space style="padding-left: 10px">

      <a-input-search
          v-model:value="data.searchValue"
          placeholder="请输入搜索内容"
          style="width: 200px"
          @search="storageClassSearch"
      />
    </a-space>
    <a-button style="float:right;z-index:99;margin-bottom: 10px" gutter={40} type="flex" justify="space-between" align="bottom" @click="getStorageClassList()">
      <template #icon>
        <SyncOutlined/>
      </template>
      刷新
    </a-button>

    <!-- 页面加载中 动画效果 -->
    <a-spin :spinning="data.loading" size="large">
      <a-table
          :columns="columns"
          :data-source="data.storageClassData"
          :pagination="false"
          :rowKey="item=>JSON.stringify(item)"
          :locale="{emptyText: '暂无数据'}"
      >
        <template #name="{text}">
          <a @click="storageClassDetail(text)">{{ text.objectMeta.name }}</a>
        </template>

        <template #parameters="{text}">
          <span v-for="(v, k, i) in text.parameters" :key="i">
            <a-tag color="cyan">{{ k }}: {{ v }}</a-tag>
          </span>
        </template>

        <template #creationTimestamp="{text}">
          <span>
           {{ $filters.fmtTime(text.objectMeta.creationTimestamp) }}
          </span>
        </template>


        <template #action="{text}">

          <a @click="storageClassDetail(text)">详情</a>
          <a-divider type="vertical"/>


          <a-dropdown :trigger="['click']">
            <a class="ant-dropdown-link" @click.prevent>
              更多
              <DownOutlined/>
            </a>
            <template #overlay>
              <a-menu>
                <a-menu-item><span @click="editStorageClass(text)">编辑</span></a-menu-item>
                <a-menu-item><span @click="removeOneStorageClass(text)" style="color: red">删除</span></a-menu-item>
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
        <a-modal v-model:visible="data.removeOneStorageClassVisible" title="存储类 (StorageClass) "
                 @ok="removeOneStorageClassOk" cancelText="取消"
                 okText="确定" :keyboard="false" :maskClosable="false">
          <a-space>
            <p class="circular">
              <span class="exclamation-point">i</span>
            </p>
            <p>删除 {{ data.removeStorageClassData.objectMeta.name }} ？</p>
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
import {DeleteStorageClass, GetStorageClass} from "../../api/k8s";
import router from "../../router";
const columns = [
  {
    title: '名称',
    slots: {customRender: 'name'},
  },
  {
    title: '提供者',
    dataIndex: 'provisioner',
  },
  {
    title: '参数',
    slots: {customRender: 'parameters'},
  },
  {
    title: '回收策略',
    dataIndex: 'reclaimPolicy',
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
  name: "StorageClass",
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
      removeStorageClassData: [],
      removeOneStorageClassVisible: false,

      storageClassData: [],
      loading: false,
      searchValue: undefined,

    })

    // 显示条数
    const onShowSizeChangePage = async (current, pageSize) => {
      let cs = GetStorage()
      if (cs) {
        queryInfo.itemsPerPage = pageSize
        queryInfo.page = current
        getStorageClassList()
      }
    };
    // 翻页
    const onChangePage = async (pageNumber) => {
      queryInfo.page = pageNumber
      getStorageClassList()
    };

    const getStorageClassList = () => {
      data.loading = true
      let cs = GetStorage()
      GetStorageClass(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.storageClassData = res.data.items
          data.total = res.data.listMeta.totalItems
          data.loading = false
        } else {
          message.error(res.errMsg)
        }
      })
    }
    const storageClassDetail = (text) => {
      let cs = GetStorage()
      router.push({
        name: 'StorageClassDetail', query: {
          clusterId: cs.clusterId,
          name: text.objectMeta.name
        }
      });
    }
    const storageClassSearch = (keyword) => {
      data.searchValue = keyword
      queryInfo.filterBy = "name," + data.searchValue
      let cs = GetStorage()
      GetStorageClass(cs.clusterId, queryInfo).then(res => {
        if (res.errCode === 0) {
          data.storageClassData = res.data.items
          data.total = res.data.listMeta.totalItems
        } else {
          message.error(res.errMsg)
        }
      })
    }

    const removeOneStorageClass = (text) => {
      data.removeStorageClassData = text
      data.removeOneStorageClassVisible = true
    }
    const removeOneStorageClassOk = () => {
      let cs = GetStorage()
      DeleteStorageClass(cs.clusterId, {
        "name": data.removeStorageClassData.objectMeta.name
      }).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          data.removeOneStorageClassVisible = false
          getStorageClassList()
        }else {
          message.error(res.errMsg)
        }
      })
    }

    onMounted(() => {
      getStorageClassList()
    })
    return {
      data,
      ...toRefs(state),
      queryInfo,
      getStorageClassList,
      columns,
      storageClassDetail,
      storageClassSearch,
      onShowSizeChangePage,
      onChangePage,
      removeOneStorageClass,
      removeOneStorageClassOk,
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