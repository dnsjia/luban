<template>
  <div>
    <a-row :gutter="[8]" :wrap="true">
      <a-col :span="5">
<!--      <a-col :xs="20" :md="12" :lg="8" :xl="4">-->
        <!-- 资产树形控件开始 -->
        <a-card title="资产分组">
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

      <!-- 资产列表开始 -->
      <a-col :span="19">
          <div style="padding-bottom: 18px; padding-left: 20px;">
            <a-space :size="18">
              <a-button type="primary" @click="syncECS">同步主机</a-button>
              <a-button>导入主机</a-button>
              <a-input-search
                  v-model:value="value"
                  placeholder="可按ID、主机名、IP等属性模糊搜索主机"
                  style="width: 400px"
                  @search="onSearch"/>
            </a-space>

            <!--云资产同步抽屉-->
            <a-drawer
                title="云资源同步"
                :width="420"
                :visible="visible"
                :keyboard="false"
                :closable="false"
                :maskClosable="false"
                :body-style="{ paddingBottom: '80px' }"
                :footer-style="{ textAlign: 'right' }"
                @close="onClose">
              <a-form ref="formRef" :model="form" :rules="rules" layout="vertical">
                <a-alert message="云资源同步默认会将服务器同步到Default分组，建议您在同步任务结束后，手动为主机分配分组。" type="info" show-icon /><br/>
                <a-row :gutter="16">
                  <a-col :span="24">
                    <a-form-item label="账户名称" name="name">
                      <a-input v-model:value="form.name" placeholder="请输入账户名称" />
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-row :gutter="16">
                  <a-col :span="24">
                    <a-form-item label="账户类型" name="type">
                      <a-select v-model:value="form.type" placeholder="请选择云平台">
                        <a-select-option value="aliyun">
                          <span class="svg-text">
                            <svg class="icon" aria-hidden="true" style="position:relative; top:3px;">
                              <use xlink:href="#pigs-icon-aliyun"></use>
                            </svg>&nbsp;&nbsp;阿里云
                          </span>
                          </a-select-option>
                        <a-select-option value="tencent">
                          <span class="svg-text">
                            <svg class="icon" aria-hidden="true" style="position:relative; top:3px;">
                              <use xlink:href="#pigs-icon-tengxunyun"></use>
                            </svg>&nbsp;&nbsp;腾讯云
                          </span>
                        </a-select-option>
                      </a-select>
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-row :gutter="16">
                  <a-col :span="24">
                    <a-form-item label="AccessKey ID" name="key">
                      <a-input v-model:value="form.key" placeholder="请输入AccessKey ID" />
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-row :gutter="16">
                  <a-col :span="24">
                    <a-form-item label="AccessKey Secret" name="secret">
                      <a-input v-model:value="form.secret" placeholder="请输入AccessKey Secret" />
                      <a :href="store.helpUrl" target="_blank">如何获取Key和Secret</a>
                    </a-form-item>
                  </a-col>
                </a-row>
                <a-row :gutter="16">
                  <a-col :span="24">
                    <a-form-item label="备注" name="desc">
                      <a-textarea v-model:value="form.desc" :rows="2" placeholder="请输入备注"/>
                    </a-form-item>
                  </a-col>
                </a-row><br/><br/>
                <a-row :gutter="16">
                  <a-col :span="12">
                    <div :style="{
                        position: 'absolute',
                        right: '30px',
                        bottom: 0,
                        width: '100%',
                        padding: '10px 16px',
                        textAlign: 'right',
                        zIndex: 8,}">
                      <a-button style="margin-right: 8px" type="primary" :loading="store.cloudBtnLoading" @click="cloudAccountBtn">
                        提交
                      </a-button>
                      <a-button @click="onClose">取消</a-button>
                    </div>
                  </a-col>
                </a-row>
              </a-form>
            </a-drawer>
            <!--云资产同步结束-->
          </div>
          <div style="padding-left: 20px">
            <a-table
                :rowKey='record=>record.id'
                :row-selection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
                :columns="columns"
                :data-source="store.hostData"
                :pagination="pagination"
                :loading="store.loading"
                @change="handleTableChange">

              <!-- 实例ID/名称-->
              <template #instance="instance">
                <span>
                  <div @mouseenter="onMouseoverCopyBtn($event, instance.text.uuid)" @mouseleave="onMouseoutCopyBtn($event, instance.text.uuid)" :data-instance_id="instance.text.uuid">
                    <a :href="'/cmdb/server/detail?id=' + instance.text.uuid">{{instance.text.uuid}} </a>
                      <span @click="copyText(instance.text.uuid)" :id="instance.text.uuid" style="visibility: hidden; padding-left: 6px">
                      <a-tooltip placement="rightBottom">
                        <template #title :id="instance.text.uuid">复制到剪贴板</template>
                        <CopyOutlined />
                      </a-tooltip>
                      </span>
                  </div>
                  {{instance.text.hostname}}
                </span>
              </template>
              <!-- 实例私网IP/公网IP-->
              <template #ip="ip">
                <span>
                  <div @mouseenter="onMouseoverCopyBtn($event, ip.text.private_addr)" @mouseleave="onMouseoutCopyBtn($event, ip.text.private_addr)" :data-instance_id="ip.text.private_addr">
                     {{ ip.text.private_addr }} (私网)
                      <span @click="copyText(ip.text.private_addr)" :id="ip.text.private_addr" style="visibility: hidden; padding-left: 6px">
                      <a-tooltip placement="rightBottom">
                        <template #title :id="ip.text.private_addr">复制到剪贴板</template>
                        <CopyOutlined />
                      </a-tooltip>
                      </span>
                    <br/>
                  </div>
                  <div @mouseenter="onMouseoverCopyBtn($event, ip.text.public_addr)" @mouseleave="onMouseoutCopyBtn($event, ip.text.public_addr)" :data-instance_id="ip.text.public_addr">
                    <p v-if="ip.text.public_addr">
                      <a :href="'http://'+ ip.text.public_addr" target="_blank"> {{ ip.text.public_addr }}</a> (公网)
                      <span @click="copyText(ip.text.public_addr)" :id="ip.text.public_addr" style="visibility: hidden; padding-left: 6px">
                      <a-tooltip placement="rightBottom">
                        <template #title :id="ip.text.public_addr">复制到剪贴板</template>
                        <CopyOutlined />
                      </a-tooltip>
                      </span>
                    </p>
                  </div>
                </span>
              </template>
              <!--主机状态-->
              <template #status="serverStatus">
                <span>
                  <a-badge v-if="serverStatus.text.status==='Running'" status="processing" text="运行中"/>
                  <a-badge v-else-if="serverStatus.text.status==='Stopped'" status="error" text="已停止"/>
                </span>
              </template>
              <!--系统类型-->
              <template #os_type="os">
                <span>
                  <a-tooltip :title="os.text.os">
                      <svg class="icon" aria-hidden="true">
                        <use v-if="SystemType(os.text.os)==='linux'" xlink:href="#pigs-icon-linux">{{os.text.os}}</use>
                        <use v-else-if="SystemType(os.text.os)==='windows'" xlink:href="#pigs-icon-windows-100">{{os.text.os}}</use>
                        <use v-else-if="SystemType(os.text.os)==='aliyun'" xlink:href="#pigs-icon-alinuxAliyunLinux2">{{os.text.os}}</use>
                        <use v-else-if="SystemType(os.text.os)==='alibaba'" xlink:href="#pigs-icon-aliyun">{{os.text.os}}</use>
                        <use v-else-if="SystemType(os.text.os)==='centos'" xlink:href="#pigs-icon-centos">{{os.text.os}}</use>
                        <use v-else-if="SystemType(os.text.os)==='ubuntu'" xlink:href="#pigs-icon-ubuntu">{{os.text.os}}</use>
                        <use v-else-if="SystemType(os.text.os)==='debian'" xlink:href="#pigs-icon-Debian">{{os.text.os}}</use>
                      </svg>
                  </a-tooltip>
                </span>
              </template>
              <!--机器配置-->
              <template #server_configure="vm">
                <span style="padding-top: -20px">
                  {{ vm.text.cpu }} vCPU {{ $filters.aliyunEcsMemory(vm.text.memory) }} <br/>
                  {{vm.text.bandwidth}} Mbps (带宽)
                </span>
              </template>
              <!-- 实例付费方式 -->
              <template #vm_expired_time="expired_time">
                <span>
                  {{formatDate(expired_time.text.vm_expired_time)}}
              </span>
              </template>
              <!--操作-->
              <template #action="action">
                <a @click="RemoteConnection(action.text.uuid)">远程连接</a>
                <a-divider type="vertical"/>
                <a-dropdown>
                  <a class="ant-dropdown-link" @click.prevent>更多<DownOutlined /></a>
                  <template #overlay>
                    <a-menu>
                      <a-menu-item key="0" disabled>屏幕截图
                        <a target="_blank" href=""></a>
                      </a-menu-item>
                      <a-menu-item key="1" disabled>系统日志
                        <a target="_blank" href="http://www.taobao.com/"></a>
                      </a-menu-item>
                      <a-menu-divider />
                      <a-menu-item key="2" disabled>诊断健康状态</a-menu-item>
                    </a-menu>
                  </template>
                </a-dropdown>
              </template>
            </a-table>
          </div>
          <!-- 资产列表结束 -->
        </a-col>
    </a-row>
    <!--翻页-->
    <template>
      <h2>test</h2>
      <div class="float-right" style="padding: 10px 0;">
        <a-button type="primary" danger :disabled="!hasSelected" :loading="loading" @click="start">删除</a-button>
        <span style="margin-left: 8px">
                  <template v-if="hasSelected">
                    {{ `Selected ${selectedRowKeys.length} items` }}
                  </template>
                </span>
      </div>
    </template>
  </div>
</template>

<script>
import {
  QuestionCircleOutlined,
  DownOutlined,
  CopyOutlined,
} from "@ant-design/icons-vue";


import {onBeforeMount, onMounted, computed, reactive, ref, watch, toRefs} from 'vue';
import { cloneDeep } from 'lodash-es';
import {getGroup} from "../../api/group";
import {getHost} from "../../api/cmdb/ecs";
import {CloudAccount} from "../../api/cloud/account"

import Moment from 'moment'
import {message} from "ant-design-vue";

const columns = [
  {
    title: '实例ID/名称',
    // dataIndex: 'uuid',
    key: 'uuid',
    slots: {customRender: 'instance'}
  },
  {
    // title: '系统',
    // dataIndex: 'os_type',
    key: 'os_type',
    slots: {customRender: 'os_type'}
  },
  {
    title: '区域',
    dataIndex: 'region',
    key: 'region',
  },
  {
    title: 'IP地址',
    // dataIndex: 'private_addr',
    key: 'private_addr',
    slots: {customRender: 'ip'},
  },
  {
    title: '状态',
    // dataIndex: 'status',
    key: 'status',
    slots: {customRender: 'status'},
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
    title: '配置',
    // dataIndex: 'cpu',
    key: 'cpu', // memory
    slots: {customRender: 'server_configure'},
  },
  {
    title: '到期时间',
    // dataIndex: 'instance_charge_type', // expired_time
    key: 'vm_expired_time',
    slots: {customRender: 'vm_expired_time'}
  },
  {
    title: '操作',
    key: 'action',
    slots: {customRender: 'action'},
  },
];

export default {
  name: "Index",
  setup() {
    let store = reactive({
      treeData: [],
      hostData: [],
      selectedRowKeys: [],
      loading: false,
      helpUrl: "https://github.com/small-flying-pigs/pigs",
    })

    const visible = ref(false);
    const syncECS = () => {
      visible.value = true;
    };
    const formRef = ref();
    const form = reactive({
      name: null,
      type: undefined,
      key: null,
      secret: null,
      desc: null,
    });
    const rules = {
      name: [{
        required: true,
        message: '请输入账户名称',
      }],
      type: [{
        required: true,
        message: '请选择账户类型',
      }],
      key: [{
        required: true,
        message: '请输入AccessKey ID',
      }],
      secret: [{
        required: true,
        message: '请输入AccessKey Secret',
      }],
    };
    // 添加云账号
    const cloudAccountBtn = () => {
      formRef.value
          .validate()
      .then(() => {
        message.loading("正在测试云账号连通性...").then(() =>
            CloudAccount({
              "name": form.name,
              "type": form.type,
              "access_key": form.key,
              "secret_key": form.secret,
              "remark": form.desc,
            }).then(res => {
              if (res.errCode === 0){
                message.success(res.msg)
                onClose()
              } else {
                message.error(res.errMsg)
              }
            })
        )

      })


    };
    const onClose = () => {
      formRef.value.resetFields()
      visible.value = false;
    };

    onBeforeMount(() =>{

    })

    onMounted(() =>{
      getGroups()
      getHosts()
    })
    const hasSelected = computed(() => store.selectedRowKeys.length > 0);
    const start = () => {
      store.loading = true; // ajax request after empty completing

      setTimeout(() => {
        store.loading = false;
        store.selectedRowKeys = [];
      }, 1000);
    };
    const onSelectChange = selectedRowKeys => {
      console.log('selectedRowKeys changed: ', selectedRowKeys);
      store.selectedRowKeys = selectedRowKeys;
    };

    const editData = reactive({})
    // 重命名分组
    const edit = key => {
      editData[key] = cloneDeep(store.treeData.value.filter(item => key === item.key)[0])
    }
    const save = key => {
      Object.assign(store.treeData.value.filter(item => key === item.key)[0], editData[key])
      delete editData[key]
    }
    const expandedKeys = ref(["0-0", "0-0-0"]);
    const selectedKeys = ref(["0-0", "0-0-0"]);
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

    // 当分组展开时获取ecs资产列表
    watch(expandedKeys, (treeKey) => {
      console.log('expandedKeys： =======', treeKey);
    });
    // 监听资产同步form数据
    watch(form, (formData) => {
      if (formData.type === 'aliyun'){
        store.helpUrl = "https://help.aliyun.com/document_detail/175967.html"
      }else if (formData.type === 'tencent'){
        store.helpUrl = "https://console.cloud.tencent.com/capi"
      } else {
        store.helpUrl = "https://github.com/small-flying-pigs/pigs"
      }


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
    // 远程连接
    function RemoteConnection(uuid) {
      window.open("/ssh/" + uuid, "_blank")
    }
    // 判断操作系统类型
    function SystemType(os) {
      let OSName = os.toLowerCase()
      if (OSName.indexOf("centos") === 0){
        return "centos"
      }else if(OSName.indexOf("windows") === 0) {
        return "windows"
      } else if(OSName.indexOf("aliyun") === 0) {
        return "aliyun"
      } else if(OSName.indexOf("alibaba") === 0){
        return "alibaba"
      } else if(OSName.indexOf("ubuntu") === 0) {
        return "ubuntu"
      } else if(OSName.indexOf("debian") === 0) {
        return "debian"
      } else if(OSName.indexOf("suse") === 0) {
        return "suse"
      } else if(OSName.indexOf("fedora") === 0) {
        return "fedora"
      } else {
        return "linux"
      }
    }
    // 格式化阿里云ecs到期时间
    function formatDate(date) {
      return Moment(date).format('YYYY-MM-DD HH:mm')
    }
    // 鼠标移入事件监听
    function onMouseoverCopyBtn(event,value) {
      document.getElementById(value).style.visibility="visible";
    }
    // 鼠标移出事件监听
    function onMouseoutCopyBtn(event, value) {
      document.getElementById(value).style.visibility="hidden";
    }

    // 拷贝文字
    function copyText(value){
      return new Promise((resolve) => {
        let copyText = document.createElement("input");
        // 存储值
        copyText.value = value;
        // 添加子节点
        document.body.appendChild(copyText)
        copyText.select()
        document.execCommand("Copy")
        // 清空输入框
        copyText.remove()
        resolve(true)
        message.success('已复制到剪贴板');
      });
    }

    // 获取分组
    const getGroups = async () => {
      const result = await getGroup()
      if (result.errCode !== 0){
        console.log('获取资产分组失败')
      }else {
        store.treeData = result.data.treeData
      }
    }
    // 获取主机
    const getHosts = async () => {
      const result = await getHost({"treeId": 1})
      if (result.errCode !== 0){
        console.log('获取资产分组失败')
      }else {
        store.hostData = result.data
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
      RemoteConnection,
      SystemType,
      formatDate,
      onMouseoverCopyBtn,
      onMouseoutCopyBtn,
      copyText,
      hasSelected,
      ...toRefs(store),
      start,
      onSelectChange,
      visible,
      syncECS,
      form,
      rules,
      onClose,
      formRef,
      cloudAccountBtn,
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
    QuestionCircleOutlined,
    DownOutlined,
    CopyOutlined,
  },
};



</script>

<style scoped>
</style>