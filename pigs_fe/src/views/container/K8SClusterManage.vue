<template>
  <div>

    <div style="margin-bottom: 16px">
      <a-button type="primary" @click="addK8SCluster">注册集群</a-button>

      <a-button type="primary" danger :disabled="!hasSelected" :loading="loading" @click="start">
        Reload
      </a-button>

      <span style="margin-left: 8px">
        <template v-if="hasSelected">
          {{ `Selected ${selectedRowKeys.length} items` }}
        </template>
      </span>
    </div>

    <a-table
        :row-selection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
        :columns="columns"
        :data-source="data"
    />

    <a-modal v-model:visible="createK8SClusterVisible" title="添加新集群" @ok="onSubmit" @cancel="resetForm" cancelText="取消"
             okText="确定" :keyboard="false" :maskClosable="false">
      <a-form
          ref="formRef"
          :model="formState"
          :rules="rules"
          :label-col="labelCol"
          :wrapper-col="wrapperCol"
      >
        <a-form-item ref="k8sClusterName" label="集群名称" name="k8sClusterName">
          <a-input v-model:value="formState.k8sClusterName" placeholder="请输入集群名称"/>
        </a-form-item>
        <a-form-item label="集群版本" name="k8sClusterVersion">
          <a-select v-model:value="formState.k8sClusterVersion" placeholder="请选择集群版本">
            <a-select-option value="shanghai">Zone one</a-select-option>
            <a-select-option value="beijing">Zone two</a-select-option>
          </a-select>
        </a-form-item>

        <a-form-item label="集群凭证" name="k8sClusterConfig">
          <a-textarea v-model:value="formState.k8sClusterConfig" placeholder="请粘贴KubeConfig内容"
                      style="width: 100%; height: 300px"/>
        </a-form-item>
      </a-form>
    </a-modal>


  </div>
</template>

<script>
import {computed, onMounted, defineComponent, inject, reactive, ref, toRaw, toRefs} from 'vue';
import {k8sCluster, fetchK8SCluster} from '@/api/k8s'

const columns = [
  {
    title: '集群名称',
    dataIndex: 'clusterName',
  },
  {
    title: '集群版本',
    dataIndex: 'clusterVersion',
  },
  {
    title: '节点数量',
    dataIndex: 'nodeNumber',
  },
  {
    title: '集群凭证',
    dataIndex: 'kubeConfig',
  },
];

export default defineComponent({
  name: "Manage",
  setup() {
    const state = reactive({
      selectedRowKeys: [],
      // Check here to configure the default column
      loading: false,
      data: [],
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

    const createK8SClusterVisible = ref(false);
    let addK8SCluster = () => {
      createK8SClusterVisible.value = true;
    }

    const formRef = ref();
    const formState = reactive({
      k8sClusterName: undefined,
      k8sClusterVersion: undefined,
      k8sClusterConfig: undefined,
    });
    const rules = {
      k8sClusterName: [
        {
          required: true,
          message: '请输入集群名称',
          trigger: 'blur',
        },
        {
          min: 3,
          max: 25,
          message: '集群名称长度应为3~25',
          trigger: 'blur',
        },
      ],
      k8sClusterVersion: [
        {
          required: true,
          message: '请选择集群版本',
          trigger: 'change',
        },
      ],
      k8sClusterConfig: [
        {
          required: true,
          message: '请粘贴KubeConfig内容',
          trigger: 'blur',
        },
      ],
    };

    const onSubmit = () => {
      formRef.value
          .validate()
          .then(() => {
            console.log('values', formState, toRaw(formState));
            k8sCluster({
              "clusterName": formState.k8sClusterName,
              "kubeConfig": formState.k8sClusterConfig,
              "clusterVersion": formState.k8sClusterVersion
            }).then(res => {
              if (res.errCode === 0) {
                message.success(res.msg)
                createK8SClusterVisible.value = false;
                resetForm()
              } else {
                message.error(res.errMsg)
              }
            })
          })
          .catch(error => {
            return error
          });
    };

    const resetForm = () => {
      formRef.value.resetFields();
    };
    const message = inject('$message');


    const getK8SCluster = async () => {
      const { data } = await fetchK8SCluster()
      console.log("data:------", data)
      state.data = data
    }


    onMounted(getK8SCluster)

    // onMounted(() => {
    //   getK8SCluster
    // })

    return {
      columns,
      hasSelected,
      ...toRefs(state),
      // func
      start,
      onSelectChange,

      createK8SClusterVisible,
      addK8SCluster,

      formRef,
      formState,
      rules,
      onSubmit,
      resetForm,

      labelCol: {
        span: 4,
      },
      wrapperCol: {
        span: 19,
      },


    };
  },
});
</script>

<style>

</style>