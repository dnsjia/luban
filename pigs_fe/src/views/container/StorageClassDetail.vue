<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.storageClassData.objectMeta.name" @back="() => $router.go(-1)"
                   v-if="data.storageClassData.objectMeta">

      <a-tabs>
        <a-tab-pane key="1" tab="基本信息">
          <a-card>
            <div>
              <a-descriptions title="元数据" :column="2">
                <a-descriptions-item label="名称">{{ data.storageClassData.objectMeta.name }}</a-descriptions-item>
                <a-descriptions-item label="创建时间">{{ $filters.fmtTime(data.storageClassData.objectMeta.creationTimestamp) }}</a-descriptions-item>
                <a-descriptions-item label="标签">
                  <template v-for="(v,k,i) in data.storageClassData.objectMeta.labels" :key="i">
                    <a-tag color="cyan">{{ k }}: {{ v }}</a-tag> <br/>
                  </template>
                </a-descriptions-item>
                <a-descriptions-item label="注解">
                  <template v-for="(v,k,i) in data.storageClassData.objectMeta.annotations" :key="i">
                    <template v-if="k!=='kubectl.kubernetes.io/last-applied-configuration'">
                      {{ k }}: {{ v }} <br/>
                    </template>

                  </template>
                </a-descriptions-item>
              </a-descriptions>
            </div>
          </a-card>
          <br/>
          <a-card>
            <div>
              <a-descriptions title="资源信息" :column="2">
                <a-descriptions-item label="提供者">{{ data.storageClassData.provisioner }}</a-descriptions-item>
                <a-descriptions-item label="回收策略">{{ data.storageClassData.reclaimPolicy }}</a-descriptions-item>
                <a-descriptions-item label="参数">
                  <template v-for="(v,k,i) in data.storageClassData.parameters" :key="i">
                    <a-tag color="cyan">{{ k }}: {{ v }}</a-tag> <br/>
                  </template>
                </a-descriptions-item>

              </a-descriptions>
            </div>
          </a-card>

        </a-tab-pane>
      </a-tabs>


      <a-tabs>
        <a-tab-pane key="2" tab="存储卷">
          <a-table
              :columns="pvColumns"
              :data-source="data.pvData"
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
        </a-tab-pane>
      </a-tabs>
    </a-page-header>

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
import router from "../../router";

const pvColumns = [
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
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {GetStorage} from "../../plugin/state/stroge";
import {DeletePV, StorageClassDetail} from "../../api/k8s";
import routers from "../../router";

export default {
  name: "StorageClassDetail",
  setup() {
    const data = reactive({
      storageClassData: [],
      pvData: [],
      removePVData: [],
      removeOnePVVisible: false,
    })
    const message = inject('$message');
    let router = useRoute()
    const detail = (params) => {
      let cs = GetStorage()
      StorageClassDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.storageClassData = res.data
          data.pvData = res.data.persistentVolumeList.items
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const pvDetail = (text) => {
      let cs = GetStorage()
      routers.push({
        name: 'PVDetail', query: {
          clusterId: cs.clusterId,
          name: text.objectMeta.name
        }
      });
    }
    const pvcDetail = (text) => {
      let cs = GetStorage()
      if (text.claim===''||text.claim===null){
        return
      }
      let namespace = text.claim.split("/")[0]
      let name = text.claim.split("/")[1]
      routers.push({
        name: 'PVCDetail', query: {
          clusterId: cs.clusterId,
          namespace: namespace,
          name: name
        }
      });
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
          detail(router.query)
        }else {
          message.error(res.errMsg)
        }
      })
    }
    onMounted(() => {
      detail(router.query);
    });
    return {
      data,
      detail,
      pvColumns,
      pvDetail,
      pvcDetail,
      removeOnePV,
      removeOnePVOk
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