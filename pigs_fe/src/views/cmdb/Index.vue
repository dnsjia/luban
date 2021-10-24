<template>
  <div>
    <a-row type="flex">
<!--      <a-col flex="100px">-->
      <a-col :xs="20" :md="12" :lg="8" :xl="4">
        <!-- 资产树形控件开始 -->
        <a-card :hoverable="true" style="height: 100%" title="资产分组">
          <template #extra>
            <a-tooltip>
              <template #title>右键点击分组可进行分组管理， 删除分组时请先删除主机。</template>
              <QuestionCircleOutlined/>
            </a-tooltip>
          </template>
          <a-directory-tree
                :tree-data="store.treeData"
                v-model:expandedKeys="expandedKeys"
                v-model:selectedKeys="selectedKeys">

              <template #title="{ id: treeKey, name }">
                <a-dropdown :trigger="['contextmenu']">
                  <!-- 显示分组下ecs数量-->
                  <span>{{ name }}</span>
                  <template #overlay>
                    <a-menu @click="({ key: menuKey }) => onContextMenuClick(treeKey, menuKey)">
                      <a-menu-item key="1"><FolderOutlined />新建根分组</a-menu-item>
                      <a-menu-item key="2"><FolderAddOutlined />新建子分组</a-menu-item>
                      <a-menu-item key="3"><EditOutlined />重命名</a-menu-item>
                      <a-menu-divider></a-menu-divider>
                      <a-menu-item key="4" danger><CloseOutlined />删除主机</a-menu-item>
                      <a-menu-item key="5" danger><DeleteOutlined />删除此分组</a-menu-item>
                    </a-menu>
                  </template>
                </a-dropdown>
              </template>
            </a-directory-tree>

          <div v-if="store.treeData" style="padding-top: 40px; text-align:center">
            <div v-if="store.treeData.length === 1 && store.treeData[0].children === null" style="color: #999;">右键可进行分组管理</div>
          </div>
          <div v-else>
            <div style="color: #999">你还没有可访问的主机分组，请联系管理员分配主机权限。</div>
          </div>
        </a-card>
        <!-- 资产树形控件结束 -->
      </a-col>

        <a-col flex="auto">
          <!-- 资产列表开始 -->
          <div style="padding-bottom: 18px; padding-left: 20px;">
            <a-space :size="18">
              <a-button type="primary" loading>同步主机</a-button>
              <a-button>导入主机</a-button>
              <a-input-search
                  v-model:value="value"
                  placeholder="可按ID、主机名、IP等属性模糊搜索主机"
                  style="width: 400px"
                  @search="onSearch"/>
            </a-space>

          </div>
          <div style="padding-left: 20px">
            <a-table
                :columns="columns"
                :row-key="record => record.login.uuid"
                :data-source="dataSource"
                :pagination="pagination"
                :loading="store.loading"
                @change="handleTableChange">
              <template #name="{ text }">{{ text.first }} {{ text.last }}</template>
            </a-table>
          </div>
          <!-- 资产列表结束 -->
        </a-col>

    </a-row>
  </div>
  <div>
<!--    <IconFont type="pigs-icon-ubuntu"/>-->
    <svg class="icon" aria-hidden="true">
      <use xlink:href="#pigs-icon-ubuntu"></use>
    </svg>
  </div>
</template>

<script>
import {
  QuestionCircleOutlined
} from "@ant-design/icons-vue";


import {onBeforeMount, onMounted, reactive, ref, watch} from 'vue';
import { cloneDeep } from 'lodash-es';
import {getGroup} from "../../api/group";

const columns = [
  {
    title: '实例ID/名称',
    dataIndex: 'instance_id',
    key: 'instance_id',
    scopedSlots: {customRender: 'instance_id'}
  },
  {
    // title: '系统',
    dataIndex: 'os_type',
    key: 'os_type',
    scopedSlots: {customRender: 'os_type'}
  },
  {
    title: '机房',
    dataIndex: 'idc',
    key: 'idc',
  },
  {
    title: 'IP地址',
    dataIndex: 'private_ip',
    key: 'private_ip',
    scopedSlots: {customRender: 'ip'},
  },
  {
    title: '状态',
    dataIndex: 'status',
    key: 'status',
    scopedSlots: {customRender: 'status'},
    filterMultiple: false,
    filters: [
      {
        text: '运行中',
        value: 'Running'
      },
      {
        text: '已停止',
        value: 'Stopped'
      }
    ],

  },
  {
    title: '网络类型',
    dataIndex: 'network_type',
    key: 'network_type',
    scopedSlots: {customRender: 'network_type'},
  },
  {
    title: '配置',
    dataIndex: 'cpu',
    key: 'cpu', // memory
    scopedSlots: {customRender: 'server_configure'},
  },
  {
    title: '操作',
    key: 'action',
    scopedSlots: {customRender: 'action'},
  },
];

export default {
  name: "Index",
  setup() {
    let store = reactive({
      treeData: [],
      loading: false,
    })
    onBeforeMount(() =>{

    })

    onMounted(() =>{
      getGroups()
    })
    const editData = reactive({})
    // 重命名分组
    const edit = key => {
      editData[key] = cloneDeep(store.treeData.value.filter(item => key === item.key)[0])
    }
    const save = key => {
      Object.assign(store.treeData.value.filter(item => key === item.key)[0], editData[key])
      delete editData[key]
    }
    const expandedKeys = ref(["1"]);
    const selectedKeys = ref(["1"]);
    const value = ref('');
    // 资产搜索
    const onSearch = searchValue => {
      console.log('use value', searchValue);
      console.log('or use this.value', value.value);
    };
    // 目录树右键功能
    const onContextMenuClick = (treeKey, menuKey) => {
      if (menuKey === '5') {
        delGroup(treeKey)

      }
      console.log(`treeKey: ${treeKey}, menuKey: ${menuKey}`);
    };

    watch(expandedKeys, () => {
      console.log('expandedKeys', expandedKeys);
      // 当分组展开时获取ecs资产列表
    });
    // 删除分组
    function delGroup(key) {
      alert("删除分组")
      console.log('删除分组', key)
    }
    // 删除主机
    function delHosts(key) {
      alert(key)
    }
    // 获取分组
    const getGroups = async () => {
      const result = await getGroup()
      if (result.errCode !== 0){
        console.log('获取资产分组失败')
      }else {
        store.treeData = result.data.treeData
        console.log(store.treeData, typeof(store.treeData))
      }
    }

    return {
      store,
      columns,
      expandedKeys,
      selectedKeys,
      value,
      onSearch,
      onContextMenuClick,
      delGroup,
      delHosts,
      //
      editData,
      edit,
      save,

    };
  },
  methods: {

  },
  components: {
    QuestionCircleOutlined
  },
};



</script>

<style scoped>
</style>