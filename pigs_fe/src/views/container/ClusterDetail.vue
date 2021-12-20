<template>
  <div>
    <a-tabs v-model:activeKey="state.activeKey" style="background-color: #fff;height: 100%; ">
      <a-tab-pane key="1" tab="集群概览">
        <a-row>
          <a-col :span="8" style="text-align: center">
            <a-card size="small" title="CPU信息" style="left: 5px;width: 96%" >
              <a-space>
                <a-spin :spinning="state.loading"/>
                <div id="cpuContainer"></div>
              </a-space>
            </a-card>

            <a-space>
              <a-card size="small" title="Used" style="width: 261px; height: 80px;margin-left: -11px">
                <p>
                  <span style="color: green">{{ state.data.cpu_core }}</span>
                  <span> Core</span>
                </p>
              </a-card>
              <br>
              <a-card size="small" title="Total" style="width: 261px; height: 80px">
                <p>
                  <span style="color: green">{{ state.data.cpu_capacity_core }}</span>
                  <span> Core</span>
                </p>
              </a-card>
            </a-space>

          </a-col>


          <a-col :span="8" style="text-align: center">
            <a-card size="small" title="节点状态" style="height: 360px;width: 96%">
              <a-space style="">
                <span v-if="state.data.ready>0">正常：{{ state.data.ready }}</span>
                <span v-if="state.data.unready>0" style="color: red">异常：{{ state.data.unready }}</span>
              </a-space>
              <a-spin :spinning="state.loading"/>
              <div id="container"></div>
            </a-card>
          </a-col>

<!--          <a-col :span="6">-->
<!--            <a-card size="small" title="统计信息" style="height: 360px">-->
<!--&lt;!&ndash;              <template #extra></template>&ndash;&gt;-->
<!--              <p>Nodes：{{ state.data.node_count }}</p>-->
<!--              <p>Namespaces：{{ state.data.namespace }}</p>-->
<!--              <p>Deployments：{{ state.data.deployment }}</p>-->
<!--              <p>Pods：{{ state.data.pod }}</p>-->

<!--              <br>-->
<!--            </a-card>-->
<!--          </a-col>-->

          <a-col :span="8" style="text-align: center">
            <a-card size="small" title="内存信息" style="left: 12px; width: 96%">
              <a-space>
                <a-spin :spinning="state.loading"/>
                <div id="memContainer"></div>
              </a-space>
            </a-card>

            <a-space>
              <a-card size="small" title="Used" style="width: 265px; height: 80px; left: 5px">
                <p>
                  <span style="color: green">{{ state.data.memory_used }}</span>
                  <span> G</span>
                </p>
              </a-card>
              <a-card size="small" title="Total" style="width: 265px; height: 80px">
                <p>
                  <span style="color: green">{{ state.data.memory_total }}</span>
                  <span> G</span>
                </p>
              </a-card>
            </a-space>

          </a-col>

        </a-row>

        <br/>
        <div style="margin-left: 15px; margin-right: 15px">
          <h4 style="font-weight: bold;margin-left: 20px">事件</h4>
          <a-spin :spinning="state.eventLoading">
            <a-table :columns="columns" :data-source="state.eventsData" size="middle">
              <template #type="text">
                <span v-if="text.text=='Warning'" style="color: orange">
                  {{ text.text }}
                </span>
                <span v-else>
                  {{ text.text }}
                </span>
              </template>

              <template #lastTimestamp="text">
                <span>
                  {{ $filters.fmtTime(text.text) }}
                </span>
              </template>

            </a-table>
          </a-spin>
        </div>

        <br/>
      </a-tab-pane>
<!--      <a-tab-pane key="2" tab="Tab 2" force-render>Content of Tab Pane 2</a-tab-pane>-->
<!--      <a-tab-pane key="3" tab="Tab 3">Content of Tab Pane 3</a-tab-pane>-->
    </a-tabs>

  </div>
</template>

<script>
import {onMounted, reactive, defineComponent} from "vue";
import {useRoute} from "vue-router";
import {Gauge, Liquid, measureTextWidth} from '@antv/g2plot';
import {getK8SClusterDetail, getEvents} from "../../api/k8s";

const columns = [
  {
    title: '类型',
    dataIndex: 'type',
    key: 'type',
    slots: {
      customRender: 'type',
    },
    width: 120,
  },
  {
    title: '对象',
    dataIndex: 'involvedObject.kind',
    key: 'involvedObject.kind',
    width: 120,
  },
  {
    title: '信息',
    dataIndex: 'message',
    key: 'message',
    ellipsis: true,
  },
  {
    title: '内容',
    dataIndex: 'reason',
    key: 'reason',
  },
  {
    title: '来源',
    dataIndex: 'involvedObject.name',
    key: 'involvedObject.name',
  },
  {
    title: '时间',
    dataIndex: 'lastTimestamp',
    key: 'lastTimestamp',
    width: 180,
    slots: {
      customRender: 'lastTimestamp',
    },
  },
];
export default defineComponent({
  name: "ClusterDetail",
  setup() {
    const state = reactive({
      id: "",
      activeKey: "1",
      data: "",
      eventsData: [],
      loading: true,
      eventLoading: true,
    });

    const route = useRoute()

    const events = (data) => {

      getEvents(data).then(res => {
        if (res.errCode === 0) {
          state.eventsData = res.data.items
          state.eventLoading = false
        }
      })
    }

    onMounted(() => {
      state.id = route.params.id
      state.loading = true
      getK8SClusterDetail({'clusterId':state.id}).then(res => {
        if (res.errCode === 0) {
          state.data = res.data
          state.loading = false
          // 计算百分比
          // this.state.NodeRunningStatus = (res.data.node_count / res.data.node_count) - ( res.data.unready / 100 )
          // this.state.cpuUsage = res.data.cpu_usage / 100
          // this.state.memoryUsage = res.data.memory_usage / 100

          const gauge = new Gauge('container', {
            percent: (state.data.node_count / state.data.node_count) - (state.data.unready / 100),
            range: {
              color: '#1890ff',
            },
            startAngle: Math.PI,
            endAngle: 2 * Math.PI,
            indicator: null,
            width: 274,
            height: 180,
            autoFit: true,
          });
          gauge.render()

          const liquidPlot = new Liquid(document.getElementById('cpuContainer'), {
            percent: state.data.cpu_usage / 100,
            radius: 0.8,
            autoFit: true,
            width: 200,
            height: 200,
            statistic: {
              title: {
                formatter: () => 'CPU使用率',
                style: ({percent}) => ({
                  fill: percent > 0.65 ? 'white' : 'rgba(44,53,66,0.85)',
                }),
              },
              content: {
                style: ({percent}) => ({
                  fontSize: 40,
                  lineHeight: 1,
                  fill: percent > 0.65 ? 'white' : 'rgba(44,53,66,0.85)',
                }),
                customHtml: (container, view, {percent}) => {
                  const {width, height} = container.getBoundingClientRect();
                  const d = Math.sqrt(Math.pow(width / 2, 2) + Math.pow(height / 2, 2));
                  const text = `${(percent * 100).toFixed(0)}%`;
                  const textWidth = measureTextWidth(text, {fontSize: 40});
                  const scale = Math.min(d / textWidth, 1);
                  return `<div style="width:${d}px;display:flex;align-items:center;justify-content:center;font-size:${scale}em;line-height:${
                      scale <= 1 ? 1 : 'inherit'
                  }">${text}</div>`;
                },
              },
            },
            liquidStyle: ({percent}) => {
              return {
                fill: percent > 0.45 ? '#5B8FF9' : '#FAAD14',
                stroke: percent > 0.45 ? '#5B8FF9' : '#FAAD14',
              };
            },
            color: () => '#5B8FF9',
          });
          liquidPlot.render()
          const memLiquidPlot = new Liquid(document.getElementById('memContainer'), {
            percent: state.data.memory_usage / 100,
            radius: 0.8,
            autoFit: true,
            width: 200,
            height: 200,
            statistic: {
              title: {
                formatter: () => '内存使用率',
                style: ({percent}) => ({
                  fill: percent > 0.65 ? 'white' : 'rgba(44,53,66,0.85)',
                }),
              },
              content: {
                style: ({percent}) => ({
                  fontSize: 40,
                  lineHeight: 1,
                  fill: percent > 0.65 ? 'white' : 'rgba(44,53,66,0.85)',
                }),
                customHtml: (container, view, {percent}) => {
                  const {width, height} = container.getBoundingClientRect();
                  const d = Math.sqrt(Math.pow(width / 2, 2) + Math.pow(height / 2, 2));
                  const text = `${(percent * 100).toFixed(0)}%`;
                  const textWidth = measureTextWidth(text, {fontSize: 40});
                  const scale = Math.min(d / textWidth, 1);
                  return `<div style="width:${d}px;display:flex;align-items:center;justify-content:center;font-size:${scale}em;line-height:${
                      scale <= 1 ? 1 : 'inherit'
                  }">${text}</div>`;
                },
              },
            },
            liquidStyle: ({percent}) => {
              return {
                fill: percent > 0.45 ? '#5B8FF9' : '#FAAD14',
                stroke: percent > 0.45 ? '#5B8FF9' : '#FAAD14',
              };
            },
            color: () => '#5B8FF9',
          });
          memLiquidPlot.render()
        } else {
          return
        }
      })
      events({'clusterId':state.id})
    });


    return {
      state,
      columns,
    };
  },
})
</script>

<style scoped>

</style>