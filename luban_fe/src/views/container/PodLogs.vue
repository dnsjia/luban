<template>
  <div style="background-color: #FFFFFF">
    <br/>
    <a-space style="padding-left: 10px">
      Container：
      <a-select v-model:value="data.container" style="min-width: 200px; max-width: 600px" @change="handleChange">
        <a-select-opt-group label="容器">
          <a-select-option :value=k v-for="(k, index) in data.containerData" :key="index">
            {{ k }}
          </a-select-option>
        </a-select-opt-group>

        <a-select-opt-group label="初始容器">
          <a-select-option :value=k v-for="(k, index) in data.initContainerData" :key="index">
            {{ k }}
          </a-select-option>
        </a-select-opt-group>
      </a-select>
      Pod：
      <a-select v-model:value="data.pod" placeholder="请选择容器" style="min-width: 200px; max-width: 800px" @change="handleLogChange">
        <a-select-option :value=k v-for="(k, index) in data.podNameData" :key="index">
          {{ k }}
        </a-select-option>
      </a-select>

      <a-button type="primary" @click="GetLog()">刷新</a-button>
      自动刷新/1秒：<a-switch v-model:checked="data.autoRefresh" checked-children="开" un-checked-children="关" @change="refreshLog" />

    </a-space>

    <a-tooltip color="#ffffff" :overlayStyle="{'font-size': '12px', 'max-width': '400px'}" placement="bottom">
      <template #title>
          <span style="color: #666">下载日志</span>
      </template>
      <DownloadOutlined  :style="{fontSize: '26px', float: 'right', paddingRight: '20px'}" @click="downLoadLogFile()"/>
    </a-tooltip>

    <br/><br/>
    <div id="filelog-container" style="height: 600px; overflow-y: scroll; background: #404040; color: #dedede; padding: 10px;">
      <div id="viewLog" v-if="data.logData=='' || data.logData==null">
        <p>暂无日志</p>
      </div>
      <div id="viewLog" v-else>
        <div style="white-space: pre-wrap;" v-for="(log, i) in data.logData" :key="i">{{ log.content }}</div>
      </div>
    </div>
  </div>

</template>

<script>
import {defineComponent, onMounted, reactive, onUnmounted, watch} from 'vue';
import {useRoute} from "vue-router";
import {get} from "../../plugin/utils/request";
import {DownloadOutlined} from "@ant-design/icons-vue";
import { saveAs } from 'file-saver';
export default {
  name: "PodLogs",
  setup() {
    let router = useRoute()
    const data = reactive({
      containerData: [],
      initContainerData: [],
      podNameData: [],
      container: undefined,
      pod: undefined,
      logData: [],
      autoRefresh: false,
      timer: null
    })
    const GetLogSource = (params) => {
      const p = "/api/v1/k8s/log/source/" + params.namespace + "/" + params.name + "/" + params.type + "?clusterId=" + params.clusterId
      get(p, "").then(res => {
        if (res.errCode === 0) {
          data.containerData = res.data.containerNames
          data.container = res.data.containerNames[0]
          data.initContainerData = res.data.initContainerNames
          data.podNameData = res.data.podNames
          data.pod = res.data.podNames[0]
          GetLog()
        }
      })
    }
    const handleChange = value => {
      console.log(`selected ${value}`);
    };
    const handleLogChange = value => {
      data.pod = value
      GetLog()
    }
    const GetLog = () => {
      const url = "/api/v1/k8s/log/" + router.query.namespace + "/" + data.pod + "?clusterId=" + router.query.clusterId
      get(url, "").then(res => {
        if (res.errCode === 0) {
          data.logData = res.data.logs
          const div1 = document.getElementById('filelog-container')
          div1.scrollTop = div1.scrollHeight
        }
      })
    }
    const refreshLog = (value) => {
      data.autoRefresh = value
    }
    watch(()=>data.autoRefresh,()=>{
      if (data.autoRefresh) {
        createSetInterval()
      }else {
        stopSetInterval()
      }
    })
    const createSetInterval = () => {
      stopSetInterval()
      data.timer = setInterval(() => {
        const url = "/api/v1/k8s/log/" + router.query.namespace + "/" +
            data.pod + "/" + data.container + "?clusterId=" +
            router.query.clusterId +
            "&logFilePosition=end&offsetFrom=2000000000&offsetTo=2000000100&previous=false&referenceLineNum=0&referenceTimestamp=newest"
        get(url, "").then(res => {
          if (res.errCode === 0) {
            data.logData = res.data.logs
            const div1 = document.getElementById('filelog-container')
            div1.scrollTop = div1.scrollHeight
          }
        })
      }, 1000)
    }
    // 关闭轮询
    const stopSetInterval = () => {
      if (data.timer) {
        clearInterval(data.timer)
        data.timer = null
      }
    }
    const downLoadLogFile = () => {
      const url = "/api/v1/k8s/log/file/" + router.query.namespace + "/" +
          data.pod + "/" + data.container + "?clusterId=" + router.query.clusterId + "&previous=false"
      get(url, "").then(res => {
          let log = new Blob([res], {type: 'text/plain;charset=utf-8'})
          saveAs(log, data.pod + ".log")
      })
    }

    onMounted(() => {
      GetLogSource(router.query);
    })
    onUnmounted(() => {
      stopSetInterval()
    })
    return {
      handleChange,
      data,
      handleLogChange,
      GetLog,
      refreshLog,
      downLoadLogFile,
    };
  },
  components: {
    DownloadOutlined
  }

}
</script>

<style scoped>
/*.download {*/
/*  height: 200px;*/
/*  width: 200px;*/
/*  display: inline-block;*/

/*}*/
</style>