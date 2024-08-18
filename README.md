## 项目简介
  LuBan运维平台是一个基于Go语言+Vue开发的Kubernetes多集群管理平台，可以兼容不同云厂商Kubernetes集群，同时，平台还集成CMDB资产管理。方便用户管理集群、节点等基础资源。通过使用LuBan运维平台，可以提升运维效率，降低维护成本。

<p align="center">
  <a href="https://golang.google.cn/">
    <img src="https://img.shields.io/badge/Golang-1.21-green.svg" alt="golang">
  </a>
  <a href="https://gin-gonic.com/">
    <img src="https://img.shields.io/badge/Gin-1.7.4-red.svg" alt="gin">
  </a>
  <a href="https://gorm.io/">
    <img src="https://img.shields.io/badge/Gorm-1.21-orange.svg" alt="gorm">
  </a>
  <a href="https://redis.io/">
    <img src="https://img.shields.io/badge/redis-5.0-brightgreen.svg" alt="redis">
  </a>
  <a href="https://vuejs.org/">
    <img src="https://img.shields.io/badge/Vue-3.0.0-orange.svg" alt="vue">
  </a>
  <a href="https://antdv.com/docs/vue/introduce-cn/">
    <img src="https://img.shields.io/badge/Ant%20Design-4.x-blue.svg" alt="Ant Design">
  </a>
</p>

> LuBan 鲁班运维平台2.0， 本项目使用Go1.20.x、 Gin、Gorm开发， 前端使用的是Vue3+Ant Design4.x框架。


![avatar](./docs/img/luban.png)

## 使用说明
1. docker-compose 快速启动
```shell script
# 拉取代码
git clone https://github.com/dnsjia/luban.git
cd luban
docker-compose up -d
```

2. 启动服务前先修改etc/config.yaml
```
# 如需钉钉登录，请修改以下配置项：
dingtalk:
  appid: ''
  secret: ''
  url: 'https://oapi.dingtalk.com'
  # 允许登录的邮箱后缀 test@luban.com [luban.com]
  allow-suffix: 'luban.com'
  agentId: 123456
  # 审批模版
  processCode: ''
  # 事件回调签名token
  signToken: ''
  # 事件回调加解密密钥
  aesKey: ''


# 应用部署钉钉通知
deploy:
  webhook: 'https://oapi.dingtalk.com/robot/send?access_token=your dingtalk robot token'
```

3. 导入初始化sql, 并逐步升级到最新版本
```shell
容器启动成功后，需要导入全量SQL
全量更新SQL: https://docs.dnsjia.com/upgrade/sql/v2.8.0.sql
升级文档: https://docs.dnsjia.com/upgrade/changelog/
```


4. 初始账号: admin  密码: luban123.
```
http://localhost
```

#### 目前已经实现的功能
* 用户登录
  * [LDAP/Email](.)

* 权限管理
  * [MFA认证](.)

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
  * [容器监控](.)

- 资产管理
  * [远程连接](.)
    - 支持RDP 
    - 支持SSH
    - VNC 开发中....
  * [屏幕录像](.)
  * [文件管理](.)
  * [中转网关](.)
  * [资产授权](.)
  
- 应用发布
  * [流水线结合Tekton](.)
  * [多集群应用发布](.)
  * [应用发布回退、暂停](.)
  * [发布审批](.)

- 运维工具
  * [端口转发](.)
  
- 操作审计
  * [WebSSH屏幕录像](.)
  * [Pod登录审计](.)
  * [行为审计](.)

## 首页
![avatar](./docs/img/login.png)


## 资产管理
![avatar](./docs/img/资产管理.png)

## 远程终端
![avatar](./docs/img/远程终端.png)


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
![avatar](./docs/img/网络管理.png)

## 应用管理
![avatar](./docs/img/应用管理.png)

## 应用详情
![avatar](./docs/img/应用详情.png)

## 应用发布
![avatar](./docs/img/应用发布单.png)

![avatar](./docs/img/发布单详情.png)

## 流水线
![avatar](./docs/img/流水线通知.png)


![avatar](./docs/img/流水线详情.png)

## 弹性伸缩
![avatar](./docs/img/弹性伸缩配置.png)

## JAVA应用诊断
![avatar](./docs/img/应用诊断.png)


![avatar](./docs/img/应用诊断1.png)

## Roadmap

> [历史版本详情](./docs/version/README.md)
> 


- 监控中心(告警规则、值班)
- 全链路监控
- 日志中心
- 多租户权限控制


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

