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
      <a-col :space="2">
        <a-card :hoverable="true" :loading="oneLoading" title="一周部署情况" style="margin-top: 160px;">
          <div id="chars" style="width: 90%"></div>
        </a-card>
      </a-col>
    </a-row>

  </div>
</template>

<script>
// import { Chart } from '@antv/g2';

</script>

<style scoped>

</style>