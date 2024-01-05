# 更新日志
## v2.7.1
```2024-01-05```
* 优化tekton流水线界面
* 优化license授权， 移除配置文件中 "license.key"
* 新增异步任务仪表盘

## v2.7.0
```2023-07-29```

* 升级前端框架至4.x
* 重构流水线样式排版
* 增加License授权
* 流水线界面优化（全新样式）
* 流水线支持单独设置构建通知
* 应用发布支持钉钉审批流

配置文件新增
```
license:
  key: your license key
```


## v2.6.0
```2023-07-17```

* 修复删除资产分组及资产参数绑定问题
* 优化 创建凭证时对镜像ak密钥进行加密
* 优化 流水线设置对oss ak进行加密
* 新增MFA多因素认证 (开启mfa后钉钉、LDAP、用户密码登录时需要二次验证)
* 资产分组树可以创建父、子分组
* 操作审计 文件管理（上传、下载、删除、访问）日志记录
* 操作审计 用户登录日志记录
* 支持ssh客户端连接到资产服务器
* 用户连续登录失败（密码过期）、锁定账号
* 用户密码过期前邮件通知提醒用户

配置文件新增
```
sshd:
  enable: true
  addr: 0.0.0.0:18999
  key: ~/.ssh/id_rsa

smtp:
  host: "smtp.exmail.qq.com"
  # tls 465, default 25
  port: 465
  user: ""
  pass: ""
  from: ""
  tls: true
  insecure-skip-verify: true
```
SQL
```SQL
本次版本变更SQL如下
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (8, '创建资产分组', '0', '/api/v1/cmdb/host/group', 'POST');

CREATE TABLE `system_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `mfa` tinyint(1) DEFAULT '0' COMMENT '是否启用mfa多因素认证',
  `login_fail` bigint(20) DEFAULT '3' COMMENT '限制登录失败次数',
  `lock_time` bigint(20) DEFAULT '60' COMMENT '登录锁定时间(分钟)',
  `password_expire` bigint(20) DEFAULT '-1' COMMENT '密码过期时间(天)、-1密码永不过期',
  PRIMARY KEY (`id`),
  KEY `idx_system_settings_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `system_settings` (`id`, `created_at`, `updated_at`, `deleted_at`, `mfa`, `login_fail`, `lock_time`, `password_expire`) VALUES ('1', '2023-07-06 17:54:09', '2023-07-06 17:54:44', NULL, '0', '3', '60', '-1');

ALTER TABLE users ADD mfa_secret TEXT COMMENT 'mfa密钥';
ALTER TABLE users CHANGE nick_name  nickname varchar(128);
ALTER TABLE users ADD password_updated datetime DEFAULT NULL;
UPDATE users SET password_updated = CURRENT_TIMESTAMP();


INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (162, '系统安全设置', '0', '/api/v1/system/safe/settings', 'POST');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (162, '获取系统安全设置', '0', '/api/v1/system/safe/settings', 'GET');

CREATE TABLE `file_operation_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `username` varchar(191) DEFAULT NULL,
  `path` varchar(128) DEFAULT NULL COMMENT '访问路径',
  `method` varchar(191) DEFAULT NULL COMMENT '操作方法（访问、下载、删除、上传）',
  `instance_id` varchar(191) DEFAULT NULL COMMENT '实例id',
  `instance_ip` varchar(191) DEFAULT NULL COMMENT '实例ip',
  `credential_id` varchar(191) DEFAULT NULL COMMENT '实例连接凭证id',
  `cluster_id` bigint(20) DEFAULT NULL COMMENT 'k8s集群id外键',
  `container` varchar(128) DEFAULT NULL COMMENT '容器名称',
  `pod_name` varchar(191) DEFAULT NULL,
  `namespace` varchar(128) DEFAULT NULL COMMENT '命名空间',
  `client_ip` varchar(128) DEFAULT NULL COMMENT '客户端ip',
  `ip_location` varchar(128) DEFAULT NULL COMMENT 'ip所在地',
  `user_agent` varchar(128) DEFAULT NULL COMMENT '浏览器标识',
  `audit_type` varchar(191) DEFAULT NULL COMMENT '审计类型(vm虚拟机、container容器)',
  PRIMARY KEY (`id`),
  KEY `idx_file_operation_log_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (212, '获取文件管理操作记录', '0', '/api/v1/audit/filemanage', 'GET');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (212, '批量删除文件管理操作记录', '0', '/api/v1/audit/filemanage', 'DELETE');

CREATE TABLE `user_login_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `username` varchar(191) DEFAULT NULL,
  `login_type` varchar(191) DEFAULT NULL COMMENT '登录方式',
  `client_ip` varchar(128) DEFAULT NULL COMMENT '客户端ip',
  `ip_location` varchar(128) DEFAULT NULL COMMENT 'ip所在地',
  `user_agent` varchar(128) DEFAULT NULL COMMENT '浏览器标识',
  `reason` varchar(500) DEFAULT NULL COMMENT '原因',
  `status` varchar(10) DEFAULT NULL COMMENT '登录状态(成功success、失败fail)',
  PRIMARY KEY (`id`),
  KEY `idx_user_login_logs_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (212, '获取用户登录记录', '0', '/api/v1/audit/login', 'GET');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (212, '批量删除用户登录记录', '0', '/api/v1/audit/login', 'DELETE');
```

## v2.5.0
```2023-04-11```

* 新增中转网关支持连接windows、linux
* 新增windows远程文件管理
* 新增操作审计支持windows录像回放
* 新增云资产同步对ak进行加密存储
* 修复远程终端空闲退出未记录审计日志
* 优化终端文件管理使用流返回文件
* 优化资产授权展示ecs可用区region
* 优化流水线构建速度
* 其他细节优化：webssh终端展示不同云账户、认证方式等

配置文件新增
```
guacamole:
  # guacd is server-side proxy
  guacd-addr: 'luban-guacd:4822'
  # 存储传输文件的目录
  drive-path: '/tmp/luban/files'
  # 会话录制
  recording-path: '/tmp/luban/recording'
  # 文本会话记录
  typescript-path: '/tmp/luban/text-recording'
```

SQL
```SQL
本次版本变更SQL如下
ALTER TABLE `ssh_record` ADD `protocol` VARCHAR(10) COMMENT '连接协议(rdp、ssh)';
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (212, '查看windows录像回话', '0', '/api/v1/audit/rdp/records/:sessionId', 'GET');

```

## v2.4.0
```2023-03-20```

* 流水线新增k8s应用部署插件，可部署(Deployment、StatefulSet、ConfigMap、Secret、Service、Ingress) 资源
* webssh连接支持选择主机公网或私网IP进行连接
* 应用发布支持阿里云ACR企业版镜像仓库
* 优化钉钉扫码登录
* 优化首页Dasborad图表
* 优化cmdb同步资产无公网IP时获取弹性IP
* 修复批量删除应用失败问题
* 移除配置文件中飞书相关配置项
- 初始用户admin/luban123. 全量更新SQL: https://docs.dnsjia.com/upgrade/sql/v2.4.0.sql


```SQL
本次版本变更SQL语句如下 (若导入全量SQL可忽略以下语句)：

DROP TABLE IF EXISTS `relation_virtual_machines_tags`;
CREATE TABLE `relation_virtual_machines_tags` (
  `virtual_machine_id` bigint(20) NOT NULL COMMENT '自增编号',
  `tags_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`virtual_machine_id`,`tags_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `cloud_platform` DROP `type`;
ALTER TABLE `cloud_platform` DROP `status`;
ALTER TABLE `cloud_platform` DROP `msg`;
ALTER TABLE `cloud_platform` DROP `sync_time`;
ALTER TABLE `cloud_virtual_machine` ADD INDEX idx_uuid(`uuid`) USING btree;


INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (132, '批量删除环境', '0', '/api/v1/apps/envs', 'DELETE');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (2, '获取远程登录实例IP', 0, '/api/v1/cmdb/host/server/resource', 'POST');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (36, '监控', 9, NULL, NULL);
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (223, '获取Pod监控图表', 0, '/api/v1/monitoring/describeMetric', 'POST');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (131, '获取应用伸缩指标', 0, '/api/v1/apps/metric', 'POST');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (131, '获取应用伸缩实例', 0, '/api/v1/apps/autoscaling', 'GET');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (145, '获取代码分支', 0, '/api/v1/cicd/git/branches', 'GET');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (2, '远程终端', 0, '/api/v1/ws/webssh', 'GET');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (156, '获取滚动更新详情', 0, '/api/v1/cicd/deploy/rollingUpdate', 'GET');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (156, '修改应用发布暂停', 0, '/api/v1/cicd/deploy/pause', 'POST');


UPDATE `permissions` SET `method`='GET' WHERE `path`='/api/v1/cmdb/host/assets/users' AND `method`='POST';
UPDATE `casbin_rule` SET `v2`='GET' WHERE `v1`='/api/v1/cmdb/host/assets/users' AND `v2`='POST';
```

配置文件移除以下内容：
```
feishu:
  deploy: ''
  notice: ''
```

## v2.3.1
```2023-02-16```

* 优化接口操作审计,增加response响应数据
* 优化前端操作审计
* 优化流水线步骤、当更新Pipeline时删除stages步骤中的job，tekton资源没有被删除
* 优化容器集群详情接口, 移除kubeConfig字段
* 优化流水线凭证字段未加密 （对Git凭证，Docker仓库凭证进行加密）
* 优化多环境应用弹性伸缩配置
* 修复流水线构建Stages
* 修复CMDB导入主机时提示Excel格式不正确
* 修复运行流水线时如果步骤是docker build任务 传值不生效问题
* 新增自动创建表开关配置
* 新增流水线内置变量， 在docker build、shell插件可以对其引入变量
* 新增流水线Webhook触发，支持（gitlab、github）
* 新增运行流水时动态获取git仓库分支 (gitlab、github)
- 更新SQL: https://docs.dnsjia.com/upgrade/sql/v2.3.1.sql


* 流水线功能优化 (字段、表命名) 变更
```
tekton_settings 表变更为 pipeline_settings
tekton_result 表变更为 pipeline_result
tekton_secrets 表变更为 pipeline_secrets
```
#### 流水线新增内置变量
```
"LUBAN_PIPELINE_ID",
"LUBAN_APP_ID",
"LUBAN_APP_CODE",
"LUBAN_APP_ENV",
"LUBAN_CI_COMMIT_ID",
"LUBAN_DATETIME",
"LUBAN_CD_IMAGE",
"LUBAN_CD_NAMESPACE"
```

```SQL
本次版本变更SQL语句如下：

ALTER TABLE audit_events MODIFY `latency` bigint(20) DEFAULT NULL COMMENT '请求耗时(ms)';
ALTER TABLE app_image_registry ADD COLUMN `pipeline_id` bigint(20) NOT NULL COMMENT '流水线id';
ALTER TABLE tekton_secrets ADD COLUMN git_type VARCHAR (60) DEFAULT 'gitlab' COMMENT 'git仓库类型(gitlab、github)' AFTER secret_type;
ALTER table tekton_settings RENAME TO pipeline_settings;
ALTER table tekton_result RENAME TO pipeline_result;
ALTER table tekton_secrets RENAME TO pipeline_secrets;

DROP TABLE IF EXISTS `app_hpa`;
CREATE TABLE `app_hpa` (
   `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增编号',
   `created_at` datetime DEFAULT NULL,
   `updated_at` datetime DEFAULT NULL,
   `deleted_at` datetime DEFAULT NULL,
   `scale_name` varchar(191) DEFAULT NULL COMMENT '伸缩名称',
   `scale_policy` varchar(191) DEFAULT NULL COMMENT '伸缩策略',
   `scale_metric` varchar(191) DEFAULT NULL COMMENT '指标名称',
   `app_code` varchar(191) DEFAULT NULL COMMENT '应用标识',
   `creator_user` varchar(191) DEFAULT NULL COMMENT '创建人',
   `min_scale` int(11) DEFAULT NULL COMMENT '最小容器数量',
   `cpu` int(11) DEFAULT NULL COMMENT 'CPU使用率',
   `max_scale` int(11) DEFAULT NULL COMMENT '最大容器数量',
   `memory` int(11) DEFAULT NULL COMMENT '内存使用率',
   `env_id` bigint(20) DEFAULT NULL COMMENT '环境ID',
   PRIMARY KEY (`id`) USING BTREE,
   KEY `idx_deleted_at` (`deleted_at`) USING BTREE,
   KEY `idx_app_code` (`app_code`) USING BTREE 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
```



## v2.3.0
```2022-12-28```

* 容器管理新增ConfigMap、Secret配置项编辑功能
* 应用环境新增审批开关、Webhook通知（飞书、钉钉）
* 应用发布(deployment增加任务信息)
* 优化流水线任务名称，使用唯一标识符
* 优化命名空间选择后页面刷新丢失问题
* 优化集群切换，随机选择一个可用集群
* 修复容器管理命名空间资源限制、配额
* 修复集群节点数量问题
* 其他细节优化...


```SQL
本次版本变更SQL语句如下：

UPDATE deploy_history SET deploy_start_time = NULL WHERE deploy_start_time = '';
UPDATE deploy_history SET deploy_end_time = NULL WHERE deploy_end_time = '';

ALTER TABLE deploy_history MODIFY deploy_end_time datetime;
ALTER TABLE deploy_history MODIFY deploy_start_time datetime;

INSERT INTO `luban`.`permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES ('217', '2023-04-07 16:22:46', '2023-04-07 16:23:19', NULL, '104', '修改配置项', '0', '/api/v1/k8s/config/configmap', 'PUT');
INSERT INTO `luban`.`permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES ('218', '2023-04-07 16:23:10', '2023-04-07 16:23:10', NULL, '104', '修改保密字典', '0', '/api/v1/k8s/config/secret', 'PUT');
INSERT INTO `luban`.`permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES ('219', '2023-04-07 16:23:54', '2023-04-07 16:23:54', NULL, '131', '获取环境详情', '0', '/api/v1/apps/env', 'GET');
INSERT INTO `luban`.`permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES ('220', '2023-04-07 16:24:19', '2023-04-07 16:24:19', NULL, '131', '修改环境', '0', '/api/v1/apps/env', 'PUT');
INSERT INTO `luban`.`permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES ('221', '2023-04-07 16:24:34', '2023-04-07 16:24:34', NULL, '131', '批量删除环境', '0', '/api/v1/apps/envs', 'DELETE');
```

## v2.2.0
```2022-11-14```

* 流水线结合Tekton
* 容器WebSSH录像审计
* 远程终端连接支持中转网关
* 远程终端支持Windows主机连接
* 隧道转发支持TCP、HTTP，便于内网穿透
* 容器Pod支持文件管理（上传、下载）
* 优化资产目录树
* 其他细节优化...
- 更新SQL: https://docs.dnsjia.com/upgrade/sql/v2.2.0.sql


## v2.1.0
```2022-07-03```

* 弹性伸缩支持同时配置CPU、Memory指标
* 应用管理CPU、Memory使用率展示
* 应用发布(容器)支持发布暂停、恢复

## v2.0.0
```2021-11-25```

* 资产管理支持资产授权
* 支持导入主机
* 远程终端新增屏幕录像
* 远程终端支持多标签窗口
* 新增JAVA应用诊断
* 新增弹性伸缩配置HPA
* 新增应用发布功能、支持分批发布


## v1.0.0
```2021-09-29```

* 容器多集群管理
* CMDB资产管理
* 作业平台支持文件分发、命令执行
* 支持Agent上报主机信息
* 新增容器监控
* 修复多容器展示问题
* 修复远程连接窗口大小适应
* 新增容器日志下载、动态刷新
* 
