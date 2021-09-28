<template>
  <div>
    <a-row type="flex">
      <a-col flex="100px">
        <!-- 资产树形控件开始 -->
        <a-card :hoverable="true">
          <a-directory-tree
                multiple
                showIcon="true"
                draggable="true"
                v-model:expandedKeys="expandedKeys"
                v-model:selectedKeys="selectedKeys">
              <a-tree-node key="0-0" title="default">
                <a-tree-node key="0-0-0" title="bj-game-server1" is-leaf >
                  <template #icon><IconFont type="pigs-icon-ubuntu"/></template>
                </a-tree-node>
                <a-tree-node key="0-0-1" title="k8s-master" is-leaf >
                  <template #icon><IconFont type="pigs-icon-linux"/></template>
                </a-tree-node>
              </a-tree-node>
              <a-tree-node key="0-1" title="阿里云">
                <a-tree-node key="0-1-0" title="深圳一区-游戏" is-leaf >
                  <template #icon><IconFont type="pigs-icon-ubuntu"/></template>
                </a-tree-node>
                <a-tree-node key="0-1-1" title="跳板机" is-leaf >
                  <template #icon><IconFont type="pigs-icon-linux"/></template>
                </a-tree-node>
              </a-tree-node>
            </a-directory-tree>
        </a-card>
        <!-- 资产树形控件结束 -->
      </a-col>

        <a-col flex="auto">
          <!-- 资产列表开始 -->
          <div style="padding-bottom: 18px; padding-left: 40px">
            <a-space :size="18">
              <a-button type="primary" loading>同步主机</a-button>
              <a-button>导入主机</a-button>
              <a-input-search
                  v-model:value="value"
                  placeholder="可按ID、主机名、IP等属性模糊搜索主机"
                  style="width: 400px"
                  @search="onSearch"
              />
            </a-space>

          </div>
          <div style="padding-left: 40px">
            <a-table
                :columns="columns"
                :row-key="record => record.login.uuid"
                :data-source="dataSource"
                :pagination="pagination"
                :loading="loading"
                @change="handleTableChange">
              <template #name="{ text }">{{ text.first }} {{ text.last }}</template>
            </a-table>
          </div>
          <!-- 资产列表结束 -->
        </a-col>

    </a-row>
  </div>
</template>

<script>
import {createFromIconfontCN,} from "@ant-design/icons-vue";

const IconFont = createFromIconfontCN({
  scriptUrl: '//at.alicdn.com/t/font_2828790_mybvy5yyuni.js',
});

import { ref } from 'vue';
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
    const expandedKeys = ref(['0-0', '0-1']);
    const selectedKeys = ref([]);
    const value = ref('');
    const onSearch = searchValue => {
      console.log('use value', searchValue);
      console.log('or use this.value', value.value);
    };

    return {
      loading: false,
      columns,
      expandedKeys,
      selectedKeys,
      value,
      onSearch,

    };
  },
  components: {
    IconFont,
  },
};



</script>

<style scoped>

</style>