/*
Navicat MySQL Data Transfer

Source Server         : luban-demo-docker
Source Server Version : 50738
Source Host           : localhost:33060
Source Database       : luban

Target Server Type    : MYSQL
Target Server Version : 50738
File Encoding         : 65001

Date: 2023-08-06 15:34:04
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for app
-- ----------------------------
DROP TABLE IF EXISTS `app`;
CREATE TABLE `app` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `app_name` varchar(128) DEFAULT NULL COMMENT '应用名称',
  `app_code` varchar(128) DEFAULT NULL COMMENT '应用标识',
  `app_desc` varchar(128) DEFAULT NULL COMMENT '应用描述',
  `owner` json DEFAULT NULL COMMENT '应用负责人',
  `develop` json DEFAULT NULL COMMENT '开发',
  `language` varchar(191) DEFAULT NULL COMMENT '程序设计语言',
  `is_core` tinyint(1) DEFAULT NULL COMMENT '是否核心应用',
  `mesh_enable` tinyint(1) DEFAULT NULL COMMENT '启用服务网格',
  `deploy_type` varchar(191) DEFAULT NULL COMMENT '部署类型(vm、container)',
  PRIMARY KEY (`id`),
  KEY `idx_app_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of app
-- ----------------------------

-- ----------------------------
-- Table structure for app_container_envs
-- ----------------------------
DROP TABLE IF EXISTS `app_container_envs`;
CREATE TABLE `app_container_envs` (
  `app_id` bigint(20) NOT NULL COMMENT '自增编号',
  `container_env_config_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`app_id`,`container_env_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of app_container_envs
-- ----------------------------

-- ----------------------------
-- Table structure for app_deploy_envs
-- ----------------------------
DROP TABLE IF EXISTS `app_deploy_envs`;
CREATE TABLE `app_deploy_envs` (
  `app_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  `deploy_history_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  PRIMARY KEY (`app_id`,`deploy_history_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of app_deploy_envs
-- ----------------------------

-- ----------------------------
-- Table structure for app_diagnosis
-- ----------------------------
DROP TABLE IF EXISTS `app_diagnosis`;
CREATE TABLE `app_diagnosis` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `app_name` varchar(191) DEFAULT NULL COMMENT '应用名称',
  `pod_name` varchar(191) DEFAULT NULL COMMENT '容器名称',
  `pod_ip` varchar(191) DEFAULT NULL COMMENT '容器IP',
  `status` varchar(191) DEFAULT 'offline' COMMENT '状态',
  `username` varchar(191) DEFAULT NULL COMMENT '操作用户',
  `process_name` varchar(191) DEFAULT NULL COMMENT '进程',
  `namespace` varchar(191) DEFAULT NULL COMMENT '命名空间',
  PRIMARY KEY (`id`),
  KEY `idx_app_diagnosis_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of app_diagnosis
-- ----------------------------

-- ----------------------------
-- Table structure for app_hpa
-- ----------------------------
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
  KEY `idx_app_code` (`app_code`) USING BTREE,
  KEY `idx_app_hpa_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of app_hpa
-- ----------------------------

-- ----------------------------
-- Table structure for app_image_registry
-- ----------------------------
DROP TABLE IF EXISTS `app_image_registry`;
CREATE TABLE `app_image_registry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `app_code` varchar(191) DEFAULT NULL COMMENT '应用名称',
  `env` varchar(191) DEFAULT NULL COMMENT '环境标识',
  `image_id` bigint(20) DEFAULT NULL COMMENT '镜像仓库id',
  `pipeline_id` bigint(20) NOT NULL COMMENT '流水线id',
  PRIMARY KEY (`id`),
  KEY `idx_app_image_registry_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of app_image_registry
-- ----------------------------

-- ----------------------------
-- Table structure for app_virtual_machine_envs
-- ----------------------------
DROP TABLE IF EXISTS `app_virtual_machine_envs`;
CREATE TABLE `app_virtual_machine_envs` (
  `app_id` bigint(20) NOT NULL COMMENT '自增编号',
  `virtual_machine_env_config_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`app_id`,`virtual_machine_env_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of app_virtual_machine_envs
-- ----------------------------

-- ----------------------------
-- Table structure for approval
-- ----------------------------
DROP TABLE IF EXISTS `approval`;
CREATE TABLE `approval` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `env_id` bigint(20) DEFAULT NULL COMMENT '环境ID',
  `is_enabled` tinyint(1) DEFAULT '0' COMMENT '是否开启审批',
  PRIMARY KEY (`id`),
  KEY `idx_approval_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of approval
-- ----------------------------

-- ----------------------------
-- Table structure for assets_hosts
-- ----------------------------
DROP TABLE IF EXISTS `assets_hosts`;
CREATE TABLE `assets_hosts` (
  `assets_hosts_permissions_id` bigint(20) NOT NULL COMMENT '自增编号',
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`assets_hosts_permissions_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of assets_hosts
-- ----------------------------

-- ----------------------------
-- Table structure for assets_hosts_permissions
-- ----------------------------
DROP TABLE IF EXISTS `assets_hosts_permissions`;
CREATE TABLE `assets_hosts_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '名称',
  `status` tinyint(1) DEFAULT '1' COMMENT '''是否激活''',
  `start_time` datetime DEFAULT NULL COMMENT '''授权开始时间''',
  `end_time` datetime DEFAULT NULL COMMENT '''授权结束时间''',
  PRIMARY KEY (`id`),
  KEY `idx_assets_hosts_permissions_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of assets_hosts_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for assets_users
-- ----------------------------
DROP TABLE IF EXISTS `assets_users`;
CREATE TABLE `assets_users` (
  `assets_hosts_permissions_id` bigint(20) NOT NULL COMMENT '自增编号',
  `user_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`assets_hosts_permissions_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of assets_users
-- ----------------------------
INSERT INTO `assets_users` VALUES ('1', '1');

-- ----------------------------
-- Table structure for audit_events
-- ----------------------------
DROP TABLE IF EXISTS `audit_events`;
CREATE TABLE `audit_events` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL,
  `username` varchar(191) DEFAULT NULL,
  `client_ip` varchar(128) DEFAULT NULL COMMENT '客户端ip',
  `ip_location` varchar(128) DEFAULT NULL COMMENT 'ip所在地',
  `path` varchar(128) DEFAULT NULL COMMENT '访问路径',
  `method` varchar(128) DEFAULT NULL COMMENT '请求方法',
  `body` blob COMMENT '请求主体(通过二进制存储节省空间)',
  `data` blob COMMENT '响应数据(通过二进制存储节省空间)',
  `status` bigint(20) DEFAULT NULL COMMENT '响应状态码',
  `latency` bigint(20) DEFAULT NULL COMMENT '请求耗时(ms)',
  `user_agent` varchar(128) DEFAULT NULL COMMENT '浏览器标识',
  PRIMARY KEY (`id`),
  KEY `idx_audit_events_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of audit_events
-- ----------------------------

-- ----------------------------
-- Table structure for biz_env
-- ----------------------------
DROP TABLE IF EXISTS `biz_env`;
CREATE TABLE `biz_env` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `env_name` varchar(128) DEFAULT NULL COMMENT '环境名称',
  `env_code` varchar(64) DEFAULT NULL COMMENT '环境标识',
  `env_desc` varchar(128) DEFAULT NULL COMMENT '环境描述',
  `cluster_id` bigint(20) DEFAULT NULL COMMENT '集群ID',
  `namespace` varchar(191) DEFAULT NULL COMMENT '命名空间',
  `app_id` bigint(20) DEFAULT NULL COMMENT '应用ID',
  `is_container` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_biz_env_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of biz_env
-- ----------------------------

-- ----------------------------
-- Table structure for casbin_rule
-- ----------------------------
DROP TABLE IF EXISTS `casbin_rule`;
CREATE TABLE `casbin_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ptype` varchar(100) DEFAULT NULL,
  `v0` varchar(100) DEFAULT NULL,
  `v1` varchar(100) DEFAULT NULL,
  `v2` varchar(100) DEFAULT NULL,
  `v3` varchar(100) DEFAULT NULL,
  `v4` varchar(100) DEFAULT NULL,
  `v5` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`)
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of casbin_rule
-- ----------------------------
INSERT INTO `casbin_rule` VALUES ('333', 'p', 'guest', '/api/v1/apps', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('359', 'p', 'guest', '/api/v1/apps/autoscaling', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('334', 'p', 'guest', '/api/v1/apps/detail', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('355', 'p', 'guest', '/api/v1/apps/env', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('337', 'p', 'guest', '/api/v1/apps/envs', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('336', 'p', 'guest', '/api/v1/apps/instance', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('358', 'p', 'guest', '/api/v1/apps/metric', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('346', 'p', 'guest', '/api/v1/cicd/deploy', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('345', 'p', 'guest', '/api/v1/cicd/deploy', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('335', 'p', 'guest', '/api/v1/cicd/deploy/tags', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('360', 'p', 'guest', '/api/v1/cicd/git/branches', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('340', 'p', 'guest', '/api/v1/cicd/pipeline/:id', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('342', 'p', 'guest', '/api/v1/cicd/pipeline/build', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('343', 'p', 'guest', '/api/v1/cicd/pipeline/build/:name', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('339', 'p', 'guest', '/api/v1/cicd/pipeline/runHistory/:id', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('338', 'p', 'guest', '/api/v1/cicd/pipelines', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('354', 'p', 'guest', '/api/v1/cicd/settings', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('341', 'p', 'guest', '/api/v1/cicd/tekton/pipeline', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('302', 'p', 'guest', '/api/v1/cmdb/host/assets/users', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('299', 'p', 'guest', '/api/v1/cmdb/host/groups', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('356', 'p', 'guest', '/api/v1/cmdb/host/server/resource', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('298', 'p', 'guest', '/api/v1/cmdb/host/servers', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('301', 'p', 'guest', '/api/v1/cmdb/host/ssh/nodes-assets/tree', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('303', 'p', 'guest', '/api/v1/cmdb/host/ssh/users', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('305', 'p', 'guest', '/api/v1/k8s/cluster', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('304', 'p', 'guest', '/api/v1/k8s/clusters', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('322', 'p', 'guest', '/api/v1/k8s/cronjob', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('321', 'p', 'guest', '/api/v1/k8s/cronjobs', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('318', 'p', 'guest', '/api/v1/k8s/daemonset', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('317', 'p', 'guest', '/api/v1/k8s/daemonsets', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('313', 'p', 'guest', '/api/v1/k8s/deployment', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('314', 'p', 'guest', '/api/v1/k8s/deployment/service', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('312', 'p', 'guest', '/api/v1/k8s/deployments', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('306', 'p', 'guest', '/api/v1/k8s/event', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('320', 'p', 'guest', '/api/v1/k8s/job', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('319', 'p', 'guest', '/api/v1/k8s/jobs', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('325', 'p', 'guest', '/api/v1/k8s/log/:namespace/:pod', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('326', 'p', 'guest', '/api/v1/k8s/log/:namespace/:pod/:container', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('327', 'p', 'guest', '/api/v1/k8s/log/file/:namespace/:pod/:container', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('328', 'p', 'guest', '/api/v1/k8s/log/source/:namespace/:resourceName/:resourceType', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('309', 'p', 'guest', '/api/v1/k8s/namespace/limitranges', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('308', 'p', 'guest', '/api/v1/k8s/namespace/resourcequotas', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('307', 'p', 'guest', '/api/v1/k8s/namespaces', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('330', 'p', 'guest', '/api/v1/k8s/network/ingress', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('329', 'p', 'guest', '/api/v1/k8s/network/ingresss', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('332', 'p', 'guest', '/api/v1/k8s/network/service', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('331', 'p', 'guest', '/api/v1/k8s/network/services', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('311', 'p', 'guest', '/api/v1/k8s/node', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('310', 'p', 'guest', '/api/v1/k8s/nodes', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('324', 'p', 'guest', '/api/v1/k8s/pod', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('323', 'p', 'guest', '/api/v1/k8s/pods', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('316', 'p', 'guest', '/api/v1/k8s/statefulset', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('315', 'p', 'guest', '/api/v1/k8s/statefulsets', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('352', 'p', 'guest', '/api/v1/menu', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('351', 'p', 'guest', '/api/v1/menu/role', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('357', 'p', 'guest', '/api/v1/monitoring/describeMetric', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('300', 'p', 'guest', '/api/v1/tree/host/group', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('353', 'p', 'guest', '/api/v1/tree/menu', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('350', 'p', 'guest', '/api/v1/tree/menu/role', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('348', 'p', 'guest', '/api/v1/user/profile', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('349', 'p', 'guest', '/api/v1/user/profile', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('344', 'p', 'guest', '/api/v1/ws/build/detail', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('347', 'p', 'guest', '/api/v1/ws/deploy/:id', 'GET', '', '', '');

-- ----------------------------
-- Table structure for cloud_platform
-- ----------------------------
DROP TABLE IF EXISTS `cloud_platform`;
CREATE TABLE `cloud_platform` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(191) DEFAULT NULL,
  `access_key` varchar(191) DEFAULT NULL,
  `secret_key` varchar(191) DEFAULT NULL,
  `region` varchar(191) DEFAULT NULL,
  `desc` varchar(191) DEFAULT NULL,
  `enable` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `provider` varchar(191) DEFAULT NULL COMMENT '云服务提供商',
  PRIMARY KEY (`id`),
  KEY `idx_cloud_platform_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of cloud_platform
-- ----------------------------

-- ----------------------------
-- Table structure for cloud_virtual_machine
-- ----------------------------
DROP TABLE IF EXISTS `cloud_virtual_machine`;
CREATE TABLE `cloud_virtual_machine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(191) DEFAULT NULL,
  `hostname` varchar(191) DEFAULT NULL COMMENT '主机名',
  `cpu` bigint(20) DEFAULT NULL COMMENT '''CPU''',
  `os_type` varchar(191) DEFAULT NULL COMMENT '系统类型',
  `mac_addr` varchar(191) DEFAULT NULL COMMENT '物理地址',
  `private_addr` varchar(191) DEFAULT NULL COMMENT '私网地址',
  `public_addr` varchar(191) DEFAULT NULL COMMENT '公网地址',
  `sn` varchar(191) DEFAULT NULL COMMENT 'SN序列号',
  `bandwidth` bigint(20) DEFAULT NULL COMMENT '带宽',
  `status` varchar(191) DEFAULT NULL,
  `region` varchar(191) DEFAULT NULL COMMENT '机房',
  `vm_created_time` varchar(191) DEFAULT NULL,
  `vm_expired_time` varchar(191) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `business` varchar(191) DEFAULT NULL,
  `memory` bigint(20) DEFAULT NULL COMMENT '内存/MB',
  `provider` varchar(191) DEFAULT NULL COMMENT '云服务提供商',
  `zone_id` varchar(191) DEFAULT NULL COMMENT '可用区',
  `os_name` varchar(191) DEFAULT NULL COMMENT '系统名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_cloud_virtual_machine_deleted_at` (`deleted_at`),
  KEY `idx_uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of cloud_virtual_machine
-- ----------------------------

-- ----------------------------
-- Table structure for container_env_config
-- ----------------------------
DROP TABLE IF EXISTS `container_env_config`;
CREATE TABLE `container_env_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `env_name` varchar(191) DEFAULT NULL COMMENT '环境名称',
  `instance_num` bigint(20) DEFAULT NULL COMMENT '应用实例数',
  `probe_mode` varchar(32) DEFAULT NULL COMMENT '探测方式(HTTP、TCP)',
  `check_path` varchar(64) DEFAULT NULL COMMENT '健康检查路径',
  `port` int(11) DEFAULT NULL COMMENT '端口',
  `cpu_request` int(11) DEFAULT '1' COMMENT 'CPU请求(Core)',
  `cpu_limit` int(11) DEFAULT NULL COMMENT 'CPU限制(Core)',
  `memory_request` int(11) DEFAULT NULL COMMENT '内存请求(MB)',
  `memory_limit` int(11) DEFAULT NULL COMMENT '内存限制(MB)',
  `package_path` varchar(191) DEFAULT NULL COMMENT '构建物路径',
  `docker_file_path` varchar(191) DEFAULT NULL COMMENT '编排文件路径',
  `is_enable_log` tinyint(1) DEFAULT NULL COMMENT '采集日志',
  `monitor_enable` tinyint(1) DEFAULT '0' COMMENT '应用监控接入',
  `monitor_path` varchar(191) DEFAULT '/actuator/prometheus' COMMENT '采集路径',
  `monitor_port` int(11) DEFAULT '30030' COMMENT '采集端口',
  `mesh_enable` tinyint(1) DEFAULT '0' COMMENT '是否服务网格',
  `support_restart` tinyint(1) DEFAULT '1' COMMENT '支持重启',
  PRIMARY KEY (`id`),
  KEY `idx_container_env_config_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of container_env_config
-- ----------------------------

-- ----------------------------
-- Table structure for deploy_history
-- ----------------------------
DROP TABLE IF EXISTS `deploy_history`;
CREATE TABLE `deploy_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `app_code` varchar(191) DEFAULT NULL COMMENT '应用名称',
  `is_container` tinyint(1) DEFAULT NULL COMMENT '应用类型(true容器,false虚拟机)',
  `title` varchar(191) DEFAULT NULL COMMENT '发布单名称',
  `task_id` varchar(191) DEFAULT NULL COMMENT '任务ID',
  `refuse_msg` varchar(191) DEFAULT NULL COMMENT '拒绝原因',
  `version` varchar(191) DEFAULT NULL COMMENT '版本',
  `status` bigint(20) DEFAULT '1' COMMENT '状态',
  `status_name` varchar(191) DEFAULT NULL,
  `progress` bigint(20) DEFAULT NULL COMMENT '部署进度',
  `deploy_start_time` datetime DEFAULT NULL,
  `deploy_end_time` datetime DEFAULT NULL,
  `auto_deploy_time` datetime DEFAULT NULL COMMENT '定时发布时间',
  `env_id` bigint(20) DEFAULT NULL COMMENT '部署环境',
  `develop` json DEFAULT NULL COMMENT '开发',
  `applicant` varchar(191) DEFAULT NULL COMMENT '申请人',
  `deploy_real_name` varchar(191) DEFAULT NULL COMMENT '操作人',
  `deploy_pause` varchar(191) DEFAULT NULL COMMENT '发布暂停模式',
  `is_pause` tinyint(1) DEFAULT NULL COMMENT '是否暂停',
  `update_strategy` varchar(191) DEFAULT NULL COMMENT '发布模式',
  `desc` varchar(191) DEFAULT NULL COMMENT '描述',
  `cluster_name` varchar(191) DEFAULT NULL COMMENT '集群名称',
  `namespace` varchar(191) DEFAULT NULL COMMENT '命名空间',
  `submit_user` varchar(191) DEFAULT NULL COMMENT '提交人',
  `deploy_pause_model` varchar(191) DEFAULT NULL COMMENT '发布暂停模式',
  `operator_user` varchar(191) DEFAULT NULL COMMENT '操作人',
  PRIMARY KEY (`id`),
  KEY `idx_deploy_history_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of deploy_history
-- ----------------------------

-- ----------------------------
-- Table structure for deploy_history_apps
-- ----------------------------
DROP TABLE IF EXISTS `deploy_history_apps`;
CREATE TABLE `deploy_history_apps` (
  `deploy_history_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '自增编号',
  `app_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '自增编号',
  PRIMARY KEY (`deploy_history_id`,`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of deploy_history_apps
-- ----------------------------

-- ----------------------------
-- Table structure for deploy_history_container_envs
-- ----------------------------
DROP TABLE IF EXISTS `deploy_history_container_envs`;
CREATE TABLE `deploy_history_container_envs` (
  `deploy_history_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '自增编号',
  `container_env_config_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '自增编号',
  PRIMARY KEY (`deploy_history_id`,`container_env_config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of deploy_history_container_envs
-- ----------------------------

-- ----------------------------
-- Table structure for deploy_history_virtual_machine_envs
-- ----------------------------
DROP TABLE IF EXISTS `deploy_history_virtual_machine_envs`;
CREATE TABLE `deploy_history_virtual_machine_envs` (
  `deploy_history_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  `virtual_machine_env_config_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  PRIMARY KEY (`deploy_history_id`,`virtual_machine_env_config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of deploy_history_virtual_machine_envs
-- ----------------------------

-- ----------------------------
-- Table structure for deploy_steps
-- ----------------------------
DROP TABLE IF EXISTS `deploy_steps`;
CREATE TABLE `deploy_steps` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `task_id` varchar(191) DEFAULT NULL COMMENT '任务ID',
  `current` varchar(191) DEFAULT NULL COMMENT '步骤',
  `status` varchar(191) DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_deploy_steps_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of deploy_steps
-- ----------------------------

-- ----------------------------
-- Table structure for dept
-- ----------------------------
DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL COMMENT '部门名称',
  `sort` int(3) DEFAULT '0' COMMENT '排序',
  `parent_id` bigint(20) unsigned DEFAULT '0' COMMENT '父级部门(编号为0时表示根)',
  PRIMARY KEY (`id`),
  KEY `idx_dept_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dept
-- ----------------------------
INSERT INTO `dept` VALUES ('1', '2021-09-24 15:56:54', '2021-09-24 15:56:57', null, '技术部', '0', '0');
INSERT INTO `dept` VALUES ('2', '2022-01-07 22:37:51', '2022-01-07 22:37:56', null, '测试组', '0', '1');

-- ----------------------------
-- Table structure for docker_hosts
-- ----------------------------
DROP TABLE IF EXISTS `docker_hosts`;
CREATE TABLE `docker_hosts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '标识',
  `host` varchar(191) DEFAULT NULL COMMENT '主机',
  `port` bigint(20) DEFAULT '2375' COMMENT '端口',
  `desc` varchar(191) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_docker_hosts_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of docker_hosts
-- ----------------------------

-- ----------------------------
-- Table structure for file_operation_logs
-- ----------------------------
DROP TABLE IF EXISTS `file_operation_logs`;
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

-- ----------------------------
-- Records of file_operation_logs
-- ----------------------------

-- ----------------------------
-- Table structure for hosts_group
-- ----------------------------
DROP TABLE IF EXISTS `hosts_group`;
CREATE TABLE `hosts_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `parent_id` bigint(20) DEFAULT '0',
  `hide` bigint(20) DEFAULT '0',
  `sort_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of hosts_group
-- ----------------------------
INSERT INTO `hosts_group` VALUES ('1', 'Default', '0', '0', '0');
INSERT INTO `hosts_group` VALUES ('2', '腾讯云', '0', '0', '1');
INSERT INTO `hosts_group` VALUES ('3', '阿里云', '0', '0', '2');
INSERT INTO `hosts_group` VALUES ('4', '华东一区', '3', '0', '2');
INSERT INTO `hosts_group` VALUES ('5', '华东二区', '3', '0', '1');
INSERT INTO `hosts_group` VALUES ('6', '华东三区', '3', '0', '0');

-- ----------------------------
-- Table structure for hosts_group_virtual_machines
-- ----------------------------
DROP TABLE IF EXISTS `hosts_group_virtual_machines`;
CREATE TABLE `hosts_group_virtual_machines` (
  `tree_menu_id` bigint(20) NOT NULL,
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`tree_menu_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of hosts_group_virtual_machines
-- ----------------------------

-- ----------------------------
-- Table structure for jump_gateway
-- ----------------------------
DROP TABLE IF EXISTS `jump_gateway`;
CREATE TABLE `jump_gateway` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '网关名称',
  `ip` varchar(191) DEFAULT NULL,
  `username` varchar(191) DEFAULT NULL COMMENT '用户',
  `password` varchar(300) DEFAULT NULL COMMENT '密码',
  `private_key` text COMMENT '密钥',
  `enable` tinyint(1) DEFAULT NULL COMMENT '是否启用',
  `login_type` varchar(191) DEFAULT NULL COMMENT '登陆类型',
  `protocol` varchar(191) DEFAULT NULL COMMENT '协议',
  `desc` varchar(191) DEFAULT NULL COMMENT '备注',
  `port` varchar(191) DEFAULT '22' COMMENT '端口',
  PRIMARY KEY (`id`),
  KEY `idx_jump_gateway_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of jump_gateway
-- ----------------------------

-- ----------------------------
-- Table structure for k8s_cluster
-- ----------------------------
DROP TABLE IF EXISTS `k8s_cluster`;
CREATE TABLE `k8s_cluster` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `cluster_name` varchar(191) DEFAULT NULL COMMENT '集群名称',
  `cluster_id` varchar(191) DEFAULT NULL COMMENT '集群ID',
  `kube_config` text COMMENT '集群凭证',
  `cluster_version` varchar(191) DEFAULT NULL COMMENT '集群版本',
  `node_number` bigint(20) DEFAULT NULL,
  `status` varchar(191) DEFAULT NULL COMMENT '集群状态',
  `prometheus_url` varchar(191) DEFAULT NULL COMMENT 'Prometheus监控地址',
  PRIMARY KEY (`id`),
  KEY `idx_k8s_cluster_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL COMMENT '''菜单名称''',
  `icon` varchar(64) DEFAULT NULL COMMENT '''菜单图标''',
  `path` varchar(64) DEFAULT NULL COMMENT '''菜单访问路径''',
  `sort` int(3) DEFAULT '0' COMMENT '''菜单顺序(同级菜单, 从0开始, 越小显示越靠前)''',
  `parent_id` bigint(20) unsigned DEFAULT '0' COMMENT '''父菜单编号(编号为0时表示根菜单)''',
  PRIMARY KEY (`id`),
  KEY `idx_menu_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES ('1', '2022-02-11 15:41:58', null, null, '仪表盘', 'pigs-icon-ziyuan', '/', '0', '0');
INSERT INTO `menu` VALUES ('2', '2022-02-11 15:49:48', null, null, '资产管理', 'pigs-icon-fuwuqi1', null, '0', '0');
INSERT INTO `menu` VALUES ('3', '2022-02-11 15:50:23', null, null, '服务器', '', '/cmdb/server', '1', '2');
INSERT INTO `menu` VALUES ('4', '2022-04-30 14:02:53', null, null, '系统用户', '', '/cmdb/system/user', '2', '2');
INSERT INTO `menu` VALUES ('5', '2022-05-20 15:01:48', null, null, '资产授权', '', '/cmdb/server/permissions', '3', '2');
INSERT INTO `menu` VALUES ('6', '2022-12-12 14:14:36', null, null, '中转网关', '', '/cmdb/jump/gateway', '4', '2');
INSERT INTO `menu` VALUES ('7', '2022-02-11 15:50:27', null, null, '容器管理', 'pigs-icon-Kubernetes', '', '0', '0');
INSERT INTO `menu` VALUES ('8', '2022-02-11 15:50:31', null, null, '集群管理', null, '/k8s/cluster', '1', '7');
INSERT INTO `menu` VALUES ('9', '2022-12-29 09:57:17', null, null, '命名空间', '', '/k8s/namespace', '2', '7');
INSERT INTO `menu` VALUES ('10', '2022-02-11 15:52:51', null, null, '节点管理', null, '/k8s/node', '3', '7');
INSERT INTO `menu` VALUES ('11', '2022-02-11 15:53:00', null, null, '工作负载', null, '/k8s/workload', '4', '7');
INSERT INTO `menu` VALUES ('12', '2022-02-11 15:53:06', null, null, '存储管理', null, '/k8s/storage', '5', '7');
INSERT INTO `menu` VALUES ('13', '2022-02-11 15:53:10', null, null, '网络管理', null, '/k8s/network', '6', '7');
INSERT INTO `menu` VALUES ('14', '2022-02-11 15:53:14', null, null, '配置管理', null, '/k8s/config', '7', '7');
INSERT INTO `menu` VALUES ('15', '2022-02-11 15:53:18', null, null, '事件中心', null, '/k8s/event', '8', '7');
INSERT INTO `menu` VALUES ('19', '2022-02-13 11:38:50', null, null, '应用发布', 'pigs-icon-gengduoyingyong', null, '0', '0');
INSERT INTO `menu` VALUES ('20', '2022-02-13 11:38:50', null, null, '应用管理', null, '/application/manage', '1', '19');
INSERT INTO `menu` VALUES ('21', '2022-02-13 11:38:50', null, null, '凭证管理', '', '/application/pipeline/credential', '2', '19');
INSERT INTO `menu` VALUES ('22', '2022-09-27 21:06:26', null, null, '构建中心', '', '/application/pipelines', '3', '19');
INSERT INTO `menu` VALUES ('23', '2022-02-13 11:38:50', null, null, '发布申请', '', '/application/apps/deploy', '4', '19');
INSERT INTO `menu` VALUES ('24', '2022-02-13 11:38:50', null, null, '系统管理', 'pigs-icon-yonghuzhongxin_shezhizhongxin', null, '0', '0');
INSERT INTO `menu` VALUES ('25', '2022-02-13 11:38:50', null, null, '用户管理', null, '/user/manage', '1', '24');
INSERT INTO `menu` VALUES ('26', '2022-02-13 11:38:50', null, null, '角色管理', null, '/role/manage', '2', '24');
INSERT INTO `menu` VALUES ('27', '2022-02-13 11:38:50', null, null, '接口管理', null, '/grantApi/manage', '3', '24');
INSERT INTO `menu` VALUES ('28', '2022-02-13 11:38:50', null, null, '菜单管理', null, '/menu/manage', '4', '24');
INSERT INTO `menu` VALUES ('29', '2022-11-28 18:36:42', null, null, '系统设置', '', '/system/settings', '5', '24');
INSERT INTO `menu` VALUES ('30', '2022-08-23 14:27:48', null, null, '运维工具', 'pigs-icon-bushu', '', '0', '0');
INSERT INTO `menu` VALUES ('32', '2023-01-18 20:04:09', null, null, '隧道转发', '', '/tools/tunnel', '2', '30');
INSERT INTO `menu` VALUES ('33', '2022-11-04 15:50:19', null, null, '操作审计', 'pigs-icon-anquanshenji', '', '0', '0');
INSERT INTO `menu` VALUES ('34', '2022-11-04 15:51:21', null, null, '终端录像', '', '/audit/terminal', '0', '33');
INSERT INTO `menu` VALUES ('35', '2023-01-06 18:47:10', null, null, '容器录像', '', '/audit/pod/terminal', '3', '33');
INSERT INTO `menu` VALUES ('36', '2022-12-21 16:57:57', null, null, '行为记录', '', '/audit/api', '2', '33');

-- ----------------------------
-- Table structure for notification
-- ----------------------------
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `env_id` bigint(20) DEFAULT NULL COMMENT '环境ID',
  `is_enabled` tinyint(1) DEFAULT '0' COMMENT '是否开启通知',
  `notice_event` json DEFAULT NULL COMMENT '通知事件(部署成功、部署失败、构建开始、构建失败、构建成功、构建中止)',
  `notice_type` varchar(191) DEFAULT NULL COMMENT '通知类型(dingtalk、feishu)',
  `webhook` varchar(191) DEFAULT NULL COMMENT '机器人webhook',
  PRIMARY KEY (`id`),
  KEY `idx_notification_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of notification
-- ----------------------------

-- ----------------------------
-- Table structure for oss
-- ----------------------------
DROP TABLE IF EXISTS `oss`;
CREATE TABLE `oss` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `access_key_id` varchar(191) DEFAULT NULL,
  `access_key_secret` varchar(191) DEFAULT NULL,
  `endpoint` varchar(191) DEFAULT NULL,
  `bucket_name` varchar(191) DEFAULT NULL,
  `desc` varchar(191) DEFAULT NULL,
  `provider` varchar(191) DEFAULT NULL COMMENT 'aliyun、tencent、huawei、aws',
  PRIMARY KEY (`id`),
  KEY `idx_oss_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of oss
-- ----------------------------

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `pid` bigint(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `sort` bigint(20) DEFAULT NULL,
  `path` varchar(200) DEFAULT NULL,
  `method` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_permissions_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES ('1', null, null, null, '4', '资产管理', '1', null, null);
INSERT INTO `permissions` VALUES ('2', null, null, null, '1', '服务器', '1', null, null);
INSERT INTO `permissions` VALUES ('3', '2023-02-23 11:29:10', '2023-02-23 11:29:10', null, '2', '获取服务器资产列表', '0', '/api/v1/cmdb/host/servers', 'GET');
INSERT INTO `permissions` VALUES ('4', '2022-01-20 14:41:50', null, null, '0', '所有权限', '1', null, null);
INSERT INTO `permissions` VALUES ('5', '2023-02-23 11:31:56', '2023-02-23 11:31:56', null, '2', '获取服务器分组列表', '0', '/api/v1/cmdb/host/groups', 'GET');
INSERT INTO `permissions` VALUES ('6', '2023-02-23 13:09:33', '2023-02-23 13:09:33', null, '2', '修改资产分组', '0', '/api/v1/cmdb/host/group', 'PUT');
INSERT INTO `permissions` VALUES ('7', '2023-02-23 13:09:55', '2023-02-23 13:09:55', null, '2', '删除资产分组下的所有主机', '0', '/api/v1/cmdb/host/server', 'DELETE');
INSERT INTO `permissions` VALUES ('8', '2023-02-23 13:10:18', '2023-02-23 13:10:18', null, '2', '删除资产分组', '0', '/api/v1/cmdb/host/group', 'DELETE');
INSERT INTO `permissions` VALUES ('9', '2023-02-23 13:10:39', '2023-02-23 13:10:39', null, '2', '添加云资源同步', '0', '/api/v1/cloud/account', 'POST');
INSERT INTO `permissions` VALUES ('10', '2023-02-23 13:11:04', '2023-02-23 13:11:04', null, '2', '获取资产分组树', '0', '/api/v1/tree/host/group', 'GET');
INSERT INTO `permissions` VALUES ('11', '2023-02-23 13:11:20', '2023-02-23 13:11:20', null, '2', '导入资产文件上传', '0', '/api/v1/cmdb/host/import/file', 'POST');
INSERT INTO `permissions` VALUES ('12', '2023-02-23 13:11:39', '2023-02-23 13:11:39', null, '2', '资产导入', '0', '/api/v1/cmdb/host/import', 'POST');
INSERT INTO `permissions` VALUES ('13', '2023-02-23 13:11:53', '2023-02-23 13:11:53', null, '2', '获取资产连接右侧节点树', '0', '/api/v1/cmdb/host/ssh/nodes-assets/tree', 'GET');
INSERT INTO `permissions` VALUES ('14', '2023-02-23 13:12:49', '2023-02-23 13:12:49', null, '2', '获取资产授权用户', '0', '/api/v1/cmdb/host/assets/users', 'GET');
INSERT INTO `permissions` VALUES ('15', '2023-02-23 13:13:26', '2023-02-23 13:13:26', null, '2', '删除主机', '0', '/api/v1/cmdb/host/servers', 'POST');
INSERT INTO `permissions` VALUES ('16', null, null, null, '1', '系统用户', '2', null, null);
INSERT INTO `permissions` VALUES ('17', '2023-02-23 13:18:05', '2023-02-23 13:18:05', null, '16', '获取系统用户列表', '0', '/api/v1/cmdb/host/ssh/users', 'GET');
INSERT INTO `permissions` VALUES ('18', '2023-02-23 13:18:21', '2023-02-23 13:18:21', null, '16', '添加系统用户', '0', '/api/v1/cmdb/host/ssh/user', 'POST');
INSERT INTO `permissions` VALUES ('19', '2023-02-23 13:18:35', '2023-02-23 13:18:35', null, '16', '删除系统用户', '0', '/api/v1/cmdb/host/ssh/users', 'DELETE');
INSERT INTO `permissions` VALUES ('20', '2023-02-23 13:18:52', '2023-02-23 13:18:52', null, '16', '禁用/启用系统用户', '0', '/api/v1/cmdb/host/ssh/users', 'PUT');
INSERT INTO `permissions` VALUES ('21', '2023-02-23 13:19:08', '2023-02-23 13:19:08', null, '16', '更新系统用户', '0', '/api/v1/cmdb/host/ssh/users/:id', 'POST');
INSERT INTO `permissions` VALUES ('22', null, null, null, '1', '资产授权', '3', null, null);
INSERT INTO `permissions` VALUES ('23', '2023-02-23 13:20:13', '2023-02-23 13:21:01', null, '22', '获取资产授权列表', '0', '/api/v1/cmdb/host/assets', 'GET');
INSERT INTO `permissions` VALUES ('24', '2023-02-23 13:20:52', '2023-02-23 13:20:52', null, '22', '创建资产授权-不分页获取用户', '0', '/api/v1/user/nopage', 'GET');
INSERT INTO `permissions` VALUES ('25', '2023-02-23 13:21:22', '2023-02-23 13:21:22', null, '22', '创建资产授权', '0', '/api/v1/cmdb/host/assets', 'POST');
INSERT INTO `permissions` VALUES ('26', '2023-02-23 13:21:38', '2023-02-23 13:21:38', null, '22', '查看资产授权详情', '0', '/api/v1/cmdb/host/assets/:id', 'GET');
INSERT INTO `permissions` VALUES ('27', '2023-02-23 13:21:52', '2023-02-23 13:21:52', null, '22', '更新资产授权', '0', '/api/v1/cmdb/host/assets/:id', 'PUT');
INSERT INTO `permissions` VALUES ('28', '2023-02-23 13:22:12', '2023-02-23 13:22:12', null, '22', '禁用/启用资产授权', '0', '/api/v1/cmdb/host/assets/status', 'POST');
INSERT INTO `permissions` VALUES ('29', '2023-02-23 13:22:29', '2023-02-23 13:22:29', null, '22', '删除资产授权', '0', '/api/v1/cmdb/host/assets', 'DELETE');
INSERT INTO `permissions` VALUES ('30', null, null, null, '1', '中转网关', '4', null, null);
INSERT INTO `permissions` VALUES ('31', '2023-02-23 13:23:29', '2023-02-23 13:23:29', null, '30', '获取中转网关列表', '0', '/api/v1/cmdb/jump/gateway', 'GET');
INSERT INTO `permissions` VALUES ('32', '2023-02-23 13:23:42', '2023-02-23 13:23:42', null, '30', '禁用/启用中转网关', '0', '/api/v1/cmdb/jump/gateway/status', 'POST');
INSERT INTO `permissions` VALUES ('33', '2023-02-23 13:24:00', '2023-02-23 13:24:00', null, '30', '更新中转网关', '0', '/api/v1/cmdb/jump/gateway/:id', 'PUT');
INSERT INTO `permissions` VALUES ('34', '2023-02-23 13:24:14', '2023-02-23 13:24:14', null, '30', '删除中转网关', '0', '/api/v1/cmdb/jump/gateway', 'DELETE');
INSERT INTO `permissions` VALUES ('35', '2023-02-23 13:24:25', '2023-02-23 13:24:25', null, '30', '创建中转网关', '0', '/api/v1/cmdb/jump/gateway', 'POST');
INSERT INTO `permissions` VALUES ('36', null, null, null, '4', '容器管理', '2', null, null);
INSERT INTO `permissions` VALUES ('37', null, null, null, '36', '集群管理', '1', null, null);
INSERT INTO `permissions` VALUES ('38', '2023-02-23 13:27:34', '2023-02-23 13:27:34', null, '37', '获取容器集群列表', '0', '/api/v1/k8s/clusters', 'GET');
INSERT INTO `permissions` VALUES ('39', '2023-02-23 13:27:47', '2023-02-23 13:27:47', null, '37', '新增容器集群', '0', '/api/v1/k8s/cluster', 'POST');
INSERT INTO `permissions` VALUES ('40', '2023-02-23 13:28:02', '2023-02-23 13:28:14', null, '37', '批量删除容器集群', '0', '/api/v1/k8s/clusters', 'POST');
INSERT INTO `permissions` VALUES ('41', '2023-02-23 13:28:49', '2023-02-23 13:28:49', null, '37', '查看容器集群详情', '0', '/api/v1/k8s/cluster', 'GET');
INSERT INTO `permissions` VALUES ('42', '2023-02-23 13:29:04', '2023-02-23 13:29:04', null, '37', '查看容器集群凭证', '0', '/api/v1/k8s/cluster/secret', 'GET');
INSERT INTO `permissions` VALUES ('43', '2023-02-23 13:29:19', '2023-02-23 13:29:19', null, '37', '查看容器集群事件', '0', '/api/v1/k8s/event', 'GET');
INSERT INTO `permissions` VALUES ('44', '2023-02-23 13:29:31', '2023-02-23 13:29:31', null, '37', '更新集群', '0', '/api/v1/k8s/cluster', 'PUT');
INSERT INTO `permissions` VALUES ('45', null, null, null, '36', '命名空间', '2', null, null);
INSERT INTO `permissions` VALUES ('46', '2023-02-23 13:31:03', '2023-02-23 13:31:03', null, '45', '获取命名空间列表', '0', '/api/v1/k8s/namespaces', 'GET');
INSERT INTO `permissions` VALUES ('47', '2023-02-23 13:31:22', '2023-02-23 13:31:22', null, '45', '获取命名空间-资源配额', '0', '/api/v1/k8s/namespace/resourcequotas', 'GET');
INSERT INTO `permissions` VALUES ('48', '2023-02-23 13:31:38', '2023-02-23 13:31:38', null, '45', '创建命名空间-资源配额', '0', '/api/v1/k8s/namespace/resourcequotas', 'POST');
INSERT INTO `permissions` VALUES ('49', '2023-02-23 13:31:55', '2023-02-23 13:31:55', null, '45', '获取命名空间-资源限制', '0', '/api/v1/k8s/namespace/limitranges', 'GET');
INSERT INTO `permissions` VALUES ('50', '2023-02-23 13:32:07', '2023-02-23 13:32:07', null, '45', '创建命名空间-资源限制', '0', '/api/v1/k8s/namespace/limitranges', 'POST');
INSERT INTO `permissions` VALUES ('51', '2023-02-23 13:32:42', '2023-02-23 13:32:42', null, '45', '创建命名空间', '0', '/api/v1/k8s/namespaces', 'POST');
INSERT INTO `permissions` VALUES ('52', '2023-02-23 13:32:54', '2023-02-23 13:32:54', null, '45', '删除命名空间', '0', '/api/v1/k8s/namespaces', 'DELETE');
INSERT INTO `permissions` VALUES ('53', null, null, null, '36', '节点管理', '3', null, null);
INSERT INTO `permissions` VALUES ('54', '2023-02-23 13:34:48', '2023-02-23 13:34:48', null, '53', '获取节点列表', '0', '/api/v1/k8s/nodes', 'GET');
INSERT INTO `permissions` VALUES ('55', '2023-02-23 13:35:03', '2023-02-23 13:35:03', null, '53', '删除节点', '0', '/api/v1/k8s/node', 'DELETE');
INSERT INTO `permissions` VALUES ('56', '2023-02-23 13:35:28', '2023-02-23 13:35:28', null, '53', '批量设置节点排水', '0', '/api/v1/k8s/node/collectionCordon', 'POST');
INSERT INTO `permissions` VALUES ('57', '2023-02-23 13:35:43', '2023-02-23 13:35:43', null, '53', '批量设置节点调度', '0', '/api/v1/k8s/node/collectionSchedule', 'POST');
INSERT INTO `permissions` VALUES ('58', '2023-02-23 13:35:59', '2023-02-23 13:35:59', null, '53', '节点排水', '0', '/api/v1/k8s/node/cordon', 'GET');
INSERT INTO `permissions` VALUES ('59', '2023-02-23 13:36:14', '2023-02-23 13:36:14', null, '53', '节点调度', '0', '/api/v1/k8s/node/schedule', 'POST');
INSERT INTO `permissions` VALUES ('60', '2023-02-23 13:36:29', '2023-02-23 13:36:29', null, '53', '查看节点详情', '0', '/api/v1/k8s/node', 'GET');
INSERT INTO `permissions` VALUES ('61', null, null, null, '36', '工作负载', '4', null, null);
INSERT INTO `permissions` VALUES ('62', '2023-02-23 13:41:59', '2023-02-23 13:41:59', null, '61', '获取无状态列表', '0', '/api/v1/k8s/deployments', 'GET');
INSERT INTO `permissions` VALUES ('63', '2023-02-23 13:42:19', '2023-02-23 13:42:19', null, '61', '删除无状态', '0', '/api/v1/k8s/deployment/delete', 'POST');
INSERT INTO `permissions` VALUES ('64', '2023-02-23 13:42:31', '2023-02-23 13:42:31', null, '61', '查看无状态详情', '0', '/api/v1/k8s/deployment', 'GET');
INSERT INTO `permissions` VALUES ('65', '2023-02-23 13:42:45', '2023-02-23 13:42:45', null, '61', '重启无状态', '0', '/api/v1/k8s/deployment/restart', 'POST');
INSERT INTO `permissions` VALUES ('66', '2023-02-23 13:43:00', '2023-02-23 13:43:00', null, '61', '回滚无状态', '0', '/api/v1/k8s/deployment/rollback', 'POST');
INSERT INTO `permissions` VALUES ('67', '2023-02-23 13:43:19', '2023-02-23 13:43:19', null, '61', '伸缩无状态', '0', '/api/v1/k8s/deployment/scale', 'POST');
INSERT INTO `permissions` VALUES ('68', '2023-02-23 13:43:40', '2023-02-23 13:43:40', null, '61', '根据无状态获取关联服务', '0', '/api/v1/k8s/deployment/service', 'POST');
INSERT INTO `permissions` VALUES ('69', '2023-02-23 13:43:55', '2023-02-23 13:43:55', null, '61', '批量删除无状态', '0', '/api/v1/k8s/deployments', 'POST');
INSERT INTO `permissions` VALUES ('70', '2023-02-23 13:47:17', '2023-02-23 13:47:17', null, '61', '获取有状态列表', '0', '/api/v1/k8s/statefulsets', 'GET');
INSERT INTO `permissions` VALUES ('71', '2023-02-23 13:47:32', '2023-02-23 13:47:32', null, '61', '删除有状态', '0', '/api/v1/k8s/statefulset', 'DELETE');
INSERT INTO `permissions` VALUES ('72', '2023-02-23 13:47:49', '2023-02-23 13:47:49', null, '61', '查看有状态详情', '0', '/api/v1/k8s/statefulset', 'GET');
INSERT INTO `permissions` VALUES ('73', '2023-02-23 13:48:15', '2023-02-23 13:48:15', null, '61', '重启有状态', '0', '/api/v1/k8s/statefulset/restart', 'POST');
INSERT INTO `permissions` VALUES ('74', '2023-02-23 13:48:26', '2023-02-23 13:48:26', null, '61', '伸缩容有状态', '0', '/api/v1/k8s/statefulset/scale', 'POST');
INSERT INTO `permissions` VALUES ('75', '2023-02-23 13:48:43', '2023-02-23 13:48:43', null, '61', '批量删除有状态', '0', '/api/v1/k8s/statefulsets', 'POST');
INSERT INTO `permissions` VALUES ('76', '2023-02-23 13:49:32', '2023-02-23 13:49:32', null, '61', '获取守护进程集列表', '0', '/api/v1/k8s/daemonsets', 'GET');
INSERT INTO `permissions` VALUES ('77', '2023-02-23 13:49:44', '2023-02-23 13:49:44', null, '61', '查看守护进程集详情', '0', '/api/v1/k8s/daemonset', 'GET');
INSERT INTO `permissions` VALUES ('78', '2023-02-23 13:50:04', '2023-02-23 13:50:04', null, '61', '批量删除守护进程集', '0', '/api/v1/k8s/daemonsets', 'POST');
INSERT INTO `permissions` VALUES ('79', '2023-02-23 13:50:19', '2023-02-23 13:50:19', null, '61', '删除守护进程集', '0', '/api/v1/k8s/daemonset', 'DELETE');
INSERT INTO `permissions` VALUES ('80', '2023-02-23 13:50:31', '2023-02-23 13:50:31', null, '61', '重启守护进程集', '0', '/api/v1/k8s/daemonset/restart', 'POST');
INSERT INTO `permissions` VALUES ('81', '2023-02-23 13:52:48', '2023-02-23 13:52:48', null, '61', '获取任务列表', '0', '/api/v1/k8s/jobs', 'GET');
INSERT INTO `permissions` VALUES ('82', '2023-02-23 13:52:59', '2023-02-23 13:52:59', null, '61', '查看任务详情', '0', '/api/v1/k8s/job', 'GET');
INSERT INTO `permissions` VALUES ('83', '2023-02-23 13:53:11', '2023-02-23 13:53:11', null, '61', '删除任务', '0', '/api/v1/k8s/job', 'DELETE');
INSERT INTO `permissions` VALUES ('84', '2023-02-23 13:53:25', '2023-02-23 13:53:25', null, '61', '伸缩容任务', '0', '/api/v1/k8s/job/scale', 'POST');
INSERT INTO `permissions` VALUES ('85', '2023-02-23 13:53:41', '2023-02-23 13:53:41', null, '61', '批量删除任务', '0', '/api/v1/k8s/jobs', 'POST');
INSERT INTO `permissions` VALUES ('86', '2023-02-23 13:53:53', '2023-02-23 13:53:53', null, '61', '获取定时任务列表', '0', '/api/v1/k8s/cronjobs', 'GET');
INSERT INTO `permissions` VALUES ('87', '2023-02-23 13:54:03', '2023-02-23 13:54:03', null, '61', '查看定时任务详情', '0', '/api/v1/k8s/cronjob', 'GET');
INSERT INTO `permissions` VALUES ('88', '2023-02-23 13:54:16', '2023-02-23 13:54:16', null, '61', '批量删除定时任务', '0', '/api/v1/k8s/cronjobs', 'POST');
INSERT INTO `permissions` VALUES ('89', '2023-02-23 13:54:31', '2023-02-23 13:54:31', null, '61', '删除定时任务', '0', '/api/v1/k8s/cronjob', 'DELETE');
INSERT INTO `permissions` VALUES ('90', '2023-02-23 13:56:01', '2023-02-23 13:56:01', null, '61', '获取容器组列表', '0', '/api/v1/k8s/pods', 'GET');
INSERT INTO `permissions` VALUES ('91', '2023-02-23 13:56:12', '2023-02-23 13:56:12', null, '61', '查看容器组详情', '0', '/api/v1/k8s/pod', 'GET');
INSERT INTO `permissions` VALUES ('92', '2023-02-23 13:56:30', '2023-02-23 13:56:30', null, '61', '删除容器组', '0', '/api/v1/k8s/pod', 'DELETE');
INSERT INTO `permissions` VALUES ('93', '2023-02-23 13:56:43', '2023-02-23 13:56:43', null, '61', '批量删除容器组', '0', '/api/v1/k8s/pods', 'POST');
INSERT INTO `permissions` VALUES ('94', null, null, null, '36', '终端-日志', '5', null, null);
INSERT INTO `permissions` VALUES ('95', '2023-02-23 13:57:53', '2023-02-23 13:57:53', null, '94', '获取容器终端大小', '0', '/api/v1/ws/podssh/tty/:id/:id/:id', 'GET');
INSERT INTO `permissions` VALUES ('96', '2023-02-23 13:58:04', '2023-02-23 13:58:04', null, '94', '获取容器终端信息', '0', '/api/v1/ws/podssh/tty/info', 'GET');
INSERT INTO `permissions` VALUES ('97', '2023-02-23 13:58:19', '2023-02-23 13:58:19', null, '94', '连接容器终端会话', '0', '/api/v1/k8s/pod/ssh', 'GET');
INSERT INTO `permissions` VALUES ('98', '2023-02-23 13:58:38', '2023-02-23 13:58:38', null, '94', '获取容器日志内容', '0', '/api/v1/k8s/log/:namespace/:pod', 'GET');
INSERT INTO `permissions` VALUES ('99', '2023-02-23 13:58:52', '2023-02-23 13:58:52', null, '94', '动态查看容器日志', '0', '/api/v1/k8s/log/:namespace/:pod/:container', 'GET');
INSERT INTO `permissions` VALUES ('100', '2023-02-23 13:59:03', '2023-02-23 13:59:03', null, '94', '下载容器日志', '0', '/api/v1/k8s/log/file/:namespace/:pod/:container', 'GET');
INSERT INTO `permissions` VALUES ('101', '2023-02-23 13:59:22', '2023-02-23 13:59:22', null, '94', '获取容器所属资源类型', '0', '/api/v1/k8s/log/source/:namespace/:resourceName/:resourceType', 'GET');
INSERT INTO `permissions` VALUES ('102', null, null, null, '36', '存储管理', '6', null, null);
INSERT INTO `permissions` VALUES ('103', null, null, null, '36', '网络管理', '7', null, null);
INSERT INTO `permissions` VALUES ('104', null, null, null, '36', '配置管理', '8', null, null);
INSERT INTO `permissions` VALUES ('105', '2023-02-23 14:00:33', '2023-02-23 14:00:33', null, '102', '获取存储卷列表', '0', '/api/v1/k8s/storage/pvs', 'GET');
INSERT INTO `permissions` VALUES ('106', '2023-02-23 14:00:43', '2023-02-23 14:00:43', null, '102', '查看存储卷详情', '0', '/api/v1/k8s/storage/pv', 'GET');
INSERT INTO `permissions` VALUES ('107', '2023-02-23 14:00:57', '2023-02-23 14:00:57', null, '102', '删除存储卷', '0', '/api/v1/k8s/storage/pv', 'DELETE');
INSERT INTO `permissions` VALUES ('108', '2023-02-23 14:01:16', '2023-02-23 14:01:16', null, '102', '获取存储声明列表', '0', '/api/v1/k8s/storage/pvcs', 'GET');
INSERT INTO `permissions` VALUES ('109', '2023-02-23 14:01:35', '2023-02-23 14:01:35', null, '102', '查看存储声明详情', '0', '/api/v1/k8s/storage/pvc', 'GET');
INSERT INTO `permissions` VALUES ('110', '2023-02-23 14:01:48', '2023-02-23 14:01:48', null, '102', '删除存储声明', '0', '/api/v1/k8s/storage/pvc', 'DELETE');
INSERT INTO `permissions` VALUES ('111', '2023-02-23 14:01:59', '2023-02-23 14:01:59', null, '102', '获取存储类列表', '0', '/api/v1/k8s/storage/scs', 'GET');
INSERT INTO `permissions` VALUES ('112', '2023-02-23 14:02:12', '2023-02-23 14:02:12', null, '102', '查看存储类详情', '0', '/api/v1/k8s/storage/sc', 'GET');
INSERT INTO `permissions` VALUES ('113', '2023-02-23 14:02:26', '2023-02-23 14:02:26', null, '102', '删除存储类', '0', '/api/v1/k8s/storage/sc', 'DELETE');
INSERT INTO `permissions` VALUES ('114', '2023-02-23 14:03:05', '2023-02-23 14:03:05', null, '103', '获取路由列表', '0', '/api/v1/k8s/network/ingresss', 'GET');
INSERT INTO `permissions` VALUES ('115', '2023-02-23 14:03:17', '2023-02-23 14:03:17', null, '103', '删除路由', '0', '/api/v1/k8s/network/ingress', 'DELETE');
INSERT INTO `permissions` VALUES ('116', '2023-02-23 14:03:28', '2023-02-23 14:03:28', null, '103', '查看路由详情', '0', '/api/v1/k8s/network/ingress', 'GET');
INSERT INTO `permissions` VALUES ('117', '2023-02-23 14:03:40', '2023-02-23 14:03:40', null, '103', '批量删除路由', '0', '/api/v1/k8s/network/ingresss', 'POST');
INSERT INTO `permissions` VALUES ('118', '2023-02-23 14:03:53', '2023-02-23 14:03:53', null, '103', '获取服务列表', '0', '/api/v1/k8s/network/services', 'GET');
INSERT INTO `permissions` VALUES ('119', '2023-02-23 14:04:05', '2023-02-23 14:04:05', null, '103', '查看服务详情', '0', '/api/v1/k8s/network/service', 'GET');
INSERT INTO `permissions` VALUES ('120', '2023-02-23 14:04:18', '2023-02-23 14:04:18', null, '103', '删除服务', '0', '/api/v1/k8s/network/service', 'DELETE');
INSERT INTO `permissions` VALUES ('121', '2023-02-23 14:04:30', '2023-02-23 14:04:30', null, '103', '批量删除服务', '0', '/api/v1/k8s/network/services', 'POST');
INSERT INTO `permissions` VALUES ('122', '2023-02-23 14:04:49', '2023-02-23 14:04:49', null, '104', '获取配置项列表', '0', '/api/v1/k8s/config/configmaps', 'GET');
INSERT INTO `permissions` VALUES ('123', '2023-02-23 14:05:01', '2023-02-23 14:05:01', null, '104', '查看配置项详情', '0', '/api/v1/k8s/config/configmap', 'GET');
INSERT INTO `permissions` VALUES ('124', '2023-02-23 14:05:13', '2023-02-23 14:05:13', null, '104', '删除配置项', '0', '/api/v1/k8s/config/configmap', 'DELETE');
INSERT INTO `permissions` VALUES ('125', '2023-02-23 14:05:25', '2023-02-23 14:05:25', null, '104', '批量删除配置项', '0', '/api/v1/k8s/config/configmaps', 'POST');
INSERT INTO `permissions` VALUES ('126', '2023-02-23 14:05:36', '2023-02-23 14:05:36', null, '104', '获取保密字典列表', '0', '/api/v1/k8s/config/secrets', 'GET');
INSERT INTO `permissions` VALUES ('127', '2023-02-23 14:05:52', '2023-02-23 14:05:52', null, '104', '查看保密字典详情', '0', '/api/v1/k8s/config/secret', 'GET');
INSERT INTO `permissions` VALUES ('128', '2023-02-23 14:06:07', '2023-02-23 14:06:07', null, '104', '删除保密字典', '0', '/api/v1/k8s/config/secret', 'DELETE');
INSERT INTO `permissions` VALUES ('129', '2023-02-23 14:06:19', '2023-02-23 14:06:19', null, '104', '批量删除保密字典', '0', '/api/v1/k8s/config/secrets', 'POST');
INSERT INTO `permissions` VALUES ('130', null, null, null, '4', '应用发布', '3', null, null);
INSERT INTO `permissions` VALUES ('131', null, null, null, '130', '应用管理', '1', null, null);
INSERT INTO `permissions` VALUES ('132', '2023-02-23 14:13:26', '2023-02-23 14:13:26', null, '131', '获取应用列表', '0', '/api/v1/apps', 'GET');
INSERT INTO `permissions` VALUES ('133', '2023-02-23 14:13:37', '2023-02-23 14:13:37', null, '131', '创建应用', '0', '/api/v1/apps', 'POST');
INSERT INTO `permissions` VALUES ('134', '2023-02-23 14:13:51', '2023-02-23 14:13:51', null, '131', '查看应用详情', '0', '/api/v1/apps/detail', 'GET');
INSERT INTO `permissions` VALUES ('135', '2023-02-23 14:14:05', '2023-02-23 14:14:05', null, '131', '获取应用版本Tag', '0', '/api/v1/cicd/deploy/tags', 'GET');
INSERT INTO `permissions` VALUES ('136', '2023-02-23 14:14:15', '2023-02-23 14:14:15', null, '131', '获取应用实例', '0', '/api/v1/apps/instance', 'GET');
INSERT INTO `permissions` VALUES ('137', '2023-02-23 14:14:28', '2023-02-23 14:14:28', null, '131', '列出单个应用环境列表', '0', '/api/v1/apps/envs', 'GET');
INSERT INTO `permissions` VALUES ('138', '2023-02-23 14:14:46', '2023-02-23 14:14:46', null, '131', '创建环境-应用搜索', '0', '/api/v1/apps/search', 'GET');
INSERT INTO `permissions` VALUES ('139', null, null, null, '130', '凭证管理', '2', null, null);
INSERT INTO `permissions` VALUES ('140', '2023-02-23 14:16:10', '2023-02-23 14:16:10', null, '139', '获取凭证列表', '0', '/api/v1/cicd/secrets', 'GET');
INSERT INTO `permissions` VALUES ('141', '2023-02-23 14:16:30', '2023-02-23 14:16:30', null, '139', '更新凭证', '0', '/api/v1/cicd/secret', 'PUT');
INSERT INTO `permissions` VALUES ('142', '2023-02-23 14:16:47', '2023-02-23 14:16:47', null, '139', '创建凭证', '0', '/api/v1/cicd/secret', 'POST');
INSERT INTO `permissions` VALUES ('143', '2023-02-23 14:16:56', '2023-02-23 14:16:56', null, '139', '删除凭证', '0', '/api/v1/cicd/secret', 'DELETE');
INSERT INTO `permissions` VALUES ('144', '2023-02-23 14:17:13', '2023-02-23 14:17:13', null, '139', '查看凭证详情', '0', '/api/v1/cicd/secret', 'GET');
INSERT INTO `permissions` VALUES ('145', null, null, null, '130', '构建中心', '3', null, null);
INSERT INTO `permissions` VALUES ('146', '2023-02-23 14:18:40', '2023-02-23 14:18:40', null, '145', '获取流水线列表', '0', '/api/v1/cicd/pipelines', 'GET');
INSERT INTO `permissions` VALUES ('147', '2023-02-23 14:18:58', '2023-02-23 14:18:58', null, '145', '查看流水线构建历史', '0', '/api/v1/cicd/pipeline/runHistory/:id', 'GET');
INSERT INTO `permissions` VALUES ('148', '2023-02-23 14:19:09', '2023-02-23 14:19:09', null, '145', '创建流水线', '0', '/api/v1/cicd/pipeline', 'POST');
INSERT INTO `permissions` VALUES ('149', '2023-02-23 14:19:20', '2023-02-23 14:19:20', null, '145', '查看流水线详情', '0', '/api/v1/cicd/pipeline/:id', 'GET');
INSERT INTO `permissions` VALUES ('150', '2023-02-23 14:19:32', '2023-02-23 14:19:32', null, '145', '删除流水线', '0', '/api/v1/cicd/pipelines', 'DELETE');
INSERT INTO `permissions` VALUES ('151', '2023-02-23 14:19:48', '2023-02-23 14:19:48', null, '145', '运行-获取Tekton流水线详情', '0', '/api/v1/cicd/tekton/pipeline', 'GET');
INSERT INTO `permissions` VALUES ('152', '2023-02-23 14:19:59', '2023-02-23 14:19:59', null, '145', '运行流水线', '0', '/api/v1/cicd/pipeline/build', 'POST');
INSERT INTO `permissions` VALUES ('153', '2023-02-23 14:20:22', '2023-02-23 14:20:22', null, '145', '停止构建', '0', '/api/v1/cicd/pipeline/build/:name', 'PUT');
INSERT INTO `permissions` VALUES ('154', '2023-02-23 14:20:34', '2023-02-23 14:20:34', null, '145', '删除构建历史', '0', '/api/v1/cicd/pipeline/build', 'DELETE');
INSERT INTO `permissions` VALUES ('155', '2023-02-23 14:20:46', '2023-02-23 14:20:46', null, '145', '查看构建详情', '0', '/api/v1/ws/build/detail', 'GET');
INSERT INTO `permissions` VALUES ('156', null, null, null, '130', '发布申请', '4', null, null);
INSERT INTO `permissions` VALUES ('157', '2023-02-23 14:25:07', '2023-02-23 14:51:30', null, '156', '创建应用发布单', '0', '/api/v1/cicd/deploy', 'POST');
INSERT INTO `permissions` VALUES ('158', '2023-02-23 14:25:21', '2023-02-23 14:51:19', null, '156', '获取发布申请列表', '0', '/api/v1/cicd/deploy', 'GET');
INSERT INTO `permissions` VALUES ('159', '2023-02-23 14:25:34', '2023-02-23 14:51:07', null, '156', '查看发布单详情', '0', '/api/v1/ws/deploy/:id', 'GET');
INSERT INTO `permissions` VALUES ('160', '2023-02-23 14:25:51', '2023-02-23 14:50:57', null, '156', '流程审批', '0', '/api/v1/cicd/deploy/approval', 'POST');
INSERT INTO `permissions` VALUES ('161', null, null, null, '4', '系统管理', '4', null, null);
INSERT INTO `permissions` VALUES ('162', null, null, null, '161', '用户管理', '1', null, null);
INSERT INTO `permissions` VALUES ('163', null, null, null, '161', '角色管理', '2', null, null);
INSERT INTO `permissions` VALUES ('164', null, null, null, '161', '菜单管理', '3', null, null);
INSERT INTO `permissions` VALUES ('165', null, null, null, '161', '系统设置', '4', null, null);
INSERT INTO `permissions` VALUES ('166', '2023-02-23 14:53:13', '2023-02-23 14:53:13', null, '162', '获取用户列表', '0', '/api/v1/user/list', 'GET');
INSERT INTO `permissions` VALUES ('167', '2023-02-23 14:53:32', '2023-02-23 14:53:32', '2023-02-23 14:57:43', '162', '批量删除用户', '0', '/api/v1/user/info', 'POST');
INSERT INTO `permissions` VALUES ('168', '2023-02-23 14:53:43', '2023-02-23 14:53:43', null, '162', '重置用户密码', '0', '/api/v1/user/resetPwd', 'POST');
INSERT INTO `permissions` VALUES ('169', '2023-02-23 14:54:00', '2023-02-23 14:54:00', null, '162', '修改个人密码', '0', '/api/v1/user/changePwd', 'POST');
INSERT INTO `permissions` VALUES ('170', '2023-02-23 14:54:17', '2023-02-23 14:54:17', null, '162', '获取个人信息', '0', '/api/v1/user/profile', 'GET');
INSERT INTO `permissions` VALUES ('171', '2023-02-23 14:54:32', '2023-02-23 14:54:32', null, '162', '修改个人信息', '0', '/api/v1/user/profile', 'PUT');
INSERT INTO `permissions` VALUES ('172', '2023-02-23 14:54:47', '2023-02-23 14:54:47', null, '162', '修改用户状态(启用/禁用)', '0', '/api/v1/user', 'PUT');
INSERT INTO `permissions` VALUES ('173', '2023-02-23 14:54:57', '2023-02-23 14:54:57', null, '162', '删除用户', '0', '/api/v1/user', 'DELETE');
INSERT INTO `permissions` VALUES ('174', '2023-02-23 14:55:15', '2023-02-23 14:55:15', null, '163', '获取角色列表', '0', '/api/v1/role', 'GET');
INSERT INTO `permissions` VALUES ('175', '2023-02-23 14:55:27', '2023-02-23 14:55:27', null, '163', '新增角色', '0', '/api/v1/role', 'POST');
INSERT INTO `permissions` VALUES ('176', '2023-02-23 14:55:37', '2023-02-23 14:55:37', null, '163', '修改角色', '0', '/api/v1/role', 'PUT');
INSERT INTO `permissions` VALUES ('177', '2023-02-23 14:55:46', '2023-02-23 14:55:46', null, '163', '删除角色', '0', '/api/v1/role', 'DELETE');
INSERT INTO `permissions` VALUES ('178', '2023-02-23 14:58:41', '2023-02-23 14:58:41', null, '163', '为用户分配角色', '0', '/api/v1/role/bind', 'POST');
INSERT INTO `permissions` VALUES ('179', '2023-02-23 14:59:05', '2023-02-23 14:59:05', null, '163', '根据角色获取已授权的API接口', '0', '/api/v1/tree/permission/role', 'GET');
INSERT INTO `permissions` VALUES ('180', '2023-02-23 14:59:27', '2023-02-23 14:59:27', null, '163', '为角色分配API接口权限', '0', '/api/v1/tree/permission/role', 'POST');
INSERT INTO `permissions` VALUES ('181', '2023-02-23 14:59:41', '2023-02-23 14:59:41', null, '163', '根据角色获取已授权的菜单树', '0', '/api/v1/tree/menu/role', 'GET');
INSERT INTO `permissions` VALUES ('182', '2023-02-23 14:59:55', '2023-02-23 14:59:55', null, '163', '为角色分配菜单', '0', '/api/v1/tree/menu/role', 'POST');
INSERT INTO `permissions` VALUES ('183', null, null, null, '161', '接口管理', '5', null, null);
INSERT INTO `permissions` VALUES ('184', '2023-02-23 15:03:11', '2023-02-23 15:03:11', null, '183', '获取API接口权限树', '0', '/api/v1/tree/permission', 'GET');
INSERT INTO `permissions` VALUES ('185', '2023-02-23 15:03:29', '2023-02-23 15:03:29', null, '183', '获取api分组列表', '0', '/api/v1/permission/api/group', 'GET');
INSERT INTO `permissions` VALUES ('186', '2023-02-23 15:03:44', '2023-02-23 15:03:44', null, '183', '新增api分组', '0', '/api/v1/permission/api/group', 'POST');
INSERT INTO `permissions` VALUES ('187', '2023-02-23 15:03:55', '2023-02-23 15:03:55', null, '183', '获取权限接口列表', '0', '/api/v1/permission/api', 'GET');
INSERT INTO `permissions` VALUES ('188', '2023-02-23 15:04:03', '2023-02-23 15:04:03', null, '183', '新增权限接口', '0', '/api/v1/permission/api', 'POST');
INSERT INTO `permissions` VALUES ('189', '2023-02-23 15:04:19', '2023-02-23 15:04:19', null, '183', '修改权限接口', '0', '/api/v1/permission/api', 'PUT');
INSERT INTO `permissions` VALUES ('190', '2023-02-23 15:04:27', '2023-02-23 15:04:27', null, '183', '删除权限接口', '0', '/api/v1/permission/api', 'DELETE');
INSERT INTO `permissions` VALUES ('191', '2023-02-23 15:04:49', '2023-02-23 15:04:49', null, '164', '根据用户获取前端左侧菜单树', '0', '/api/v1/menu/role', 'GET');
INSERT INTO `permissions` VALUES ('192', '2023-02-23 15:05:04', '2023-02-23 15:05:04', null, '164', '获取菜单列表', '0', '/api/v1/menu', 'GET');
INSERT INTO `permissions` VALUES ('193', '2023-02-23 15:05:12', '2023-02-23 15:05:12', null, '164', '新增菜单', '0', '/api/v1/menu', 'POST');
INSERT INTO `permissions` VALUES ('194', '2023-02-23 15:05:25', '2023-02-23 15:05:25', null, '164', '修改菜单', '0', '/api/v1/menu', 'PUT');
INSERT INTO `permissions` VALUES ('195', '2023-02-23 15:05:34', '2023-02-23 15:05:34', null, '164', '删除菜单', '0', '/api/v1/menu', 'DELETE');
INSERT INTO `permissions` VALUES ('196', '2023-02-23 15:05:49', '2023-02-23 15:05:49', null, '164', '获取菜单树', '0', '/api/v1/tree/menu', 'GET');
INSERT INTO `permissions` VALUES ('197', '2023-02-23 15:06:23', '2023-02-23 15:06:23', null, '165', '获取流水线设置', '0', '/api/v1/cicd/settings', 'GET');
INSERT INTO `permissions` VALUES ('198', '2023-02-23 15:08:01', '2023-02-23 15:08:01', null, '165', '创建/更新流水线设置', '0', '/api/v1/cicd/flow/settings', 'POST');
INSERT INTO `permissions` VALUES ('199', '2023-02-23 15:08:33', '2023-02-23 15:08:33', null, '165', '创建/更新OSS设置', '0', '/api/v1/cicd/oss/settings', 'POST');
INSERT INTO `permissions` VALUES ('200', null, null, null, '4', '运维工具', '5', null, null);
INSERT INTO `permissions` VALUES ('201', null, null, null, '200', '隧道转发', '1', null, null);
INSERT INTO `permissions` VALUES ('202', '2023-02-23 15:11:20', '2023-02-23 15:11:20', null, '201', '获取隧道列表', '0', '/api/v1/cmdb/tunnel', 'GET');
INSERT INTO `permissions` VALUES ('203', '2023-02-23 15:11:29', '2023-02-23 15:11:29', null, '201', '创建隧道', '0', '/api/v1/cmdb/tunnel', 'POST');
INSERT INTO `permissions` VALUES ('204', '2023-02-23 15:11:42', '2023-02-23 15:11:42', null, '201', '启动/停止隧道', '0', '/api/v1/cmdb/tunnel', 'PUT');
INSERT INTO `permissions` VALUES ('205', '2023-02-23 15:11:52', '2023-02-23 15:11:52', null, '201', '删除隧道', '0', '/api/v1/cmdb/tunnel', 'DELETE');
INSERT INTO `permissions` VALUES ('206', null, null, null, '4', '操作审计', '6', null, null);
INSERT INTO `permissions` VALUES ('207', '2023-02-23 15:12:28', '2023-02-23 15:12:28', null, '206', '获取SSH录像列表', '0', '/api/v1/audit/ssh/records', 'GET');
INSERT INTO `permissions` VALUES ('208', '2023-02-23 15:12:42', '2023-02-23 15:12:42', null, '206', '删除SSH录像审计', '0', '/api/v1/audit/ssh/records', 'DELETE');
INSERT INTO `permissions` VALUES ('209', '2023-02-23 15:12:58', '2023-02-23 15:12:58', null, '206', '播放SSH录像', '0', '/api/v1/audit/ssh/records/:id', 'GET');
INSERT INTO `permissions` VALUES ('210', '2023-02-23 15:14:03', '2023-02-23 15:14:03', null, '131', '批量删除应用', '0', '/api/v1/apps', 'DELETE');
INSERT INTO `permissions` VALUES ('211', '2023-02-23 15:14:20', '2023-02-23 15:14:20', null, '156', '批量删除发布申请', '0', '/api/v1/cicd/deploy', 'DELETE');
INSERT INTO `permissions` VALUES ('212', '2023-02-23 15:15:10', '2023-02-23 15:15:10', null, '206', '获取容器录像列表', '0', '/api/v1/audit/pod/ssh/records', 'GET');
INSERT INTO `permissions` VALUES ('213', '2023-02-23 15:15:20', '2023-02-23 15:15:20', null, '206', '删除容器录像审计', '0', '/api/v1/audit/pod/ssh/records', 'DELETE');
INSERT INTO `permissions` VALUES ('214', '2023-02-23 15:15:31', '2023-02-23 15:15:31', null, '206', '播放容器录像', '0', '/api/v1/audit/pod/ssh/records/:id', 'GET');
INSERT INTO `permissions` VALUES ('215', '2023-02-23 15:15:45', '2023-02-23 15:15:45', null, '206', '获取行为记录列表', '0', '/api/v1/audit/api', 'GET');
INSERT INTO `permissions` VALUES ('216', '2023-02-23 15:15:53', '2023-02-23 15:15:53', null, '206', '批量删除行为记录', '0', '/api/v1/audit/api', 'DELETE');
INSERT INTO `permissions` VALUES ('217', '2023-04-07 16:22:46', '2023-04-07 16:23:19', null, '104', '修改配置项', '0', '/api/v1/k8s/config/configmap', 'PUT');
INSERT INTO `permissions` VALUES ('218', '2023-04-07 16:23:10', '2023-04-07 16:23:10', null, '104', '修改保密字典', '0', '/api/v1/k8s/config/secret', 'PUT');
INSERT INTO `permissions` VALUES ('219', '2023-04-07 16:23:54', '2023-04-07 16:23:54', null, '131', '获取环境详情', '0', '/api/v1/apps/env', 'GET');
INSERT INTO `permissions` VALUES ('220', '2023-04-07 16:24:19', '2023-04-07 16:24:19', null, '131', '修改环境', '0', '/api/v1/apps/env', 'PUT');
INSERT INTO `permissions` VALUES ('221', '2023-04-07 16:24:34', '2023-04-07 16:24:34', null, '131', '批量删除环境', '0', '/api/v1/apps/envs', 'DELETE');
INSERT INTO `permissions` VALUES ('222', '2023-05-13 12:55:31', '2023-05-13 12:55:31', null, '2', '获取远程登录实例IP', '0', '/api/v1/cmdb/host/server/resource', 'POST');
INSERT INTO `permissions` VALUES ('223', null, null, null, '36', '监控', '9', null, null);
INSERT INTO `permissions` VALUES ('224', '2023-05-13 15:24:40', '2023-05-13 15:24:40', null, '223', '获取Pod监控图表', '0', '/api/v1/monitoring/describeMetric', 'POST');
INSERT INTO `permissions` VALUES ('225', '2023-05-13 16:11:02', '2023-05-13 16:12:37', null, '131', '获取应用伸缩指标', '0', '/api/v1/apps/metric', 'POST');
INSERT INTO `permissions` VALUES ('226', '2023-05-13 16:11:39', '2023-05-13 16:11:39', null, '131', '获取应用伸缩实例', '0', '/api/v1/apps/autoscaling', 'GET');
INSERT INTO `permissions` VALUES ('227', '2023-05-13 16:18:52', '2023-05-13 16:18:52', null, '145', '获取代码分支', '0', '/api/v1/cicd/git/branches', 'GET');
INSERT INTO `permissions` VALUES ('228', null, null, null, '212', '查看windows录像回话', '0', '/api/v1/audit/rdp/records/:sessionId', 'GET');
INSERT INTO `permissions` VALUES ('229', null, null, null, '8', '创建资产分组', '0', '/api/v1/cmdb/host/group', 'POST');
INSERT INTO `permissions` VALUES ('230', null, null, null, '162', '系统安全设置', '0', '/api/v1/system/safe/settings', 'POST');
INSERT INTO `permissions` VALUES ('231', null, null, null, '162', '获取系统安全设置', '0', '/api/v1/system/safe/settings', 'GET');
INSERT INTO `permissions` VALUES ('232', null, null, null, '212', '获取文件管理操作记录', '0', '/api/v1/audit/filemanage', 'GET');
INSERT INTO `permissions` VALUES ('233', null, null, null, '212', '批量删除文件管理操作记录', '0', '/api/v1/audit/filemanage', 'DELETE');
INSERT INTO `permissions` VALUES ('234', null, null, null, '212', '获取用户登录记录', '0', '/api/v1/audit/login', 'GET');
INSERT INTO `permissions` VALUES ('235', null, null, null, '212', '批量删除用户登录记录', '0', '/api/v1/audit/login', 'DELETE');

-- ----------------------------
-- Table structure for pipeline_resources
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_resources`;
CREATE TABLE `pipeline_resources` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `desc` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pipeline_resources_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pipeline_resources
-- ----------------------------
INSERT INTO `pipeline_resources` VALUES ('1', '2022-11-07 14:35:18', '2022-11-07 14:35:21', null, 'alpine:latest', null);
INSERT INTO `pipeline_resources` VALUES ('2', '2022-11-07 14:35:18', '2022-11-07 14:35:21', null, 'python3.7:latest', null);

-- ----------------------------
-- Table structure for pipeline_result
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_result`;
CREATE TABLE `pipeline_result` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '构建名称',
  `namespace` varchar(191) DEFAULT NULL COMMENT '命名空间',
  `pipeline_id` bigint(20) DEFAULT NULL COMMENT '流水线id',
  `status` varchar(191) DEFAULT NULL COMMENT '构建状态',
  `message` varchar(191) DEFAULT NULL,
  `trigger_user` varchar(191) DEFAULT NULL,
  `build_branch` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tekton_result_deleted_at` (`deleted_at`),
  KEY `idx_pipeline_result_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pipeline_result
-- ----------------------------

-- ----------------------------
-- Table structure for pipeline_secrets
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_secrets`;
CREATE TABLE `pipeline_secrets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(50) NOT NULL COMMENT '凭证名称',
  `desc` varchar(191) DEFAULT NULL COMMENT '备注',
  `secret` varchar(191) DEFAULT NULL COMMENT '关联k8s凭证',
  `secret_type` varchar(191) DEFAULT NULL COMMENT '凭证类型',
  `git_type` varchar(191) DEFAULT NULL COMMENT 'git仓库类型',
  `account_type` varchar(191) DEFAULT NULL COMMENT '账号类型',
  `username` varchar(191) DEFAULT NULL COMMENT '用户名',
  `password` varchar(191) DEFAULT NULL COMMENT '密码',
  `ssh_privatekey` varchar(191) DEFAULT NULL COMMENT '密钥',
  `url` varchar(191) DEFAULT NULL COMMENT '地址',
  `image_type` varchar(191) DEFAULT NULL,
  `access_key` varchar(191) DEFAULT NULL,
  `secret_key` varchar(191) DEFAULT NULL,
  `region_id` varchar(191) DEFAULT NULL,
  `namespace` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_pipeline_stage_name` (`name`),
  KEY `idx_tekton_secrets_deleted_at` (`deleted_at`),
  KEY `idx_pipeline_secrets_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pipeline_secrets
-- ----------------------------

-- ----------------------------
-- Table structure for pipeline_settings
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_settings`;
CREATE TABLE `pipeline_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `cluster_id` bigint(20) DEFAULT NULL COMMENT '集群ID',
  `pvc_name` varchar(191) DEFAULT NULL,
  `namespace` varchar(191) DEFAULT NULL COMMENT '命名空间',
  PRIMARY KEY (`id`),
  KEY `idx_tekton_settings_deleted_at` (`deleted_at`),
  KEY `idx_pipeline_settings_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pipeline_settings
-- ----------------------------

-- ----------------------------
-- Table structure for pipeline_stages
-- ----------------------------
DROP TABLE IF EXISTS `pipeline_stages`;
CREATE TABLE `pipeline_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `pipeline_id` bigint(20) NOT NULL,
  `prev_stage_id` bigint(20) NOT NULL,
  `custom_params` json DEFAULT NULL,
  `jobs` json NOT NULL COMMENT '任务',
  PRIMARY KEY (`id`),
  KEY `idx_pipeline_stages_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pipeline_stages
-- ----------------------------

-- ----------------------------
-- Table structure for pipelines
-- ----------------------------
DROP TABLE IF EXISTS `pipelines`;
CREATE TABLE `pipelines` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(50) NOT NULL COMMENT '流水线名称',
  `app_code` varchar(191) DEFAULT NULL COMMENT '关联应用',
  `app_env` varchar(128) DEFAULT NULL COMMENT '关联环境名称',
  `triggers` json DEFAULT NULL,
  `service_account` varchar(191) DEFAULT NULL COMMENT '关联sa凭证',
  PRIMARY KEY (`id`),
  KEY `idx_pipelines_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pipelines
-- ----------------------------

-- ----------------------------
-- Table structure for pod_ssh_record
-- ----------------------------
DROP TABLE IF EXISTS `pod_ssh_record`;
CREATE TABLE `pod_ssh_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `username` varchar(191) DEFAULT NULL COMMENT '''用户名''',
  `connect_id` varchar(64) DEFAULT NULL COMMENT '''连接标识''',
  `container` varchar(128) DEFAULT NULL COMMENT '''容器名称''',
  `pod_name` varchar(191) DEFAULT NULL,
  `namespace` varchar(128) DEFAULT NULL COMMENT '''命名空间''',
  `connect_time` datetime DEFAULT NULL COMMENT '''接入时间''',
  `logout_time` datetime DEFAULT NULL COMMENT '''注销时间''',
  `records` longblob COMMENT '''操作记录(二进制存储)''',
  `client_ip` varchar(191) DEFAULT NULL COMMENT '客户端地址',
  `user_agent` varchar(191) DEFAULT NULL COMMENT '浏览器标识',
  `ip_location` varchar(128) DEFAULT NULL COMMENT 'ip所在地',
  `cluster_id` bigint(20) DEFAULT NULL COMMENT '''k8s集群id外键''',
  PRIMARY KEY (`id`),
  KEY `idx_pod_ssh_record_connect_time` (`connect_time`),
  KEY `idx_pod_ssh_record_logout_time` (`logout_time`),
  KEY `idx_pod_ssh_record_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pod_ssh_record
-- ----------------------------

-- ----------------------------
-- Table structure for relation_env_hosts
-- ----------------------------
DROP TABLE IF EXISTS `relation_env_hosts`;
CREATE TABLE `relation_env_hosts` (
  `biz_env_id` bigint(20) NOT NULL COMMENT '自增编号',
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`biz_env_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of relation_env_hosts
-- ----------------------------

-- ----------------------------
-- Table structure for relation_group_host
-- ----------------------------
DROP TABLE IF EXISTS `relation_group_host`;
CREATE TABLE `relation_group_host` (
  `tree_menu_id` bigint(20) NOT NULL,
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`tree_menu_id`,`virtual_machine_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of relation_group_host
-- ----------------------------

-- ----------------------------
-- Table structure for relation_host_jump_gateway
-- ----------------------------
DROP TABLE IF EXISTS `relation_host_jump_gateway`;
CREATE TABLE `relation_host_jump_gateway` (
  `jump_gateway_id` bigint(20) NOT NULL COMMENT '自增编号',
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`jump_gateway_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of relation_host_jump_gateway
-- ----------------------------

-- ----------------------------
-- Table structure for relation_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `relation_role_menu`;
CREATE TABLE `relation_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '自增编号',
  `menu_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of relation_role_menu
-- ----------------------------
INSERT INTO `relation_role_menu` VALUES ('1', '1');
INSERT INTO `relation_role_menu` VALUES ('1', '3');
INSERT INTO `relation_role_menu` VALUES ('1', '8');
INSERT INTO `relation_role_menu` VALUES ('1', '9');
INSERT INTO `relation_role_menu` VALUES ('1', '10');
INSERT INTO `relation_role_menu` VALUES ('1', '11');
INSERT INTO `relation_role_menu` VALUES ('1', '12');
INSERT INTO `relation_role_menu` VALUES ('1', '13');
INSERT INTO `relation_role_menu` VALUES ('1', '15');
INSERT INTO `relation_role_menu` VALUES ('1', '20');
INSERT INTO `relation_role_menu` VALUES ('1', '22');
INSERT INTO `relation_role_menu` VALUES ('1', '23');
INSERT INTO `relation_role_menu` VALUES ('3', '1');
INSERT INTO `relation_role_menu` VALUES ('3', '2');
INSERT INTO `relation_role_menu` VALUES ('3', '3');
INSERT INTO `relation_role_menu` VALUES ('3', '4');
INSERT INTO `relation_role_menu` VALUES ('3', '5');
INSERT INTO `relation_role_menu` VALUES ('3', '6');
INSERT INTO `relation_role_menu` VALUES ('3', '7');
INSERT INTO `relation_role_menu` VALUES ('3', '8');
INSERT INTO `relation_role_menu` VALUES ('3', '9');
INSERT INTO `relation_role_menu` VALUES ('3', '10');
INSERT INTO `relation_role_menu` VALUES ('3', '11');
INSERT INTO `relation_role_menu` VALUES ('3', '12');
INSERT INTO `relation_role_menu` VALUES ('3', '13');
INSERT INTO `relation_role_menu` VALUES ('3', '14');
INSERT INTO `relation_role_menu` VALUES ('3', '15');
INSERT INTO `relation_role_menu` VALUES ('3', '16');
INSERT INTO `relation_role_menu` VALUES ('3', '17');
INSERT INTO `relation_role_menu` VALUES ('3', '18');
INSERT INTO `relation_role_menu` VALUES ('3', '19');
INSERT INTO `relation_role_menu` VALUES ('3', '20');
INSERT INTO `relation_role_menu` VALUES ('3', '21');
INSERT INTO `relation_role_menu` VALUES ('3', '22');
INSERT INTO `relation_role_menu` VALUES ('3', '23');
INSERT INTO `relation_role_menu` VALUES ('3', '24');
INSERT INTO `relation_role_menu` VALUES ('3', '25');
INSERT INTO `relation_role_menu` VALUES ('3', '26');
INSERT INTO `relation_role_menu` VALUES ('3', '29');
INSERT INTO `relation_role_menu` VALUES ('3', '30');
INSERT INTO `relation_role_menu` VALUES ('3', '33');
INSERT INTO `relation_role_menu` VALUES ('3', '34');
INSERT INTO `relation_role_menu` VALUES ('3', '35');
INSERT INTO `relation_role_menu` VALUES ('3', '36');

-- ----------------------------
-- Table structure for relation_virtual_machines_tags
-- ----------------------------
DROP TABLE IF EXISTS `relation_virtual_machines_tags`;
CREATE TABLE `relation_virtual_machines_tags` (
  `virtual_machine_id` bigint(20) NOT NULL COMMENT '自增编号',
  `tags_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`virtual_machine_id`,`tags_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of relation_virtual_machines_tags
-- ----------------------------

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL COMMENT '''角色名称''',
  `desc` varchar(128) DEFAULT NULL COMMENT '''角色描述''',
  `code` varchar(32) DEFAULT NULL COMMENT '''角色标识''',
  `permission_id` bigint(20) DEFAULT NULL COMMENT '''权限id外键''',
  PRIMARY KEY (`id`),
  KEY `idx_role_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '2021-09-18 12:32:05', '2023-05-13 16:19:28', null, '游客', '', 'guest', '1');
INSERT INTO `role` VALUES ('2', '2022-01-12 13:44:41', '2022-01-17 18:18:52', null, '管理员', '暂无', 'admin', '2');
INSERT INTO `role` VALUES ('3', '2022-01-12 14:35:37', '2022-02-12 12:44:38', null, '超级管理员', '超级管理员拥有所有权限', 'super', '0');

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色id',
  `permission_id` bigint(20) DEFAULT NULL COMMENT '权限id',
  PRIMARY KEY (`id`),
  KEY `idx_role_permission_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES ('1', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '3');
INSERT INTO `role_permission` VALUES ('2', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '5');
INSERT INTO `role_permission` VALUES ('3', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '10');
INSERT INTO `role_permission` VALUES ('4', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '13');
INSERT INTO `role_permission` VALUES ('5', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '14');
INSERT INTO `role_permission` VALUES ('6', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '17');
INSERT INTO `role_permission` VALUES ('7', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '38');
INSERT INTO `role_permission` VALUES ('8', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '41');
INSERT INTO `role_permission` VALUES ('9', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '43');
INSERT INTO `role_permission` VALUES ('10', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '46');
INSERT INTO `role_permission` VALUES ('11', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '47');
INSERT INTO `role_permission` VALUES ('12', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '49');
INSERT INTO `role_permission` VALUES ('13', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '54');
INSERT INTO `role_permission` VALUES ('14', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '60');
INSERT INTO `role_permission` VALUES ('15', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '62');
INSERT INTO `role_permission` VALUES ('16', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '64');
INSERT INTO `role_permission` VALUES ('17', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '68');
INSERT INTO `role_permission` VALUES ('18', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '70');
INSERT INTO `role_permission` VALUES ('19', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '72');
INSERT INTO `role_permission` VALUES ('20', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '76');
INSERT INTO `role_permission` VALUES ('21', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '77');
INSERT INTO `role_permission` VALUES ('22', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '81');
INSERT INTO `role_permission` VALUES ('23', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '82');
INSERT INTO `role_permission` VALUES ('24', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '86');
INSERT INTO `role_permission` VALUES ('25', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '87');
INSERT INTO `role_permission` VALUES ('26', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '90');
INSERT INTO `role_permission` VALUES ('27', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '91');
INSERT INTO `role_permission` VALUES ('28', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '98');
INSERT INTO `role_permission` VALUES ('29', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '99');
INSERT INTO `role_permission` VALUES ('30', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '100');
INSERT INTO `role_permission` VALUES ('31', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '101');
INSERT INTO `role_permission` VALUES ('32', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '114');
INSERT INTO `role_permission` VALUES ('33', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '116');
INSERT INTO `role_permission` VALUES ('34', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '118');
INSERT INTO `role_permission` VALUES ('35', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '119');
INSERT INTO `role_permission` VALUES ('36', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '132');
INSERT INTO `role_permission` VALUES ('37', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '134');
INSERT INTO `role_permission` VALUES ('38', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '135');
INSERT INTO `role_permission` VALUES ('39', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '136');
INSERT INTO `role_permission` VALUES ('40', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '137');
INSERT INTO `role_permission` VALUES ('41', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '146');
INSERT INTO `role_permission` VALUES ('42', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '147');
INSERT INTO `role_permission` VALUES ('43', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '149');
INSERT INTO `role_permission` VALUES ('44', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '151');
INSERT INTO `role_permission` VALUES ('45', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '152');
INSERT INTO `role_permission` VALUES ('46', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '153');
INSERT INTO `role_permission` VALUES ('47', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '155');
INSERT INTO `role_permission` VALUES ('48', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '157');
INSERT INTO `role_permission` VALUES ('49', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '158');
INSERT INTO `role_permission` VALUES ('50', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '159');
INSERT INTO `role_permission` VALUES ('51', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '170');
INSERT INTO `role_permission` VALUES ('52', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '171');
INSERT INTO `role_permission` VALUES ('53', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '191');
INSERT INTO `role_permission` VALUES ('54', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '192');
INSERT INTO `role_permission` VALUES ('55', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '196');
INSERT INTO `role_permission` VALUES ('56', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '219');
INSERT INTO `role_permission` VALUES ('57', '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', '1', '222');
INSERT INTO `role_permission` VALUES ('58', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '3');
INSERT INTO `role_permission` VALUES ('59', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '5');
INSERT INTO `role_permission` VALUES ('60', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '10');
INSERT INTO `role_permission` VALUES ('61', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '13');
INSERT INTO `role_permission` VALUES ('62', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '14');
INSERT INTO `role_permission` VALUES ('63', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '17');
INSERT INTO `role_permission` VALUES ('64', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '38');
INSERT INTO `role_permission` VALUES ('65', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '41');
INSERT INTO `role_permission` VALUES ('66', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '43');
INSERT INTO `role_permission` VALUES ('67', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '46');
INSERT INTO `role_permission` VALUES ('68', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '47');
INSERT INTO `role_permission` VALUES ('69', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '49');
INSERT INTO `role_permission` VALUES ('70', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '54');
INSERT INTO `role_permission` VALUES ('71', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '60');
INSERT INTO `role_permission` VALUES ('72', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '62');
INSERT INTO `role_permission` VALUES ('73', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '64');
INSERT INTO `role_permission` VALUES ('74', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '68');
INSERT INTO `role_permission` VALUES ('75', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '70');
INSERT INTO `role_permission` VALUES ('76', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '72');
INSERT INTO `role_permission` VALUES ('77', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '76');
INSERT INTO `role_permission` VALUES ('78', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '77');
INSERT INTO `role_permission` VALUES ('79', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '81');
INSERT INTO `role_permission` VALUES ('80', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '82');
INSERT INTO `role_permission` VALUES ('81', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '86');
INSERT INTO `role_permission` VALUES ('82', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '87');
INSERT INTO `role_permission` VALUES ('83', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '90');
INSERT INTO `role_permission` VALUES ('84', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '91');
INSERT INTO `role_permission` VALUES ('85', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '98');
INSERT INTO `role_permission` VALUES ('86', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '99');
INSERT INTO `role_permission` VALUES ('87', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '100');
INSERT INTO `role_permission` VALUES ('88', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '101');
INSERT INTO `role_permission` VALUES ('89', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '114');
INSERT INTO `role_permission` VALUES ('90', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '116');
INSERT INTO `role_permission` VALUES ('91', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '118');
INSERT INTO `role_permission` VALUES ('92', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '119');
INSERT INTO `role_permission` VALUES ('93', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '132');
INSERT INTO `role_permission` VALUES ('94', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '134');
INSERT INTO `role_permission` VALUES ('95', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '135');
INSERT INTO `role_permission` VALUES ('96', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '136');
INSERT INTO `role_permission` VALUES ('97', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '137');
INSERT INTO `role_permission` VALUES ('98', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '146');
INSERT INTO `role_permission` VALUES ('99', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '147');
INSERT INTO `role_permission` VALUES ('100', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '149');
INSERT INTO `role_permission` VALUES ('101', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '151');
INSERT INTO `role_permission` VALUES ('102', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '152');
INSERT INTO `role_permission` VALUES ('103', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '153');
INSERT INTO `role_permission` VALUES ('104', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '155');
INSERT INTO `role_permission` VALUES ('105', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '157');
INSERT INTO `role_permission` VALUES ('106', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '158');
INSERT INTO `role_permission` VALUES ('107', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '159');
INSERT INTO `role_permission` VALUES ('108', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '170');
INSERT INTO `role_permission` VALUES ('109', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '171');
INSERT INTO `role_permission` VALUES ('110', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '181');
INSERT INTO `role_permission` VALUES ('111', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '191');
INSERT INTO `role_permission` VALUES ('112', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '192');
INSERT INTO `role_permission` VALUES ('113', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '196');
INSERT INTO `role_permission` VALUES ('114', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '219');
INSERT INTO `role_permission` VALUES ('115', '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', '1', '222');
INSERT INTO `role_permission` VALUES ('116', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '3');
INSERT INTO `role_permission` VALUES ('117', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '5');
INSERT INTO `role_permission` VALUES ('118', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '10');
INSERT INTO `role_permission` VALUES ('119', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '13');
INSERT INTO `role_permission` VALUES ('120', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '14');
INSERT INTO `role_permission` VALUES ('121', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '17');
INSERT INTO `role_permission` VALUES ('122', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '38');
INSERT INTO `role_permission` VALUES ('123', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '41');
INSERT INTO `role_permission` VALUES ('124', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '43');
INSERT INTO `role_permission` VALUES ('125', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '46');
INSERT INTO `role_permission` VALUES ('126', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '47');
INSERT INTO `role_permission` VALUES ('127', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '49');
INSERT INTO `role_permission` VALUES ('128', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '54');
INSERT INTO `role_permission` VALUES ('129', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '60');
INSERT INTO `role_permission` VALUES ('130', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '62');
INSERT INTO `role_permission` VALUES ('131', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '64');
INSERT INTO `role_permission` VALUES ('132', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '68');
INSERT INTO `role_permission` VALUES ('133', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '70');
INSERT INTO `role_permission` VALUES ('134', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '72');
INSERT INTO `role_permission` VALUES ('135', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '76');
INSERT INTO `role_permission` VALUES ('136', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '77');
INSERT INTO `role_permission` VALUES ('137', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '81');
INSERT INTO `role_permission` VALUES ('138', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '82');
INSERT INTO `role_permission` VALUES ('139', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '86');
INSERT INTO `role_permission` VALUES ('140', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '87');
INSERT INTO `role_permission` VALUES ('141', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '90');
INSERT INTO `role_permission` VALUES ('142', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '91');
INSERT INTO `role_permission` VALUES ('143', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '98');
INSERT INTO `role_permission` VALUES ('144', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '99');
INSERT INTO `role_permission` VALUES ('145', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '100');
INSERT INTO `role_permission` VALUES ('146', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '101');
INSERT INTO `role_permission` VALUES ('147', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '114');
INSERT INTO `role_permission` VALUES ('148', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '116');
INSERT INTO `role_permission` VALUES ('149', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '118');
INSERT INTO `role_permission` VALUES ('150', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '119');
INSERT INTO `role_permission` VALUES ('151', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '132');
INSERT INTO `role_permission` VALUES ('152', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '134');
INSERT INTO `role_permission` VALUES ('153', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '135');
INSERT INTO `role_permission` VALUES ('154', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '136');
INSERT INTO `role_permission` VALUES ('155', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '137');
INSERT INTO `role_permission` VALUES ('156', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '146');
INSERT INTO `role_permission` VALUES ('157', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '147');
INSERT INTO `role_permission` VALUES ('158', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '149');
INSERT INTO `role_permission` VALUES ('159', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '151');
INSERT INTO `role_permission` VALUES ('160', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '152');
INSERT INTO `role_permission` VALUES ('161', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '153');
INSERT INTO `role_permission` VALUES ('162', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '155');
INSERT INTO `role_permission` VALUES ('163', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '157');
INSERT INTO `role_permission` VALUES ('164', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '158');
INSERT INTO `role_permission` VALUES ('165', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '159');
INSERT INTO `role_permission` VALUES ('166', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '170');
INSERT INTO `role_permission` VALUES ('167', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '171');
INSERT INTO `role_permission` VALUES ('168', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '181');
INSERT INTO `role_permission` VALUES ('169', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '191');
INSERT INTO `role_permission` VALUES ('170', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '192');
INSERT INTO `role_permission` VALUES ('171', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '196');
INSERT INTO `role_permission` VALUES ('172', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '219');
INSERT INTO `role_permission` VALUES ('173', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '222');
INSERT INTO `role_permission` VALUES ('174', '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', '1', '224');
INSERT INTO `role_permission` VALUES ('175', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '3');
INSERT INTO `role_permission` VALUES ('176', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '5');
INSERT INTO `role_permission` VALUES ('177', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '10');
INSERT INTO `role_permission` VALUES ('178', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '13');
INSERT INTO `role_permission` VALUES ('179', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '14');
INSERT INTO `role_permission` VALUES ('180', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '17');
INSERT INTO `role_permission` VALUES ('181', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '38');
INSERT INTO `role_permission` VALUES ('182', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '41');
INSERT INTO `role_permission` VALUES ('183', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '43');
INSERT INTO `role_permission` VALUES ('184', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '46');
INSERT INTO `role_permission` VALUES ('185', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '47');
INSERT INTO `role_permission` VALUES ('186', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '49');
INSERT INTO `role_permission` VALUES ('187', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '54');
INSERT INTO `role_permission` VALUES ('188', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '60');
INSERT INTO `role_permission` VALUES ('189', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '62');
INSERT INTO `role_permission` VALUES ('190', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '64');
INSERT INTO `role_permission` VALUES ('191', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '68');
INSERT INTO `role_permission` VALUES ('192', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '70');
INSERT INTO `role_permission` VALUES ('193', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '72');
INSERT INTO `role_permission` VALUES ('194', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '76');
INSERT INTO `role_permission` VALUES ('195', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '77');
INSERT INTO `role_permission` VALUES ('196', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '81');
INSERT INTO `role_permission` VALUES ('197', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '82');
INSERT INTO `role_permission` VALUES ('198', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '86');
INSERT INTO `role_permission` VALUES ('199', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '87');
INSERT INTO `role_permission` VALUES ('200', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '90');
INSERT INTO `role_permission` VALUES ('201', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '91');
INSERT INTO `role_permission` VALUES ('202', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '98');
INSERT INTO `role_permission` VALUES ('203', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '99');
INSERT INTO `role_permission` VALUES ('204', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '100');
INSERT INTO `role_permission` VALUES ('205', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '101');
INSERT INTO `role_permission` VALUES ('206', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '114');
INSERT INTO `role_permission` VALUES ('207', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '116');
INSERT INTO `role_permission` VALUES ('208', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '118');
INSERT INTO `role_permission` VALUES ('209', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '119');
INSERT INTO `role_permission` VALUES ('210', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '132');
INSERT INTO `role_permission` VALUES ('211', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '134');
INSERT INTO `role_permission` VALUES ('212', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '135');
INSERT INTO `role_permission` VALUES ('213', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '136');
INSERT INTO `role_permission` VALUES ('214', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '137');
INSERT INTO `role_permission` VALUES ('215', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '146');
INSERT INTO `role_permission` VALUES ('216', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '147');
INSERT INTO `role_permission` VALUES ('217', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '149');
INSERT INTO `role_permission` VALUES ('218', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '151');
INSERT INTO `role_permission` VALUES ('219', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '152');
INSERT INTO `role_permission` VALUES ('220', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '153');
INSERT INTO `role_permission` VALUES ('221', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '155');
INSERT INTO `role_permission` VALUES ('222', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '157');
INSERT INTO `role_permission` VALUES ('223', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '158');
INSERT INTO `role_permission` VALUES ('224', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '159');
INSERT INTO `role_permission` VALUES ('225', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '170');
INSERT INTO `role_permission` VALUES ('226', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '171');
INSERT INTO `role_permission` VALUES ('227', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '181');
INSERT INTO `role_permission` VALUES ('228', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '191');
INSERT INTO `role_permission` VALUES ('229', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '192');
INSERT INTO `role_permission` VALUES ('230', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '196');
INSERT INTO `role_permission` VALUES ('231', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '219');
INSERT INTO `role_permission` VALUES ('232', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '222');
INSERT INTO `role_permission` VALUES ('233', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '224');
INSERT INTO `role_permission` VALUES ('234', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '225');
INSERT INTO `role_permission` VALUES ('235', '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', '1', '226');
INSERT INTO `role_permission` VALUES ('236', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '3');
INSERT INTO `role_permission` VALUES ('237', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '5');
INSERT INTO `role_permission` VALUES ('238', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '10');
INSERT INTO `role_permission` VALUES ('239', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '13');
INSERT INTO `role_permission` VALUES ('240', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '14');
INSERT INTO `role_permission` VALUES ('241', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '17');
INSERT INTO `role_permission` VALUES ('242', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '38');
INSERT INTO `role_permission` VALUES ('243', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '41');
INSERT INTO `role_permission` VALUES ('244', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '43');
INSERT INTO `role_permission` VALUES ('245', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '46');
INSERT INTO `role_permission` VALUES ('246', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '47');
INSERT INTO `role_permission` VALUES ('247', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '49');
INSERT INTO `role_permission` VALUES ('248', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '54');
INSERT INTO `role_permission` VALUES ('249', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '60');
INSERT INTO `role_permission` VALUES ('250', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '62');
INSERT INTO `role_permission` VALUES ('251', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '64');
INSERT INTO `role_permission` VALUES ('252', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '68');
INSERT INTO `role_permission` VALUES ('253', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '70');
INSERT INTO `role_permission` VALUES ('254', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '72');
INSERT INTO `role_permission` VALUES ('255', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '76');
INSERT INTO `role_permission` VALUES ('256', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '77');
INSERT INTO `role_permission` VALUES ('257', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '81');
INSERT INTO `role_permission` VALUES ('258', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '82');
INSERT INTO `role_permission` VALUES ('259', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '86');
INSERT INTO `role_permission` VALUES ('260', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '87');
INSERT INTO `role_permission` VALUES ('261', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '90');
INSERT INTO `role_permission` VALUES ('262', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '91');
INSERT INTO `role_permission` VALUES ('263', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '98');
INSERT INTO `role_permission` VALUES ('264', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '99');
INSERT INTO `role_permission` VALUES ('265', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '100');
INSERT INTO `role_permission` VALUES ('266', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '101');
INSERT INTO `role_permission` VALUES ('267', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '114');
INSERT INTO `role_permission` VALUES ('268', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '116');
INSERT INTO `role_permission` VALUES ('269', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '118');
INSERT INTO `role_permission` VALUES ('270', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '119');
INSERT INTO `role_permission` VALUES ('271', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '132');
INSERT INTO `role_permission` VALUES ('272', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '134');
INSERT INTO `role_permission` VALUES ('273', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '135');
INSERT INTO `role_permission` VALUES ('274', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '136');
INSERT INTO `role_permission` VALUES ('275', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '137');
INSERT INTO `role_permission` VALUES ('276', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '146');
INSERT INTO `role_permission` VALUES ('277', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '147');
INSERT INTO `role_permission` VALUES ('278', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '149');
INSERT INTO `role_permission` VALUES ('279', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '151');
INSERT INTO `role_permission` VALUES ('280', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '152');
INSERT INTO `role_permission` VALUES ('281', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '153');
INSERT INTO `role_permission` VALUES ('282', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '155');
INSERT INTO `role_permission` VALUES ('283', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '157');
INSERT INTO `role_permission` VALUES ('284', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '158');
INSERT INTO `role_permission` VALUES ('285', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '159');
INSERT INTO `role_permission` VALUES ('286', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '170');
INSERT INTO `role_permission` VALUES ('287', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '171');
INSERT INTO `role_permission` VALUES ('288', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '181');
INSERT INTO `role_permission` VALUES ('289', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '191');
INSERT INTO `role_permission` VALUES ('290', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '192');
INSERT INTO `role_permission` VALUES ('291', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '196');
INSERT INTO `role_permission` VALUES ('292', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '197');
INSERT INTO `role_permission` VALUES ('293', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '219');
INSERT INTO `role_permission` VALUES ('294', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '222');
INSERT INTO `role_permission` VALUES ('295', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '224');
INSERT INTO `role_permission` VALUES ('296', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '225');
INSERT INTO `role_permission` VALUES ('297', '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', '1', '226');
INSERT INTO `role_permission` VALUES ('298', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '3');
INSERT INTO `role_permission` VALUES ('299', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '5');
INSERT INTO `role_permission` VALUES ('300', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '10');
INSERT INTO `role_permission` VALUES ('301', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '13');
INSERT INTO `role_permission` VALUES ('302', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '14');
INSERT INTO `role_permission` VALUES ('303', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '17');
INSERT INTO `role_permission` VALUES ('304', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '38');
INSERT INTO `role_permission` VALUES ('305', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '41');
INSERT INTO `role_permission` VALUES ('306', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '43');
INSERT INTO `role_permission` VALUES ('307', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '46');
INSERT INTO `role_permission` VALUES ('308', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '47');
INSERT INTO `role_permission` VALUES ('309', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '49');
INSERT INTO `role_permission` VALUES ('310', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '54');
INSERT INTO `role_permission` VALUES ('311', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '60');
INSERT INTO `role_permission` VALUES ('312', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '62');
INSERT INTO `role_permission` VALUES ('313', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '64');
INSERT INTO `role_permission` VALUES ('314', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '68');
INSERT INTO `role_permission` VALUES ('315', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '70');
INSERT INTO `role_permission` VALUES ('316', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '72');
INSERT INTO `role_permission` VALUES ('317', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '76');
INSERT INTO `role_permission` VALUES ('318', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '77');
INSERT INTO `role_permission` VALUES ('319', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '81');
INSERT INTO `role_permission` VALUES ('320', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '82');
INSERT INTO `role_permission` VALUES ('321', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '86');
INSERT INTO `role_permission` VALUES ('322', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '87');
INSERT INTO `role_permission` VALUES ('323', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '90');
INSERT INTO `role_permission` VALUES ('324', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '91');
INSERT INTO `role_permission` VALUES ('325', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '98');
INSERT INTO `role_permission` VALUES ('326', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '99');
INSERT INTO `role_permission` VALUES ('327', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '100');
INSERT INTO `role_permission` VALUES ('328', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '101');
INSERT INTO `role_permission` VALUES ('329', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '114');
INSERT INTO `role_permission` VALUES ('330', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '116');
INSERT INTO `role_permission` VALUES ('331', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '118');
INSERT INTO `role_permission` VALUES ('332', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '119');
INSERT INTO `role_permission` VALUES ('333', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '132');
INSERT INTO `role_permission` VALUES ('334', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '134');
INSERT INTO `role_permission` VALUES ('335', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '135');
INSERT INTO `role_permission` VALUES ('336', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '136');
INSERT INTO `role_permission` VALUES ('337', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '137');
INSERT INTO `role_permission` VALUES ('338', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '146');
INSERT INTO `role_permission` VALUES ('339', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '147');
INSERT INTO `role_permission` VALUES ('340', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '149');
INSERT INTO `role_permission` VALUES ('341', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '151');
INSERT INTO `role_permission` VALUES ('342', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '152');
INSERT INTO `role_permission` VALUES ('343', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '153');
INSERT INTO `role_permission` VALUES ('344', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '155');
INSERT INTO `role_permission` VALUES ('345', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '157');
INSERT INTO `role_permission` VALUES ('346', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '158');
INSERT INTO `role_permission` VALUES ('347', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '159');
INSERT INTO `role_permission` VALUES ('348', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '170');
INSERT INTO `role_permission` VALUES ('349', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '171');
INSERT INTO `role_permission` VALUES ('350', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '181');
INSERT INTO `role_permission` VALUES ('351', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '191');
INSERT INTO `role_permission` VALUES ('352', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '192');
INSERT INTO `role_permission` VALUES ('353', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '196');
INSERT INTO `role_permission` VALUES ('354', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '197');
INSERT INTO `role_permission` VALUES ('355', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '219');
INSERT INTO `role_permission` VALUES ('356', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '222');
INSERT INTO `role_permission` VALUES ('357', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '224');
INSERT INTO `role_permission` VALUES ('358', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '225');
INSERT INTO `role_permission` VALUES ('359', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '226');
INSERT INTO `role_permission` VALUES ('360', '2023-05-13 16:19:28', '2023-05-13 16:19:28', null, '1', '227');

-- ----------------------------
-- Table structure for ssh_global_config
-- ----------------------------
DROP TABLE IF EXISTS `ssh_global_config`;
CREATE TABLE `ssh_global_config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `username` varchar(191) DEFAULT NULL COMMENT '用户',
  `password` varchar(300) DEFAULT NULL COMMENT '密码',
  `private_key` text COMMENT '密钥',
  `enable` tinyint(1) DEFAULT NULL COMMENT '是否启用',
  `login_type` varchar(191) DEFAULT NULL COMMENT '登陆类型',
  `protocol` varchar(191) DEFAULT NULL COMMENT '协议',
  `desc` varchar(191) DEFAULT NULL COMMENT '备注',
  `port` varchar(191) DEFAULT '22' COMMENT '端口',
  `created_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of ssh_global_config
-- ----------------------------

-- ----------------------------
-- Table structure for ssh_record
-- ----------------------------
DROP TABLE IF EXISTS `ssh_record`;
CREATE TABLE `ssh_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `connect_id` varchar(64) DEFAULT NULL COMMENT '连接标识',
  `username` varchar(128) DEFAULT NULL COMMENT '用户',
  `hostname` varchar(128) DEFAULT NULL COMMENT '主机名',
  `connect_time` datetime DEFAULT NULL COMMENT '接入时间',
  `logout_time` datetime DEFAULT NULL COMMENT '注销时间',
  `records` longblob COMMENT '操作记录(二进制存储)',
  `host_id` bigint(20) DEFAULT NULL COMMENT '主机Id外键',
  `client_ip` varchar(191) DEFAULT NULL COMMENT '客户端地址',
  `user_agent` varchar(191) DEFAULT NULL COMMENT '浏览器标识',
  `ip_location` varchar(128) DEFAULT NULL COMMENT 'ip所在地',
  `protocol` varchar(10) DEFAULT NULL COMMENT '连接协议(rdp、ssh)',
  PRIMARY KEY (`id`),
  KEY `idx_ssh_record_deleted_at` (`deleted_at`),
  KEY `idx_ssh_record_connect_time` (`connect_time`),
  KEY `idx_ssh_record_logout_time` (`logout_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of ssh_record
-- ----------------------------

-- ----------------------------
-- Table structure for system_settings
-- ----------------------------
DROP TABLE IF EXISTS `system_settings`;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of system_settings
-- ----------------------------
INSERT INTO `system_settings` VALUES ('1', '2023-07-06 17:54:09', '2023-07-06 17:54:44', null, '0', '3', '60', '-1');

-- ----------------------------
-- Table structure for system_users
-- ----------------------------
DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users` (
  `assets_hosts_permissions_id` bigint(20) NOT NULL COMMENT '自增编号',
  `ssh_global_config_id` bigint(20) unsigned NOT NULL COMMENT '''自增编号''',
  PRIMARY KEY (`assets_hosts_permissions_id`,`ssh_global_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of system_users
-- ----------------------------

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `tag_key` varchar(191) DEFAULT NULL COMMENT '标签键',
  `tag_value` varchar(191) DEFAULT NULL COMMENT '标签值',
  PRIMARY KEY (`id`),
  KEY `idx_tags_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tags
-- ----------------------------

-- ----------------------------
-- Table structure for tunnel
-- ----------------------------
DROP TABLE IF EXISTS `tunnel`;
CREATE TABLE `tunnel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `tunnel_id` varchar(191) DEFAULT NULL COMMENT '隧道id',
  `mode` varchar(128) DEFAULT NULL COMMENT '模式, forward转发、proxy代理',
  `protocol` varchar(16) DEFAULT NULL COMMENT '协议, tcp、udp、http',
  `proxy_mode` varchar(32) DEFAULT NULL COMMENT '代理模式, forward正向代理、reverse反向代理、',
  `port` varchar(191) DEFAULT NULL COMMENT '端口',
  `dest_ip` varchar(191) DEFAULT NULL COMMENT '目标ip地址',
  `dest_port` varchar(191) DEFAULT NULL COMMENT '目标端口',
  `desc` varchar(191) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_tunnel_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tunnel
-- ----------------------------

-- ----------------------------
-- Table structure for user_login_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_login_logs`;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_login_logs
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `uid` varchar(191) DEFAULT NULL COMMENT '用戶uid',
  `username` varchar(128) DEFAULT NULL COMMENT '用户名',
  `password` varchar(128) DEFAULT NULL COMMENT '用户密码',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(128) DEFAULT NULL COMMENT '邮箱',
  `nickname` varchar(128) DEFAULT NULL,
  `avatar` varchar(128) DEFAULT 'https://www.dnsjia.com/luban/img/head.png' COMMENT '用户头像',
  `status` tinyint(1) DEFAULT '1' COMMENT '用户状态(正常/禁用, 默认正常)',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色id外键',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门id外键',
  `title` varchar(191) DEFAULT NULL COMMENT '职位',
  `create_by` varchar(191) DEFAULT NULL COMMENT '创建来源(ldap、local、dingtalk)',
  `mfa_secret` text COMMENT 'mfa密钥',
  `password_updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_users_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', '2021-09-18 12:30:28', '2023-08-06 15:31:07', null, '2', 'admin', '$2a$10$i.wJLtgaGreqPvRPPTOqIuRU6DoKb4WPN1uRPqD0y5xSdYWxtSM3u', '15012341234', 'luban@qq.com', '管理员', 'https://pic3.zhimg.com/v2-10ba6cb8ed5e922d5aa45f3a9abf7fba_xs.jpg?source=172ae18b', '1', '3', '1', '', '', null, '2023-08-06 14:48:26');

-- ----------------------------
-- Table structure for virtual_machines_tags
-- ----------------------------
DROP TABLE IF EXISTS `virtual_machines_tags`;
CREATE TABLE `virtual_machines_tags` (
  `virtual_machine_id` bigint(20) NOT NULL COMMENT '自增编号',
  `tags_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`virtual_machine_id`,`tags_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of virtual_machines_tags
-- ----------------------------

-- ----------------------------
-- Table structure for vm_env_config
-- ----------------------------
DROP TABLE IF EXISTS `vm_env_config`;
CREATE TABLE `vm_env_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deploy_path` varchar(191) DEFAULT '/data/webapps' COMMENT '部署路径',
  `'runuser'` varchar(191) DEFAULT 'luban' COMMENT '进程启动用户',
  `'framework'` varchar(191) DEFAULT NULL COMMENT '系统框架',
  `server_port` int(11) DEFAULT NULL COMMENT '服务端口(30000~50000)',
  `start_script` longtext COMMENT '启动脚本',
  `stop_script` longtext COMMENT '停止脚本',
  `check_script` longtext COMMENT '健康状态检查脚本',
  `'appctl'` longtext COMMENT '控制脚本',
  `package_path` varchar(191) DEFAULT NULL COMMENT '构建物路径',
  `is_enable_monitor` tinyint(1) DEFAULT '0' COMMENT '应用监控接入',
  `monitor_path` varchar(191) DEFAULT '/actuator/prometheus' COMMENT '采集路径',
  `monitor_port` int(11) DEFAULT '30030' COMMENT '采集端口',
  `tomcat_path` longtext COMMENT 'tomcat路径',
  `tomcat_port` int(11) DEFAULT '8080' COMMENT 'tomcat端口',
  `shutdown_port` int(11) DEFAULT NULL COMMENT 'tomcat关闭端口',
  `redirect_port` int(11) DEFAULT NULL COMMENT 'redirectPort',
  `ajp_port` int(11) DEFAULT NULL COMMENT 'ajpPort',
  PRIMARY KEY (`id`),
  KEY `idx_vm_env_config_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vm_env_config
-- ----------------------------

-- ----------------------------
-- Table structure for workflow_logs
-- ----------------------------
DROP TABLE IF EXISTS `workflow_logs`;
CREATE TABLE `workflow_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `task_id` varchar(191) DEFAULT NULL COMMENT '任务ID',
  `message` varchar(191) DEFAULT NULL COMMENT '信息',
  `status` varchar(191) DEFAULT NULL COMMENT '状态',
  `color` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workflow_logs_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of workflow_logs
-- ----------------------------
