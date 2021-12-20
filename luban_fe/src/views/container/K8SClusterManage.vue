<template>
  <div>

    <div style="margin-bottom: 16px">
      <a-space>
        <a-button type="primary" @click="addK8SCluster">注册集群</a-button>
        <a-button type="primary" danger :disabled="state.selectedRows.length<=0" @click="removeCluster()">批量删除</a-button>
      </a-space>
    </div>

    <a-table
        :row-selection="rowSelection"
        :columns="columns"
        :data-source="state.data"
        :pagination="false"
        rowKey="id"
        :locale="{emptyText: '暂无数据'}"
    >

      <template #ClusterVersion="{ text }">
        <span>
          <IconFont type="luban-icon-logo"/> &nbsp;{{ text }}
        </span>
      </template>

      <template #nodeNumber="{ text }">
        <span>
          <a-tag color="cyan">{{ text }}</a-tag>
        </span>
      </template>

      <template #kubeConfig="{ text, id }">
        <a-tooltip placement="topLeft" title="查看凭证">
          <a @click="ViewClusterConfig(id, text.id)"><IconFont type="luban-icon-pingzheng"/></a>
        </a-tooltip>
      </template>

      <template #action="{text, id }">
        <span>
          <a @click="clusterDetail(id, text.id)">查看</a>
        </span>
      </template>

    </a-table>
    <a-modal v-model:visible="state.ClusterConfigVisible" title="查看集群凭证" :footer="null" :keyboard="false" :maskClosable="false">

      <a-textarea v-model:value="state.ClusterConfig" placeholder="请粘贴KubeConfig内容" style="width: 100%; height: 600px"/>
    </a-modal>


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

<!--        <a-form-item label="集群版本" name="k8sClusterVersion">-->
<!--          <a-select v-model:value="formState.k8sClusterVersion" placeholder="请选择集群版本">-->
<!--            <a-select-option value="shanghai">Zone one</a-select-option>-->
<!--            <a-select-option value="beijing">Zone two</a-select-option>-->
<!--          </a-select>-->
<!--        </a-form-item>-->

        <a-form-item label="集群凭证" name="k8sClusterConfig">
          <a-textarea v-model:value="formState.k8sClusterConfig" placeholder="请粘贴KubeConfig内容"
                      style="width: 100%; height: 300px"/>
        </a-form-item>

      </a-form>
    </a-modal>

    <div class="float-right" style="padding: 10px 0;">

      <a-pagination size="md" :show-total="total => `共 ${state.total} 条数据`" :v-model="state.total"
                    :page-size-options="state.pageSizeOptions"
                    :total="state.total"
                    show-size-changer
                    :pageSize="state.pageSize"
                    show-less-items align="right"
                    @showSizeChange="onShowSizeChange"
                    @change="onChange"
      >
        <template #buildOptionText="props">
          <span v-if="props.value !== '50'">{{ props.value }}条/页</span>
          <span v-if="props.value === '50'">全部</span>
        </template>
      </a-pagination>
    </div>


  </div>
</template>

<script>
import {defineComponent, inject, onMounted, reactive, ref} from 'vue';
import {fetchK8SCluster, k8sCluster, delK8SCluster, clusterSecret} from '../../api/k8s'
import {createFromIconfontCN} from "@ant-design/icons-vue";
import router from "../../router";

const columns = [
  {
    title: '集群名称',
    dataIndex: 'clusterName',
    slots: {customRender: 'cluster'},
  },
  {
    title: '集群版本',
    dataIndex: 'clusterVersion',
    slots: {customRender: 'ClusterVersion'}
  },
  {
    title: '节点数量',
    dataIndex: 'nodeNumber',
    slots: {customRender: 'nodeNumber'}
  },
  {
    title: '集群凭证',
    // dataIndex: 'kubeConfig',
    slots: {customRender: 'kubeConfig'},
  },
  {
    title: '创建时间',
    dataIndex: 'CreatedAt',
  },
  {
    title: '操作',
    // dataIndex: 'action',
    slots: {customRender: 'action'},
  }
];
const IconFont = createFromIconfontCN({
  scriptUrl: '//at.alicdn.com/t/font_2828790_vphs1aik0kn.js',
});
export default defineComponent({
  name: "Manage",
  setup() {
    let selectedRowKeys;
    const state = reactive({
      selectedRows: [],
      selectedRowKeys,
      loading: false,
      data: [],
      pageSize: 10,
      current: null,
      total: 0,
      pageSizeOptions: ['10', '20', '30', '40'],
      ClusterConfigVisible: false,
      ClusterConfig: undefined,
    });

    const createK8SClusterVisible = ref(false);

    let addK8SCluster = () => {
      createK8SClusterVisible.value = true;
    }

    const formRef = ref();
    const formState = reactive({
      k8sClusterName: undefined,
      k8sClusterVersion: "",
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
      // k8sClusterVersion: [
      //   {
      //     required: true,
      //     message: '请选择集群版本',
      //     trigger: 'change',
      //   },
      // ],
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
            k8sCluster({
              "clusterName": formState.k8sClusterName,
              "kubeConfig": formState.k8sClusterConfig,
              "clusterVersion": formState.k8sClusterVersion
            }).then(res => {
              if (res.errCode === 0) {
                message.success(res.msg)
                createK8SClusterVisible.value = false;
                resetForm()
                getK8SCluster()
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
    // 获取集群信息
    const getK8SCluster = async (pageSize) => {
      const {data} = await fetchK8SCluster({size: pageSize})
      state.data = data.data
      state.total = data.total
      state.pageSize = data.pageSize
    }
    // 翻页
    const onChange = async (pageNumber) => {
      fetchK8SCluster({
        page: pageNumber,
        size: state.pageSize
      }).then(res => {
        if (res.errCode === 0) {
          state.data = res.data.data
          state.total = res.data.total
          state.pageSize = res.data.pageSize
        }
      });

    };
    // 显示条数
    const onShowSizeChange = async (current, pageSize) => {
      const {data} = await fetchK8SCluster({
        size: pageSize,
      })
      state.data = data.data
      state.total = data.total
      state.pageSize = data.pageSize
      state.current = 1
    };

    const rowSelection = {
      onChange: (selectedRowKeys, selectedRows) => {
        state.selectedRows = selectedRows
        state.selectedRowKeys = selectedRowKeys
      },
    };
    // 批量删除集群
    const removeCluster = async () => {
      let clusterIds = [];
      for (let i=0; i < state.selectedRowKeys.length; i++){
        clusterIds.push(state.selectedRowKeys[i])
      }
      await delK8SCluster({"clusterIds": clusterIds}).then(res => {
        if (res.errCode === 0){
          message.success(res.msg)
          getK8SCluster()
        }else {
          message.error(res.errMsg)
        }
      });

    };
    // 查看集群凭证
    const ViewClusterConfig = (text, id) => {
      clusterSecret({'clusterId': id}).then(res => {
        if (res.errCode === 0){
          state.ClusterConfig = res.data.secret
          state.ClusterConfigVisible = true
        }else {
          message.error("获取集群凭证失败")

        }
      })

      // state.ClusterConfig = text

    }
    // 查看集群详情
    const clusterDetail = (text, id) => {
      router.push({path: `/k8s/cluster/detail/${id}`})
    }
    onMounted(getK8SCluster)


    return {
      columns,
      state,

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

      onShowSizeChange,
      onChange,
      rowSelection,
      removeCluster,
      ViewClusterConfig,
      clusterDetail,
    };
  },
  components: {
    IconFont,
  }
});
</script>

<style>

</style>