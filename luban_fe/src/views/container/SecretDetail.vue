<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.secretData.objectMeta.name" @back="() => $router.go(-1)"
                   v-if="data.secretData.objectMeta">
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>基本信息</h4>
        </div>
      </div>
      <table class="table-default-viewer">
        <tbody>
        <tr>
          <td style="width: 50%">
            <span>名称</span>
            <span class="margin-right">: </span>
            <span>{{ data.secretData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">: </span>
            <span>{{ data.secretData.objectMeta.namespace }}</span>
          </td>
        </tr>

        <tr>
          <td style="width: 50%">
            <span>创建时间</span>
            <span class="margin-right">: </span>
            <span>{{ $filters.fmtTime(data.secretData.objectMeta.creationTimestamp) }}</span>
          </td>
          <td colspan="2">
            <span>标签</span>
            <span class="margin-right">: </span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
              <a-tag v-for="(label_k, label_v, index) in data.secretData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
            </span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span>注解</span>
            <span class="margin-right">: </span>
              <!-- 自动换行适应宽度 -->
              <div style="width:100%;white-space:normal;word-wrap:break-word;word-break:break-all;"
                   v-for="(label_k, label_v, index) in data.secretData.objectMeta.annotations" :key="index">
                {{ label_v }}: {{ label_k }}
              </div>
          </td>

        </tr>
        </tbody>
      </table>
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>配置数据</h4>
        </div>
      </div>
      <table class="table-default-viewer">
        <tbody>
        <th>
          <div>键</div>
        </th>
        <th>
          <div>值</div>
        </th>
        <template v-for="(map_v, map_k, i) in data.secretData.data" :key="i">
          <tr>

            <td style="width: 20%">
              <div>{{map_k}}</div>
            </td>
            <td colspan="2">
              <div style="width:600px;word-wrap:break-word" :class="map_k">
                <a-tooltip title="显示保密字典内容" placement="bottom"
                           :overlayStyle="{'font-size': '12px', 'max-width': '400px'}" @click="showSecretClick(map_k, i)">
                  <svg class="icon">
                    <use  xlink:href="#luban-icon-yanjing">{{map_v}}</use>
                  </svg>
                </a-tooltip>
              </div>

              <div style="width:600px;word-wrap:break-word;display:none" :class="map_k + i">
                <a-tooltip title="隐藏保密字典内容" placement="bottom"
                           :overlayStyle="{'font-size': '12px', 'max-width': '400px'}" @click="hiddenSecretClick(map_k, i)">
                  <svg class="icon">
                    <use  xlink:href="#luban-icon-bukejian">{{map_v}}</use>
                  </svg>
                </a-tooltip>
                {{map_v}}
              </div>

            </td>
          </tr>
        </template>
        </tbody>
      </table>
      <br/>
    </a-page-header>
  </div>
</template>

<script>
import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {GetStorage} from "../../plugin/state/stroge";
import {SecretDetail} from "../../api/k8s";
export default {
  name: "SecretDetail",
  setup() {
    const data = reactive({
      secretData: [],
    })
    const message = inject('$message');
    let router = useRoute()
    const detail = (params) => {
      let cs = GetStorage()
      SecretDetail(cs.clusterId, params).then(res => {
        if (res.errCode === 0){
          data.secretData = res.data
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const showSecretClick = (map_k, i) => {
      const show = document.getElementsByClassName(map_k)
      show[0].style.display = "none";

      const hidden = document.getElementsByClassName(map_k + i)
      hidden[0].style.display = "";
    }
    const hiddenSecretClick = (map_k, i) => {
      const show = document.getElementsByClassName(map_k)
      show[0].style.display = "";

      const hidden = document.getElementsByClassName(map_k + i)
      hidden[0].style.display = "none";
    }
    onMounted(() => {
      detail(router.query);
    });
    return {
      data,
      detail,
      showSecretClick,
      hiddenSecretClick,
    }
  }
}
</script>

<style scoped>
.table-viewer-header .table-viewer-topbar-title {
  font-size: 14px;
  color: #333333;
  display: inline-block;
  margin-left: 16px;
}
.table-default-viewer {
  width: 100%;
  background-color: #FFF;
}
.table-default-viewer td {
  padding: 11px 20px;
  border: 1px solid #eeeeee;
}

.console-sub-title.custom-sub-title {
  border: 0;
  background: none;
  /*border-top: 1px solid #ccc;*/
  margin-top: 10px;
  padding-top: 10px;
  padding-bottom: 10px;
}
</style>