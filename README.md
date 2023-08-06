## 项目简介

<p align="center">
  <a href="https://golang.google.cn/">
    <img src="https://img.shields.io/badge/Golang-1.17-green.svg" alt="golang">
  </a>
  <a href="https://gin-gonic.com/">
    <img src="https://img.shields.io/badge/Gin-1.7.4-red.svg" alt="gin">
  </a>
  <a href="https://gorm.io/">
    <img src="https://img.shields.io/badge/Gorm-1.21-orange.svg" alt="gorm">
  </a>
  <a href="https://redis.io/">
    <img src="https://img.shields.io/badge/redis-3.2.100-brightgreen.svg" alt="redis">
  </a>
  <a href="https://vuejs.org/">
    <img src="https://img.shields.io/badge/Vue-3.0.0-orange.svg" alt="vue">
  </a>
  <a href="https://antdv.com/docs/vue/introduce-cn/">
    <img src="https://img.shields.io/badge/Ant%20Design-2.2.x-blue.svg" alt="Ant Design">
  </a>
</p>

> LuBan 鲁班运维平台2.0， 本项目使用Go1.18.x、 Gin、Gorm开发， 前端使用的是Vue3+Ant Design4.x框架。


![avatar](./docs/img/luban.png)

## 使用说明
1. docker-compose 快速启动
```shell script
# 拉取代码
cd luban
docker-compose up -d
```

2. 启动服务前先修改etc/config.yaml

3. 导入初始化sql, 并逐步升级到最新版本
```shell
全量更新SQL: https://docs.dnsjia.com/upgrade/sql/v2.4.0.sql
升级文档: https://docs.dnsjia.com/upgrade/changelog/
```

4. 初始账号: admin  密码: luban123.

#### 目前已经实现的功能
* 用户登录
  * LDAP/Email
* 权限管理
* 用户注册登录
  * [如何配置LDAP](.)
  * [配置钉钉扫码](.)
- K8S多集群管理
  * [集群管理](.)
  * [节点管理](.)
  * [工作负载](.)
  * [存储管理](.)
  * [网络管理](.)
  * [配置管理](.)
  * [事件中心](.)

- 资产管理
  * [远程连接](.)
  * [屏幕录像](.)
  * [文件管理](.)
  * [中转网关](.)
  * [资产授权](.)
  
- 应用发布
  * [流水线结合Tekton](.)
  * [应用发布暂停/恢复](.)

- 运维工具
  * [端口转发](.)
  
- 操作审计
  * [WebSSH屏幕录像](.)
  * [Pod登录审计](.)

## 首页
![avatar](./docs/img/login.png)


## 资产管理
![avatar](./docs/img/资产管理.png)

## 文件管理
![avatar](./docs/img/终端.png)

## 远程连接
![avatar](./docs/img/远程登录.png)

## 集群管理
![avatar](./docs/img/集群管理.png)

## 集群详情
![avatar](./docs/img/集群详情.png)

## 节点列表
![avatar](./docs/img/节点.png)


## 工作负载
![avatar](./docs/img/工作负载.png)


## 容器监控
![avatar](./docs/img/容器监控.png)


## 网络管理
![avatar](./docs/img/network.png)

## 存储管理
![avatar](./docs/img/storage.png)

## 应用详情
![avatar](./docs/img/应用详情.png)

## 应用发布
![avatar](./docs/img/发布单详情.png)

## 流水线
![avatar](./docs/img/流水线.png)

## 构建历史
![avatar](./docs/img/构建历史.png)

## 伸缩配置
![avatar](./docs/img/应用伸缩.png)

## JAVA应用诊断
![avatar](./docs/img/应用诊断.png)


![avatar](./docs/img/应用诊断1.png)

## Roadmap

> [历史版本详情](./docs/version/README.md)
> 


- 审批流


## Contributing

对于项目感兴趣，想一起贡献并完善项目请参阅[contributing](./CONTRIBUTING.md)。

![img](https://www.ziji.work/gzh.jpg)

## Support

* 参考[安装文档](https://docs.dnsjia.com/getting-started/installation/)
* 阅读 [wiki](https://github.com/dnsjia/luban/wiki) 或者寻求帮助
* 直接反馈[issue](https://github.com/dnsjia/luban/issues) ，我们会定期查看与答复
* 有兴趣的同学可以加入我们的QQ群: 258130203
* 同时也欢迎大家加入Kubernetes进阶交流群：548246072


## FAQ

* [鲁班运维平台FAQ](https://github.com/dnsjia/luban/wiki)
* [文档中心](https://docs.dnsjia.com/)


## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=dnsjia/luban&type=Date)](https://star-history.com/#dnsjia/luban&Date)


## License
Everything is Apache License 2.0.

