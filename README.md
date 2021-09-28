## 项目简介

> pigs 小飞猪运维平台3.0， 本项目使用Go1.15.x、 Gin、Gorm开发， 前端使用的是Vue3+Ant Design2.2.x框架。


## 使用说明
1. 安装编译
```shell script
# 拉取代码
git clone https://github.com/small-flying-pigs/pigs.git

# 打包
cd pigs
go build main.go -o ./pigs
or
GOOS=windows GOARCH=amd64 go build main.go ./pigs

# 启动
./pigs

# 启动前端
cd pigs/pigs_fe
npm run dev
```

2. 启动 创建config.yaml在可执行文件同级
```shell script
# 数据库配置
mysql:
  path: '192.168.1.96:3306'
  db-name: 'pigs'
  username: 'root'
  password: '123456'
```

#### 目前已经实现的功能
- 用户登录、LDAP
- 权限管理


## 首页
![avatar](./docs/img/登录.jpg)

## 仪表盘
![avatar](./docs/img/仪表盘.jpg)

## 集群管理
![avatar](./docs/img/集群管理.jpg)

## Features

* 用户注册登录
    * [如何配置LDAP](.)
    * [配置钉钉扫码](.)    
    

## Roadmap

> [历史版本详情](./docs/version/README.md)
> 
- K8S多集群管理
- 应用发布(分批发布、版本回退)
- 资产管理
- 作业系统
- 审批流


## Contributing

对于项目感兴趣，想一起贡献并完善项目请参阅[contributing](./CONTRIBUTING.md)。



## Support

* 参考[安装文档](docs/install/deploy-guide.md)
* 阅读 [源码](https://github.com/small-flying-pigs/pigs)
* 阅读 [wiki](https://github.com/small-flying-pigs/pigs/wiki) 或者寻求帮助
* 直接反馈[issue](https://github.com/small-flying-pigs/pigs/issues) ，我们会定期查看与答复
* 有兴趣的同学可以加入我们的QQ交流群，代码会持续更新，谢谢大家的支持。 QQ群: 258130203

## FAQ

* [小飞猪运维平台FAQ](https://github.com/small-flying-pigs/pigs/wiki)
* [文档中心] 建设中...



## License
Everything is Apache License 2.0.

