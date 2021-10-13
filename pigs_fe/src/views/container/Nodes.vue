<template>
  <div>
    <a-divider/>
    <a-space>
      集群：
      <a-select
          v-model:value="cluster.clusterName" style="width: 120px"
          @focus="focus"
          @change="handleChange"
          placeholder="请选择集群"
      >
        <a-select-option v-for="clusters in cluster.data" :key="clusters.id" >
          {{ clusters.clusterName }}
        </a-select-option>
      </a-select>

      <a-input-search
          v-model:value="value"
          placeholder="根据名称过滤"
          style="width: 200px"
          @search="onSearch"
      />
    </a-space>

    <div style="margin-bottom: 16px">
      <span style="margin-left: 8px">
        <template v-if="hasSelected">
          {{ `Selected ${selectedRowKeys.length} items` }}
        </template>
      </span>
    </div>
    <a-table
        :row-selection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
        :columns="columns"
        :data-source="cluster.nodeData"
    />

    <a-button type="primary" :disabled="!hasSelected" :loading="loading" @click="start">
      Reload
    </a-button>
  </div>
</template>

<script>
import {computed, reactive, toRefs, ref, inject, onMounted} from 'vue';
import {fetchK8SCluster, getNodes} from '../../api/k8s'
const columns = [
  {
    title: '节点名称',
    dataIndex: 'objectMeta.name',
  },
  {
    title: '就绪',
    dataIndex: 'ready',
  },
  {
    title: '角色',
    dataIndex: 'typeMeta.kind',
  },
  {
    title: '运行类型',
    dataIndex: 'runtimeType',
  },
  {
    title: '创建时间',
    dataIndex: 'objectMeta.creationTimestamp'
  },
];


export default {
  name: "Nodes",
  setup() {
    const handleChange = value => {
      console.log(`selected ${value}`);
      getNodes({'clusterId': value}).then(res => {
        if (res.errCode === 0){
          cluster.nodeData = res.data.nodes
        }
      })
    };
    const focus = () => {
      console.log('focus');
    };

    const value = ref('');
    // 节点搜索
    const onSearch = searchValue => {
      console.log('use value', searchValue);
      console.log('or use this.value', value.value);

      if (cluster.clusterName === undefined ){
          message.warning("你未选择集群")
      }
      if (cluster.clusterName !== undefined && searchValue === "") {
        message.warning("请输入搜索内容")
      }
    };

    const cluster = reactive({
      clusterName: undefined,
      data: [],
      nodeData: [],
    })


    const state = reactive({
      selectedRowKeys: [],
      // Check here to configure the default column
      loading: false,
    });
    const hasSelected = computed(() => state.selectedRowKeys.length > 0);

    const start = () => {
      state.loading = true; // ajax request after empty completing

      setTimeout(() => {
        state.loading = false;
        state.selectedRowKeys = [];
      }, 1000);
    };

    const onSelectChange = selectedRowKeys => {
      console.log('selectedRowKeys changed: ', selectedRowKeys);
      state.selectedRowKeys = selectedRowKeys;
    };


    // 查看集群
    const getK8SCluster = async () => {
      const {data} = await fetchK8SCluster()
      cluster.data = data.data
    }

    const message = inject('$message');

    onMounted(getK8SCluster)


    return {
      focus,
      handleChange,
      cluster,

      value,
      onSearch,

      columns,
      hasSelected,
      ...toRefs(state),
      // func
      start,
      onSelectChange,

    };
  }
}
</script>

<style scoped>

</style>