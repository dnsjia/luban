<template>
  <div>
    <a-row :gutter="16">
      <a-col :span="6">
        <a-card :loading="dashLoading" :hoverable="true" style="height: 140px">
          <div class="ant-statistic-title">主机</div>
          <div class="ant-statistic-content">
                  <span class="ant-statistic-content-value">
                      <span class="ant-statistic-content-value-int">{{ serverCount }}</span></span>
            <span class="ant-statistic-content-suffix">台</span></div>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :loading="dashLoading" :hoverable="true" style="height: 140px">
          <div class="ant-statistic-title">作业</div>
          <div class="ant-statistic-content">
                  <span class="ant-statistic-content-value">
                      <span class="ant-statistic-content-value-int">{{ jobCount }}</span></span>
            <span class="ant-statistic-content-suffix">个</span></div>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :loading="dashLoading" :hoverable="true" style="height: 140px">
          <div class="ant-statistic-title">应用</div>
          <div class="ant-statistic-content">
                  <span class="ant-statistic-content-value">
                      <span class="ant-statistic-content-value-int">{{ appsCount }}</span></span>
            <span class="ant-statistic-content-suffix">个</span></div>
        </a-card>
        <br></a-col>
      <a-col :span="6">
        <a-card :loading="dashLoading" :hoverable="true" style="height: 140px">
          <div class="ant-statistic-title">部署</div>
          <div class="ant-statistic-content">
                  <span class="ant-statistic-content-value">
                      <span class="ant-statistic-content-value-int">{{ deployCount }}</span></span>
            <span class="ant-statistic-content-suffix">次</span></div>
        </a-card>
        <br></a-col>
    </a-row>

      <a-row :gutter="2">
        <a-col :span="24">
          <a-card  title="一周部署情况" style="width: 100%">
            <div id="chars" ></div>
          </a-card>
        </a-col>

      </a-row>



  </div>
</template>

<script>
import { Chart } from '@antv/g2';
import {onMounted} from "vue";

export default {
  name: "Index",
  setup(){
    onMounted(() => {
      const data = [
        { month: 'Jan', city: 'Tokyo', temperature: 7 },
        { month: 'Jan', city: 'London', temperature: 3.9 },
        { month: 'Feb', city: 'Tokyo', temperature: 6.9 },
        { month: 'Feb', city: 'London', temperature: 4.2 },
        { month: 'Mar', city: 'Tokyo', temperature: 9.5 },
        { month: 'Mar', city: 'London', temperature: 5.7 },
        { month: 'Apr', city: 'Tokyo', temperature: 14.5 },
        { month: 'Apr', city: 'London', temperature: 8.5 },
        { month: 'May', city: 'Tokyo', temperature: 18.4 },
        { month: 'May', city: 'London', temperature: 11.9 },
        { month: 'Jun', city: 'Tokyo', temperature: 21.5 },
        { month: 'Jun', city: 'London', temperature: 15.2 },
        { month: 'Jul', city: 'Tokyo', temperature: 25.2 },
        { month: 'Jul', city: 'London', temperature: 17 },
        { month: 'Aug', city: 'Tokyo', temperature: 26.5 },
        { month: 'Aug', city: 'London', temperature: 16.6 },
        { month: 'Sep', city: 'Tokyo', temperature: 23.3 },
        { month: 'Sep', city: 'London', temperature: 14.2 },
        { month: 'Oct', city: 'Tokyo', temperature: 18.3 },
        { month: 'Oct', city: 'London', temperature: 10.3 },
        { month: 'Nov', city: 'Tokyo', temperature: 13.9 },
        { month: 'Nov', city: 'London', temperature: 6.6 },
        { month: 'Dec', city: 'Tokyo', temperature: 9.6 },
        { month: 'Dec', city: 'London', temperature: 4.8 },
      ];

      const chart = new Chart({
        container: 'chars',
        autoFit: true,
        height: 500,
      });

      chart.data(data);
      chart.scale({
        month: {
          range: [0, 1],
        },
        temperature: {
          nice: true,
        },
      });

      chart.tooltip({
        showCrosshairs: true,
        shared: true,
      });

      chart.axis('temperature', {
        label: {
          formatter: (val) => {
            return val + ' °C';
          },
        },
      });

      chart
          .line()
          .position('month*temperature')
          .color('city')
          .shape('smooth');

      chart
          .point()
          .position('month*temperature')
          .color('city')
          .shape('circle');

      chart.render();

    })

  },



}




</script>

<style scoped>

</style>