<template>
  <div>
    <a-table
        :columns="columns"
        :row-key="record => record.login.uuid"
        :data-source="dataSource"
        :pagination="pagination"
        :loading="loading"
        @change="handleTableChange"
    >
      <template #name="{ text }">{{ text.first }} {{ text.last }}</template>
    </a-table>
  </div>
</template>

<script>

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

    return {
      loading: false,
      columns,

    };
  },
};



</script>

<style scoped>

</style>