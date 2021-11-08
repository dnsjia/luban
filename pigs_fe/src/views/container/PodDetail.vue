<template>
  <div style="background-color: #FFFFFF">
    <a-page-header style="border: 1px solid rgb(235, 237, 240)" :title="data.PodData.objectMeta.name" @back="() => $router.go(-1)" v-if="data.PodData.objectMeta">
      <!--      <template>-->
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
            <span class="margin-right">:</span>
            <span>{{ data.PodData.objectMeta.name }}</span>
          </td>
          <td>
            <span>命名空间</span>
            <span class="margin-right">:</span>
            <span>{{ data.PodData.objectMeta.namespace }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>状态</span>
            <span class="margin-right">:</span>
            <span>{{ data.PodData.podPhase }}</span>
          </td>
          <td>
            <span>创建时间</span>
            <span class="margin-right">:</span>
            <span>{{ $filters.fmtTime(data.PodData.objectMeta.creationTimestamp) }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>节点</span>
            <span class="margin-right">:</span>
            <span>{{ data.PodData.nodeName }}</span>
          </td>
          <td>
            <span>Pod IP</span>
            <span class="margin-right">:</span>
            <span>{{ data.PodData.podIP }}</span>
          </td>
        </tr>
        <tr>
          <td style="width: 50%">
            <span>QoS 等级</span>
            <span class="margin-right">:</span>
            <span>{{ data.PodData.qosClass }}</span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span>标签</span>
            <span class="margin-right">:</span>
            <span style="font-size: 12px; display: inline-block; white-space: normal; margin-bottom: 5px;" >
                    <a-tag v-for="(label_k, label_v, index) in data.PodData.objectMeta.labels" :key="index">{{ label_v }}: {{ label_k }}</a-tag>
              </span>
          </td>
        </tr>
        <tr>
          <td colspan="2" style="word-wrap:break-word;word-break:break-all;width: 200px">
            <span>注解</span>
            <span class="margin-right">:</span>
              <template style="font-size: 12px; display: block; white-space: normal; margin-bottom: 5px;"
                    v-for="(annotation_k, annotation_v, index) in data.PodData.objectMeta.annotations" :key="index">
                <a-space>
                  <a-tooltip placement="topLeft" :title="annotation_v + ':' + annotation_k" color="#ffffff" :overlayStyle="{'font-size':'12px','max-width':'400px'}">
                  <span style="background: #fafafa;border: 1px solid #d9d9d9;border-radius: 2px; margin-right: 8px;
                    padding: 0 7px;
                    font-size: 12px;
                    line-height: 20px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                    display: inline-block;
                    min-width: 40px; max-width: 400px"
                  >{{ annotation_v }}: {{ annotation_k }}
                  </span>
                  </a-tooltip>
                </a-space>
              </template>
          </td>
        </tr>
        </tbody>
      </table>
      <!-- 状态 -->
      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>现状详情</h4>
        </div>
      </div>

      <div id="components-table-demo-size">
        <a-table :columns="podStatusConditionsColumns" :data-source="data.PodData.conditions" size="middle" :rowKey="(record,index)=>{return index}" :pagination="false">

          <!-- 	更新时间 -->
          <template #lastTransitionTime="{text}">
            {{ $filters.fmtTime(text.lastTransitionTime) }}
          </template>

          <template #reason="{text}">
            <p v-if="text.reason===''">-</p>
            <p v-else>{{text.reason}}</p>
          </template>

          <template #message="{text}">
            <p v-if="text.message===''">-</p>
            <p v-else>{{text.message}}</p>
          </template>

        </a-table>
      </div>

      <div class="console-sub-title custom-sub-title top-sub clearfix">
        <div class="pull-left">
          <h4>事件信息</h4>
        </div>
      </div>

      <div>
        <a-table :columns="podEventsColumns"
                 :data-source="data.PodData.eventList.events"
                 size="middle"
                 :rowKey="(record,index)=>{return index}"
                 :pagination="false"
                 :locale="{emptyText: '可能所有事件已过期'}">
          <!-- 	更新时间 -->
          <template #lastTimestamp="{text}">
                <span class="level-assess">
                  <span> {{ $filters.fmtTime(text.lastSeen) }}</span>
                </span>
          </template>
        </a-table>
      </div>


      <a-tabs default-active-key="1" @change="podDetailTablesCallBack" v-model:activeKey="data.podDetailTableValue">
        <a-tab-pane key="1" tab="容器">
          <!--              <h3>容器 - {{ container.name }}</h3>-->
          <div style="width: 100%">
            <table class="table-default-viewer" style="margin: 0; border: none;">
              <thead>
              <tr style="background-color: #999999">
                <th style="width: 20%; padding-left: 24px">名称</th>
                <th style="padding-left: 24px">镜像</th>
                <th style="width: 10%; padding-left: 24px">端口</th>
              </tr>
              </thead>

              <template v-for="(container,i) in data.PodData.containers" :key="i">
                <tbody>
                <tr class="detail ng-hide">
                  <td>{{ container.name }}</td>
                  <td>{{ container.image }}</td>
                  <template v-if="container.ports">
                    <td>
                      <template v-for="(port, index) in container.ports" :key="index">
                        {{ port.protocol }}: {{ port.containerPort }}<br/>
                      </template>
                    </td>

                  </template>
                  <template v-else-if="container.ports===''||container.ports===null">
                    <td></td>
                  </template>
                  <br/>
                </tr>
                <tr class="detail ng-hide">
                  <td colspan="3">
                    <table class="container-table-default-viewer">
                      <tbody>
                      <tr class="detail ng-hide">
                        <td style="width: 15%">镜像拉取策略</td>
                        <td class="ng-binding">{{ container.imagePullPolicy }} </td>
                      </tr>
                      <tr class="ng-scope">
                        <td>环境变量</td>
                        <td>
                          <div v-for="(env, i) in container.env" :key="i">
                            <span class="ng-binding" style="color: red">{{ env.name }}: </span>
                            <span>{{ env.value }}</span>
                          </div>
                        </td>
                      </tr>
                      <tr class="ng-scope">
                        <td>所需资源</td>
                        <td>
                          <span class="margin-right ng-scope ng-binding" v-if="container.resource.requests && container.resource.requests.cpu">
                            CPU: {{ container.resource.requests.cpu }}
                          </span>
                          <span class="ng-scope ng-binding" v-if="container.resource.requests && container.resource.requests.memory">
                            Memory: {{ container.resource.requests.memory }}
                          </span>
                        </td>
                      </tr>
                      <tr class="ng-scope">
                        <td>资源限制</td>
                        <td>
                          <span class="margin-right ng-scope ng-binding" v-if="container.resource.limits && container.resource.limits.cpu">
                            CPU: {{ container.resource.limits.cpu }}
                          </span>
                          <span class="ng-scope ng-binding" v-if="container.resource.limits && container.resource.limits.memory">
                            Memory: {{ container.resource.limits.memory }}
                          </span>
                        </td>
                      </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
                <br/>
                </tbody>
              </template>
            </table>
          </div>
          <br/>
        </a-tab-pane>
        <a-tab-pane key="2" tab="创建来源">
          <div style="width: 100%">
            <table class="table-default-viewer" style="margin: 0; border: none;">
              <thead>
              <tr style="background-color: #999999">
                <th style="width: 20%; padding-left: 24px">名称</th>
                <th style="padding-left: 24px">类型</th>
              </tr>
              </thead>
              <tbody>
              <tr class="detail ng-hide">
                <td>{{ data.PodData.controller.objectMeta.name }}</td>
                <td>{{ data.PodData.controller.typeMeta.kind }}</td>
              </tr>
              <br/>
              </tbody>
            </table>
          </div>
        </a-tab-pane>
        <a-tab-pane key="3" tab="初始化容器">
          <div style="width: 100%">
            <table class="table-default-viewer" style="margin: 0; border: none;">
              <thead>
              <tr style="background-color: #999999">
                <th style="width: 20%; padding-left: 24px">名称</th>
                <th style="padding-left: 24px">镜像</th>
                <th style="width: 10%; padding-left: 24px">端口</th>
              </tr>
              </thead>

              <template v-for="(container,i) in data.PodData.initContainers" :key="i">
                <tbody>
                <tr class="detail ng-hide">
                  <td>{{ container.name }}</td>
                  <td>{{ container.image }}</td>
                  <template v-if="container.ports">
                    <td>
                      <template v-for="(port, index) in container.ports" :key="index">
                        {{ port.protocol }}: {{ port.containerPort }}<br/>
                      </template>
                    </td>

                  </template>
                  <template v-else-if="container.ports===''||container.ports===null">
                    <td></td>
                  </template>
                  <br/>
                </tr>
                <tr class="detail ng-hide">
                  <td colspan="3">
                    <table class="container-table-default-viewer">
                      <tbody>
                      <tr class="detail ng-hide">
                        <td style="width: 15%">镜像拉取策略</td>
                        <td class="ng-binding">{{ container.imagePullPolicy }} </td>
                      </tr>
                      <tr class="ng-scope" v-if="container.commands!=''">
                        <td>命令</td>
                        <td>
                          <a-space>
                            <span v-for="(exec_command, exec_commandIndex) in container.commands" :key="exec_commandIndex">
                              {{ exec_command }}
                            </span>
                          </a-space>
                        </td>
                      </tr>
                      <tr class="ng-scope" v-if="container.env!=''">
                        <td>环境变量</td>
                        <td>
                          <div v-for="(env, i) in container.env" :key="i">
                            <span class="ng-binding" style="color: red">{{ env.name }}: </span>
                            <span>{{ env.value }}</span>
                          </div>
                        </td>
                      </tr>
                      <tr class="ng-scope">
                        <td>所需资源</td>
                        <td>
                          <span class="margin-right ng-scope ng-binding" v-if="container.resource.requests && container.resource.requests.cpu">
                            CPU: {{ container.resource.requests.cpu }}
                          </span>
                          <span class="ng-scope ng-binding" v-if="container.resource.requests && container.resource.requests.memory">
                            Memory: {{ container.resource.requests.memory }}
                          </span>
                        </td>
                      </tr>
                      <tr class="ng-scope">
                        <td>资源限制</td>
                        <td>
                          <span class="margin-right ng-scope ng-binding" v-if="container.resource.limits && container.resource.limits.cpu">
                            CPU: {{ container.resource.limits.cpu }}
                          </span>
                          <span class="ng-scope ng-binding" v-if="container.resource.limits && container.resource.limits.memory">
                            Memory: {{ container.resource.limits.memory }}
                          </span>
                        </td>
                      </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
                <br/>
                </tbody>
              </template>
            </table>
          </div>
          <br/>
        </a-tab-pane>
        <a-tab-pane key="4" tab="存储">

        <table class="table-default-viewer" style="width: 100%;">
          <thead>
          <tr style="background-color: #999999">
            <th>名称</th>
            <th>类型</th>
            <th>详情</th>
            <th>挂载点</th>
            <th>只读</th>
          </tr>
          </thead>
          <template v-for="(containers, containersIndex) in data.PodData.containers" :key="containersIndex">
            <h3>容器 - {{ containers.name }}</h3>
            <tbody>
            <template v-for="(storage, volumeIndex) in containers.volumeMounts" :key="volumeIndex">
              <tr class="detail ng-hide" >
                <td>{{ storage.name }}</td>
                <td>
                  <div v-if="storage.volume.hostPath">hostPath</div>
                  <div v-else-if="storage.volume.persistentVolumeClaim">persistentVolumeClaim</div>
                  <div v-else-if="storage.volume.secret">secret</div>
                  <div v-else-if="storage.volume.nfs">nfs</div>
                  <div v-else-if="storage.volume.glusterfs">glusterfs</div>
                  <div v-else-if="storage.volume.emptyDir">emptyDir</div>
                  <div v-else-if="storage.volume.cephfs">cephfs</div>
                  <div v-else-if="storage.volume.configMap">configMap</div>
                </td>

                <td v-if="storage.volume.hostPath">
                  <div v-for="(path_k, path_v, path_i) in storage.volume.hostPath" :key="path_i"> {{ path_v }}: {{ path_k }}</div>
                </td>
                <td v-if="storage.volume.persistentVolumeClaim">
                  <div v-for="(path_k, path_v, path_i) in storage.volume.persistentVolumeClaim" :key="path_i"> {{ path_v }}: {{ path_k }}</div>
                </td>
                <td v-if="storage.volume.secret">
                  <div v-for="(path_k, path_v, path_i) in storage.volume.secret" :key="path_i"> {{ path_v }}: {{ path_k }}</div>
                </td>
                <td v-if="storage.volume.nfs">
                  <div v-for="(path_k, path_v, path_i) in storage.volume.nfs" :key="path_i"> {{ path_v }}: {{ path_k }}</div>
                </td>
                <td v-if="storage.volume.glusterfs">
                  <div v-for="(path_k, path_v, path_i) in storage.volume.glusterfs" :key="path_i"> {{ path_v }}: {{ path_k }}</div>
                </td>
                <td v-if="storage.volume.emptyDir">
                  <div v-for="(path_k, path_v, path_i) in storage.volume.emptyDir" :key="path_i"> {{ path_v }}: {{ path_k }}</div>
                </td>
                <td v-if="storage.volume.cephfs">
                  <div v-for="(path_k, path_v, path_i) in storage.volume.cephfs" :key="path_i"> {{ path_v }}: {{ path_k }}</div>
                </td>
                <td v-if="storage.volume.configMap">
                  <div v-for="(path_k, path_v, path_i) in storage.volume.configMap" :key="path_i"> {{ path_v }}: {{ path_k }}</div>
                </td>

                <td>{{ storage.mountPath }}</td>
                <td>{{ storage.readOnly }}</td>
                <br/>
              </tr>
            </template>
            <br/>
            </tbody>
          </template>
        </table>

        </a-tab-pane>
        <a-tab-pane key="5" tab="存活/就绪">
          <template v-for="(probe, probeIndex) in data.PodData.containers" :key="probeIndex">
            <a-card :title="probe.name + ' - 应用存活探针'" :bordered="false" v-if="probe.livenessProbe">

              <div v-if="probe.livenessProbe">
                <a-radio-group v-model:value="data.livenessProbeValue" :options="data.livenessProbe" disabled />
                <br/> <br/>
                <a-space :size="12">
                  <div>检查延迟</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.livenessProbe.initialDelaySeconds" disabled=""/>S
                  <div>检查间隔</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.livenessProbe.periodSeconds" disabled="" />S
                  <div>超时时间</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.livenessProbe.timeoutSeconds" disabled="" />S
                </a-space>
                <br/> <br/>
                <a-space :size="12">
                  <div>失败次数</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.livenessProbe.failureThreshold" disabled="" />
                  <div style="padding-right: 20px">成功次数</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.livenessProbe.successThreshold" disabled="" />
                </a-space>
                <br/><br/>

                <div v-if="probe.livenessProbe.httpGet">
                  <a-space :size="12">
                    <div>URL</div>
                    <a-input style="background-color: #fff;color: black" :default-value="probe.livenessProbe.httpGet.path" disabled="" />
                  </a-space>
                  <br/><br/>
                  <a-space :size="12">
                    <div>端口</div>
                    <a-input style="background-color: #fff;color: black" :default-value="probe.livenessProbe.httpGet.port" disabled="" />
                  </a-space>
                </div>

                <div v-else-if="probe.livenessProbe.tcpSocket">
                  <a-space :size="12">
                    <div>主机</div>
                    <a-input style="background-color: #fff;color: black" :default-value="probe.livenessProbe.tcpSocket.host" disabled="" />
                  </a-space>
                  <br/><br/>
                  <a-space :size="12">
                    <div>端口</div>
                    <a-input style="background-color: #fff;color: black" :default-value="probe.livenessProbe.tcpSocket.port" disabled="" />
                  </a-space>
                </div>

                <div v-else>
                  <a-space :size="12">
                    <div>_exec 暂未开发</div>
                  </a-space>
                  <br/><br/>
                </div>

              </div>
            </a-card>

            <a-card :title="probe.name + ' - 应用就绪探针'" :bordered="false" v-if="probe.readinessProbe">
              <div v-if="probe.readinessProbe">
                <a-radio-group v-model:value="data.readinessProbeValue" :options="data.readinessProbe" disabled />
                <br/> <br/>

                <a-space :size="12">
                  <div>检查延迟</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.readinessProbe.initialDelaySeconds" disabled="" />S
                  <div>检查间隔</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.readinessProbe.periodSeconds" disabled="" />S
                  <div>超时时间</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.readinessProbe.timeoutSeconds" disabled=""/>S
                </a-space>
                <br/> <br/>
                <a-space :size="12">
                  <div>失败次数</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.readinessProbe.failureThreshold" disabled="" />
                  <div style="padding-right: 20px">成功次数</div>
                  <a-input style="width: 80px;background-color: #fff;color: black" :default-value="probe.readinessProbe.successThreshold" disabled="" />
                </a-space>
                <br/><br/>

                <div v-if="probe.readinessProbe.httpGet">
                  <a-space :size="12">
                    <div>URL</div>
                    <a-input style="background-color: #fff;color: black" :default-value="probe.readinessProbe.httpGet.path" disabled="" />
                  </a-space>
                  <br/><br/>
                  <a-space :size="12">
                    <div>端口</div>
                    <a-input style="background-color: #fff;color: black" :default-value="probe.readinessProbe.httpGet.port" disabled="" />
                  </a-space>
                </div>
                <div v-else-if="probe.readinessProbe.tcpSocket">
                  <a-space :size="12">
                    <div>HOST</div>
                    <a-input style="background-color: #fff;color: black" :default-value="probe.readinessProbe.tcpSocket.host" disabled="" />
                  </a-space>
                  <br/><br/>

                  <a-space :size="12">
                    <div>端口</div>
                    <a-input style="background-color: #fff;color: black" :default-value="probe.readinessProbe.tcpSocket.port" disabled="" />
                  </a-space>
                </div>
                <div v-else>
                  <a-space :size="12">
                    <div>_exec 暂未开发</div>
                  </a-space>
                  <br/><br/>
                </div>
              </div>
            </a-card>
          </template>
        </a-tab-pane>
        <a-tab-pane key="6" tab="优雅上下线">
          <template v-for="(container, i) in data.PodData.containers" :key="i">
            <a-card title="PostStart配置" :bordered="false" v-if="container.lifecycle && container.lifecycle.postStart">
              <div v-if="container.lifecycle && container.lifecycle.postStart">
                <a-radio-group v-model:value="data.postStartValue" :options="data.postStart" disabled />
                <br/> <br/>
                <div class="pre-stop-exec" v-if="container.lifecycle.postStart.exec">
                  <a-space>
                     <span v-for="(exec_command, exec_commandIndex) in container.lifecycle.postStart.exec.command" :key="exec_commandIndex">
                      {{ exec_command }}
                    </span>
                  </a-space>
                </div>
                <div v-else-if="container.lifecycle.postStart.httpGet">
                  <a-space :size="12">
                    <div>URL</div>
                    <a-input :default-value="container.lifecycle.postStart.httpGet.path" disabled="" placeholder="请输入Http请求的URL"/>
                    <div>端口</div>
                    <a-input :default-value="container.lifecycle.postStart.httpGet.port" disabled="" />
                  </a-space>
                </div>
                <div v-else-if="container.lifecycle.postStart.tcpSocket">
                  <a-space :size="12">
                    <div>URL</div>
                    <a-input :default-value="container.lifecycle.postStart.tcpSocket.host" disabled="" placeholder="请输入Tcp请求的URL"/>
                    <div>端口</div>
                    <a-input :default-value="container.lifecycle.postStart.tcpSocket.port" disabled="" />
                  </a-space>
                </div>
              </div>
            </a-card>
            <br/><br/>

            <a-card title="PreStop配置" :bordered="false" v-if="container.lifecycle && container.lifecycle.preStop">
              <div v-if="container.lifecycle && container.lifecycle.preStop">
                <a-radio-group v-model:value="data.preStopValue" :options="data.preStop" disabled />
                <br/> <br/>
                <div class="pre-stop-exec" v-if="container.lifecycle.preStop.exec">

                  <a-space>
                    <span v-for="(exec_command, exec_commandIndex) in container.lifecycle.preStop.exec.command" :key="exec_commandIndex">
                      {{ exec_command }}
                    </span>
                  </a-space>
                </div>
                <div v-else-if="container.lifecycle.preStop.httpGet">
                  <a-space :size="12">
                    <div>URL</div>
                    <a-input :default-value="container.lifecycle.preStop.httpGet.path" disabled="" placeholder="请输入Http请求的URL"/>
                    <div>端口</div>
                    <a-input :default-value="container.lifecycle.preStop.httpGet.port" disabled="" />
                  </a-space>
                </div>
                <div v-else-if="container.lifecycle.preStop.tcpSocket">
                  <a-space :size="12">
                    <div>URL</div>
                    <a-input :default-value="container.lifecycle.preStop.tcpSocket.host" disabled="" placeholder="请输入Tcp请求的URL"/>
                    <div>端口</div>
                    <a-input :default-value="container.lifecycle.preStop.tcpSocket.port" disabled="" />
                  </a-space>
                </div>
              </div>

            </a-card>
            <br/><br/>

          </template>

        </a-tab-pane>

      </a-tabs>


    </a-page-header>
  </div>
</template>

<script>
const podStatusConditionsColumns = [
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '状态',
    dataIndex: 'status',
  },
  {
    title: '更新时间',
    slots: {customRender: 'lastTransitionTime'},
  },
  {
    title: '原因',
    slots: {customRender: 'reason'},
  },
  {
    title: '消息',
    slots: {customRender: 'message'},
  },
]
const podEventsColumns = [
  {
    title: '类型',
    dataIndex: 'type',
  },
  {
    title: '对象',
    dataIndex: 'objectKind',
  },
  {
    title: '信息',
    dataIndex: 'message',
    width: '900px',
  },
  {
    title: '原因',
    dataIndex: 'reason',
  },
  {
    title: '时间',
    slots: {customRender: 'lastTimestamp'},
  },
]

import {inject, onMounted, reactive} from "vue";
import {useRoute} from "vue-router";
import {PodDetail} from "../../api/k8s";


export default {
  name: "PodDetail",
  setup(){
    const message = inject('$message');
    let router = useRoute()
    const data = reactive({
      PodData: [],
      podDetailTableValue: 1,

      livenessProbe: [
        { label: 'http get', value: 'httpGet' },
        { label: 'shell script', value: 'shellScript' },
        { label: 'tcp socket', value: 'tcpSocket' },
      ],
      livenessProbeValue: '',
      readinessProbe: [
        { label: 'http get', value: 'httpGet' },
        { label: 'shell script', value: 'shellScript' },
        { label: 'tcp socket', value: 'tcpSocket' },
      ],
      readinessProbeValue: '',
      preStop: [
        { label: 'http get', value: 'httpGet' },
        { label: 'shell script', value: 'shellScript' },
        { label: 'tcp socket', value: 'tcpSocket' },
      ],
      preStopValue: '',
      postStart: [
        { label: 'http get', value: 'httpGet' },
        { label: 'shell script', value: 'shellScript' },
        { label: 'tcp socket', value: 'tcpSocket' },
      ],
      postStartValue: '',
    })
    const getPodDetail = (params) => {
      PodDetail(params).then(res => {
        if (res.errCode === 0){
          data.PodData = res.data
        }else {
          message.error(res.errMsg)
        }
      })
    }
    const podDetailTablesCallBack = val => {
      localStorage.setItem("podDetailTable", val)

      if (val === '5'){
        // 1.1 存活
        if (data.PodData.containers[0].livenessProbe){
          if (data.PodData.containers[0].livenessProbe.exec){
            data.livenessProbeValue = 'shellScript'
          }else if (data.PodData.containers[0].livenessProbe.httpGet){
            data.livenessProbeValue = 'httpGet'
          }else if (data.PodData.containers[0].livenessProbe.tcpSocket){
            data.livenessProbeValue = 'tcpSocket'
          }else {
            // 如果存活为空则说明没有配置，此时不做任何处理
            return ''
          }
        }
        // 1.2 就绪
        if (data.PodData.containers[0].readinessProbe){
          if (data.PodData.containers[0].readinessProbe.exec){
            data.readinessProbeValue = 'shellScript'
          }else if (data.PodData.containers[0].readinessProbe.httpGet){
            data.readinessProbeValue = 'httpGet'
          }else if (data.PodData.containers[0].readinessProbe.tcpSocket){
            data.readinessProbeValue = 'tcpSocket'
          }else {
            // 如果就绪为空则说明没有配置，此时不做任何处理
            return ''
          }
        }
      }else if (val === '6'){
        if (data.PodData.containers[0].lifecycle) {
          // 1.1 PostStart配置
          if (data.PodData.containers[0].lifecycle.postStart){
            if (data.PodData.containers[0].lifecycle.postStart.exec){
              data.postStartValue = 'shellScript'
            }else if (data.PodData.containers[0].lifecycle.postStart.httpGet){
              data.postStartValue = 'httpGet'
            }else if (data.PodData.containers[0].lifecycle.postStart.tcpSocket){
              data.postStartValue = 'tcpSocket'
            }
          }
          // 1.2 PreStop配置
          if (data.PodData.containers[0].lifecycle.preStop){
            if (data.PodData.containers[0].lifecycle.preStop.exec){
              data.preStopValue = 'shellScript'
            }else if (data.PodData.containers[0].lifecycle.preStop.httpGet){
              data.preStopValue = 'httpGet'
            }else if (data.PodData.containers[0].lifecycle.preStop.tcpSocket){
              data.preStopValue = 'tcpSocket'
            }
          }
        }
      }


    };


    const getWorkloadTable = () => {
      data.podDetailTableValue = localStorage.getItem("podDetailTable");
      if (data.podDetailTableValue === "" || data.podDetailTableValue === undefined) {
        data.podDetailTableValue = 1
      }
    }
    // TODO 容器组详情页面 如果有多个容器或者Init容器支持可折叠
    const podCollapse = (val) => {
      console.log(val)
    }
    onMounted(getWorkloadTable)
    onMounted(() => {
      getPodDetail(router.query);
      getWorkloadTable();
    });
    return {
      data,
      podStatusConditionsColumns,
      podEventsColumns,
      podDetailTablesCallBack,
      podCollapse,
    }
  }
}
</script>

<style >
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
.container-table-default-viewer td {
  padding: 11px 20px;
  border: 1px solid #eeeeee;
  background-color: #f9f9f9;
}
.container-table-default-viewer {
  width: 100%;
}
.margin-right, .margin-right-1 {
  margin-right: 8px !important;
}
.pull-left {
  float: left !important;
}
.custom-sub-title.top-sub {
  border-top: 0;
  margin-top: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
}
.console-sub-title.custom-sub-title {
  border: 0;
  background: none;
  /*border-top: 1px solid #ccc;*/
  margin-top: 10px;
  padding-top: 10px;
  padding-bottom: 10px;
}
.console-sub-title {
  position: relative;
  padding-left: 16px;
  margin-bottom: -1px;
  display: table;
  width: 100%;
  z-index: 1;
  height: 40px;
  border: 1px solid #E1E6EB;
  border-left: 3px solid #778;
  background-color: #F4F5F9;
}
/* 优雅上下线命令 样式 */
.pre-stop-exec {
  height: 300px;
  width: 1200px;
  overflow-y: scroll;
  background: rgb(64, 64, 64);
  color: rgb(222, 222, 222);
  padding: 10px;
}

.ant-tooltip-inner {
  color: rgb(102, 102, 102);
}
</style>