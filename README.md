<<<<<<< HEAD
# pigs
小飞猪运维平台3.0

Vue 3.x Golang 1.15.x
=======
## 项目简介

> pigs 小飞猪运维平台3.0， 本项目使用Go1.15.x、 Gin、Gorm开发， 前端使用的是Vue3+Ant Design2.2.x框架。

#### 项目依赖
https://github.com/gin-gonic/gin

https://gorm.io/gorm

https://github.com/gorilla/websocket

https://nodejs.org/

#### 使用说明
1. 安装编译
```shell script
#安装packr工具
go get -u github.com/gobuffalo/packr/packr

# 打包
packr build
or
GOOS=windows GOARCH=amd64 packr build
```

2. 启动 创建config.yaml在可执行文件同级 运行即可(例如conf/conf.yaml)
```shell script
# 数据库配置
mysql:
  user: root
  password: 123456
  urls: 127.0.0.1:3306
  db: pigs
```

#### 目前已经实现的功能
- 用户登录、钉钉扫码、LDAP
- 权限管理

#### 目前正在开发的功能
- K8S多集群管理
- 应用发布(分批发布、版本回退)
- 资产管理
- 



#### QQ群
> 有兴趣的同学可以加入我们的QQ交流群，代码会持续更新，谢谢大家的支持。 QQ群: 258130203
- 加入QQ群
- 扫二维码加群


## License
Everything is Apache License 2.0.

>>>>>>> 695df6e26757cb346bb007ae2836b1d03b723242
