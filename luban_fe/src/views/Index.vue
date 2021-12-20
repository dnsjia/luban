<template>
  <div>
    <a-row :gutter="16">
      <a-col :span="6">
          <a-card :loading="dashLoading" :hoverable="true" style="height: 120px;border-radius:8px;background-color: rgb(72, 209,141);">
            <div class="ant-statistic-title" style="color: white">主机</div>
            <div class="ant-statistic-content" style="color: white">
                <span class="ant-statistic-content-value">
                    <span class="ant-statistic-content-value-int">{{ serverCount }}</span>
                </span>
              <span class="ant-statistic-content-suffix">台</span></div>
          </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :loading="dashLoading" :hoverable="true" style="height: 120px;border-radius:8px;background-color: rgb(249, 89, 89)">
          <div class="ant-statistic-title" style="color: white">作业</div>
          <div class="ant-statistic-content" style="color: white">
                <span class="ant-statistic-content-value">
                    <span class="ant-statistic-content-value-int">{{ jobCount }}</span>
                </span>
            <span class="ant-statistic-content-suffix">个</span></div>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :loading="dashLoading" :hoverable="true" style="height: 120px;border-radius:8px;background-color: rgb(133,149,244)">
          <div class="ant-statistic-title" style="color: white">应用</div>
          <div class="ant-statistic-content" style="color: white">
                <span class="ant-statistic-content-value">
                    <span class="ant-statistic-content-value-int">{{ appsCount }}</span>
                </span>
            <span class="ant-statistic-content-suffix">个</span></div>
        </a-card>
        <br></a-col>
      <a-col :span="6">
        <a-card :loading="dashLoading" :hoverable="true" style="height: 120px;border-radius:8px;background-color: rgb(254,187,80)">
          <div class="ant-statistic-title" style="color: white">部署</div>
          <div class="ant-statistic-content" style="color: white">
                <span class="ant-statistic-content-value">
                    <span class="ant-statistic-content-value-int">{{ deployCount }}</span>
                </span>
            <span class="ant-statistic-content-suffix">次</span></div>
        </a-card>
        <br></a-col>
    </a-row>

      <a-row :gutter="2">
        <a-col :span="24">
          <a-card :hoverable="true" :bordered="false" title="一周部署情况">
            <div id="chars" ></div>
          </a-card>
        </a-col>
      </a-row>
  </div>
</template>

<script>
import { getCountChart, getDeployChart } from "../api/dashboard";
import { Chart } from '@antv/g2';
import {onMounted} from "vue";
import {message} from "ant-design-vue";

export default {
  name: "Index",
  setup(){
    // getCountChart()
    // getDeployChart()
    onMounted(() => {
      const data = [
        { id:1, days: '2020-10-01', deploy_status: '部署成功', count: 7 },
        { id:2, days: '2020-10-01', deploy_status: '部署失败', count: 2 },
        { id:3, days: '2020-10-02', deploy_status: '部署成功', count: 11 },
        { id:4, days: '2020-10-02', deploy_status: '部署失败', count: 1 },
        { id:5, days: '2020-10-03', deploy_status: '部署成功', count: 3 },
        { id:6, days: '2020-10-03', deploy_status: '部署失败', count: 4 },
        { id:7, days: '2020-10-04', deploy_status: '部署成功', count: 14 },
        { id:8, days: '2020-10-04', deploy_status: '部署失败', count: 8 },
        { id:9, days: '2020-10-05', deploy_status: '部署成功', count: 18 },
        { id:10, days: '2020-10-05', deploy_status: '部署失败', count: 11 },

      ];

      const chart = new Chart({
        // type: 'line',
        container: 'chars',
        autoFit: true,
        height: 400,
      });
      chart.data(data);
      chart.scale({
        days: {
          range: [0, 1],
        },
        count: {
          nice: true,
        },
      });
      chart.tooltip({
        showCrosshairs: true,
        shared: true,
      });
      chart
          .area()
          .adjust('stack')
          .position('days*count')
          .color('deploy_status');
      chart
          .point()
          .adjust('stack')
          .position('days*count')
          .color('deploy_status');
      chart.render();
    })
    return {
      data: [],
      serverCount: 0,
      jobCount: 0,
      appsCount: 0,
      deployCount: 0,
      dashLoading: false,
      oneLoading: false,
      chart: '',
    }
  },
  methods: {
    // 获取统计数据
    async getCountChart() {
      const res = await getCountChart()
      if (res.errcode === 0){
        this.serverCount = res.data.server_count
        this.jobCount = res.data.job_count
        this.appsCount = res.data.apps_count
        // this.virtualHostCount = res.data.virtual_host
        this.deployCount = res.data.deploy_count
        this.dashLoading = false
      } else{
        message.error(res.errmsg, 5)
      }

    },
    async getDeployChart(){
      // 请求一周部署接口
      const res = await getDeployChart()
      if (res.errcode === 0) {
        //console.log(res.data, 356)
        this.data = [
        ];
        this.oneLoading = false
        //this.chart.changeData(this.data.data)
        // 重新渲染图表
        this.chart.data(this.data)
        this.chart.render();
      } else {
        message.error(res.errmsg)
      }
    }
  },




}




</script>

<style scoped>

</style>