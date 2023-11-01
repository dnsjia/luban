SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `app_container_envs`;
CREATE TABLE `app_container_envs` (
  `app_id` bigint(20) NOT NULL COMMENT '自增编号',
  `container_env_config_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`app_id`,`container_env_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `app_deploy_envs`;
CREATE TABLE `app_deploy_envs` (
  `app_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  `deploy_history_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  PRIMARY KEY (`app_id`,`deploy_history_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `app_virtual_machine_envs`;
CREATE TABLE `app_virtual_machine_envs` (
  `app_id` bigint(20) NOT NULL COMMENT '自增编号',
  `virtual_machine_env_config_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`app_id`,`virtual_machine_env_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `assets_hosts`;
CREATE TABLE `assets_hosts` (
  `assets_hosts_permissions_id` bigint(20) NOT NULL COMMENT '自增编号',
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`assets_hosts_permissions_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `assets_users`;
CREATE TABLE `assets_users` (
  `assets_hosts_permissions_id` bigint(20) NOT NULL COMMENT '自增编号',
  `user_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`assets_hosts_permissions_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1825 DEFAULT CHARSET=utf8mb4;


BEGIN;
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1790, 'p', 'guest', '/api/v1/apps', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1817, 'p', 'guest', '/api/v1/apps/autoscaling', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1791, 'p', 'guest', '/api/v1/apps/detail', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1813, 'p', 'guest', '/api/v1/apps/env', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1794, 'p', 'guest', '/api/v1/apps/envs', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1793, 'p', 'guest', '/api/v1/apps/instance', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1816, 'p', 'guest', '/api/v1/apps/metric', 'POST', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1803, 'p', 'guest', '/api/v1/cicd/deploy', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1802, 'p', 'guest', '/api/v1/cicd/deploy', 'POST', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1820, 'p', 'guest', '/api/v1/cicd/deploy/rollingUpdate', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1792, 'p', 'guest', '/api/v1/cicd/deploy/tags', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1824, 'p', 'guest', '/api/v1/cicd/dingtalk/workflow', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1818, 'p', 'guest', '/api/v1/cicd/git/branches', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1797, 'p', 'guest', '/api/v1/cicd/pipeline/:id', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1799, 'p', 'guest', '/api/v1/cicd/pipeline/build', 'POST', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1800, 'p', 'guest', '/api/v1/cicd/pipeline/build/:name', 'PUT', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1796, 'p', 'guest', '/api/v1/cicd/pipeline/runHistory/:id', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1795, 'p', 'guest', '/api/v1/cicd/pipelines', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1812, 'p', 'guest', '/api/v1/cicd/settings', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1798, 'p', 'guest', '/api/v1/cicd/tekton/pipeline', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1759, 'p', 'guest', '/api/v1/cmdb/host/assets/users', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1821, 'p', 'guest', '/api/v1/cmdb/host/file', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1822, 'p', 'guest', '/api/v1/cmdb/host/file', 'POST', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1823, 'p', 'guest', '/api/v1/cmdb/host/file/download', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1756, 'p', 'guest', '/api/v1/cmdb/host/groups', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1814, 'p', 'guest', '/api/v1/cmdb/host/server/resource', 'POST', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1755, 'p', 'guest', '/api/v1/cmdb/host/servers', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1758, 'p', 'guest', '/api/v1/cmdb/host/ssh/nodes-assets/tree', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1760, 'p', 'guest', '/api/v1/cmdb/host/ssh/users', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1762, 'p', 'guest', '/api/v1/k8s/cluster', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1761, 'p', 'guest', '/api/v1/k8s/clusters', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1779, 'p', 'guest', '/api/v1/k8s/cronjob', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1778, 'p', 'guest', '/api/v1/k8s/cronjobs', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1775, 'p', 'guest', '/api/v1/k8s/daemonset', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1774, 'p', 'guest', '/api/v1/k8s/daemonsets', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1770, 'p', 'guest', '/api/v1/k8s/deployment', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1771, 'p', 'guest', '/api/v1/k8s/deployment/service', 'POST', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1769, 'p', 'guest', '/api/v1/k8s/deployments', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1763, 'p', 'guest', '/api/v1/k8s/event', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1777, 'p', 'guest', '/api/v1/k8s/job', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1776, 'p', 'guest', '/api/v1/k8s/jobs', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1782, 'p', 'guest', '/api/v1/k8s/log/:namespace/:pod', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1783, 'p', 'guest', '/api/v1/k8s/log/:namespace/:pod/:container', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1784, 'p', 'guest', '/api/v1/k8s/log/file/:namespace/:pod/:container', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1785, 'p', 'guest', '/api/v1/k8s/log/source/:namespace/:resourceName/:resourceType', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1766, 'p', 'guest', '/api/v1/k8s/namespace/limitranges', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1765, 'p', 'guest', '/api/v1/k8s/namespace/resourcequotas', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1764, 'p', 'guest', '/api/v1/k8s/namespaces', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1787, 'p', 'guest', '/api/v1/k8s/network/ingress', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1786, 'p', 'guest', '/api/v1/k8s/network/ingresss', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1789, 'p', 'guest', '/api/v1/k8s/network/service', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1788, 'p', 'guest', '/api/v1/k8s/network/services', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1768, 'p', 'guest', '/api/v1/k8s/node', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1767, 'p', 'guest', '/api/v1/k8s/nodes', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1781, 'p', 'guest', '/api/v1/k8s/pod', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1780, 'p', 'guest', '/api/v1/k8s/pods', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1773, 'p', 'guest', '/api/v1/k8s/statefulset', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1772, 'p', 'guest', '/api/v1/k8s/statefulsets', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1810, 'p', 'guest', '/api/v1/menu', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1809, 'p', 'guest', '/api/v1/menu/role', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1815, 'p', 'guest', '/api/v1/monitoring/describeMetric', 'POST', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1757, 'p', 'guest', '/api/v1/tree/host/group', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1811, 'p', 'guest', '/api/v1/tree/menu', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1808, 'p', 'guest', '/api/v1/tree/menu/role', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1805, 'p', 'guest', '/api/v1/user/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1806, 'p', 'guest', '/api/v1/user/profile', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1807, 'p', 'guest', '/api/v1/user/profile', 'PUT', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1801, 'p', 'guest', '/api/v1/ws/build/detail', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1804, 'p', 'guest', '/api/v1/ws/deploy/:id', 'GET', '', '', '');
INSERT INTO `casbin_rule` (`id`, `ptype`, `v0`, `v1`, `v2`, `v3`, `v4`, `v5`) VALUES (1819, 'p', 'guest', '/api/v1/ws/webssh', 'GET', '', '', '');
COMMIT;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `cloud_virtual_machine`;
CREATE TABLE `cloud_virtual_machine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(191) DEFAULT NULL,
  `hostname` varchar(191) DEFAULT NULL COMMENT '''主机名''',
  `cpu` bigint(20) DEFAULT NULL COMMENT '''CPU''',
  `os_type` varchar(191) DEFAULT NULL COMMENT '''系统类型''',
  `mac_addr` varchar(191) DEFAULT NULL COMMENT '''物理地址''',
  `private_addr` varchar(191) DEFAULT NULL COMMENT '''私网地址''',
  `public_addr` varchar(191) DEFAULT NULL COMMENT '''公网地址''',
  `sn` varchar(191) DEFAULT NULL COMMENT '''SN序列号''',
  `bandwidth` bigint(20) DEFAULT NULL COMMENT '''带宽''',
  `status` varchar(191) DEFAULT NULL,
  `region` varchar(191) DEFAULT NULL COMMENT '''机房''',
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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `container_env_config`;
CREATE TABLE `container_env_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `env_name` varchar(191) DEFAULT NULL COMMENT '''环境名称''',
  `instance_num` bigint(20) DEFAULT NULL COMMENT '''应用实例数''',
  `probe_mode` varchar(32) DEFAULT NULL COMMENT '''探测方式(HTTP、TCP)''',
  `check_path` varchar(64) DEFAULT NULL COMMENT '''健康检查路径''',
  `port` int(11) DEFAULT NULL COMMENT '''端口''',
  `cpu_request` int(11) DEFAULT '1' COMMENT '''CPU请求(Core)''',
  `cpu_limit` int(11) DEFAULT NULL COMMENT '''CPU限制(Core)''',
  `memory_request` int(11) DEFAULT NULL COMMENT '''内存请求(MB)''',
  `memory_limit` int(11) DEFAULT NULL COMMENT '''内存限制(MB)''',
  `package_path` varchar(191) DEFAULT NULL COMMENT '''构建物路径''',
  `docker_file_path` varchar(191) DEFAULT NULL COMMENT '''编排文件路径''',
  `is_enable_log` tinyint(1) DEFAULT NULL COMMENT '''采集日志''',
  `monitor_enable` tinyint(1) DEFAULT '0' COMMENT '''应用监控接入''',
  `monitor_path` varchar(191) DEFAULT '/actuator/prometheus' COMMENT '''采集路径''',
  `monitor_port` int(11) DEFAULT '30030' COMMENT '''采集端口''',
  `mesh_enable` tinyint(1) DEFAULT '0' COMMENT '''是否服务网格''',
  `support_restart` tinyint(1) DEFAULT '1' COMMENT '''支持重启''',
  PRIMARY KEY (`id`),
  KEY `idx_container_env_config_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `deploy_history_apps`;
CREATE TABLE `deploy_history_apps` (
  `deploy_history_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  `app_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  PRIMARY KEY (`deploy_history_id`,`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;


DROP TABLE IF EXISTS `deploy_history_container_envs`;
CREATE TABLE `deploy_history_container_envs` (
  `deploy_history_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  `container_env_config_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  PRIMARY KEY (`deploy_history_id`,`container_env_config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;


DROP TABLE IF EXISTS `deploy_history_virtual_machine_envs`;
CREATE TABLE `deploy_history_virtual_machine_envs` (
  `deploy_history_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  `virtual_machine_env_config_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  PRIMARY KEY (`deploy_history_id`,`virtual_machine_env_config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;


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


DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL COMMENT '''部门名称''',
  `sort` int(3) DEFAULT '0' COMMENT '''排序''',
  `parent_id` bigint(20) unsigned DEFAULT '0' COMMENT '''父级部门(编号为0时表示根)''',
  PRIMARY KEY (`id`),
  KEY `idx_dept_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dept
-- ----------------------------
BEGIN;
INSERT INTO `dept` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `sort`, `parent_id`) VALUES (1, '2021-09-24 15:56:54', '2021-09-24 15:56:57', NULL, '技术部', 0, 0);
INSERT INTO `dept` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `sort`, `parent_id`) VALUES (2, '2022-01-07 22:37:51', '2022-01-07 22:37:56', NULL, '测试组', 0, 1);
COMMIT;


DROP TABLE IF EXISTS `docker_hosts`;
CREATE TABLE `docker_hosts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '''标识''',
  `host` varchar(191) DEFAULT NULL COMMENT '''主机''',
  `port` bigint(20) DEFAULT '2375' COMMENT '''端口''',
  `desc` varchar(191) DEFAULT NULL COMMENT '''备注''',
  PRIMARY KEY (`id`),
  KEY `idx_docker_hosts_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `hosts_group`;
CREATE TABLE `hosts_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `parent_id` bigint(20) DEFAULT '0',
  `hide` bigint(20) DEFAULT '0',
  `sort_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of hosts_group
-- ----------------------------
BEGIN;
INSERT INTO `hosts_group` (`id`, `name`, `parent_id`, `hide`, `sort_id`) VALUES (1, 'Default', 0, 0, 0);
INSERT INTO `hosts_group` (`id`, `name`, `parent_id`, `hide`, `sort_id`) VALUES (2, '腾讯云', 0, 0, 1);
INSERT INTO `hosts_group` (`id`, `name`, `parent_id`, `hide`, `sort_id`) VALUES (3, '阿里云', 0, 0, 2);
INSERT INTO `hosts_group` (`id`, `name`, `parent_id`, `hide`, `sort_id`) VALUES (4, '华东一区', 3, 0, 2);
INSERT INTO `hosts_group` (`id`, `name`, `parent_id`, `hide`, `sort_id`) VALUES (5, '华东二区', 3, 0, 1);
COMMIT;


DROP TABLE IF EXISTS `hosts_group_virtual_machines`;
CREATE TABLE `hosts_group_virtual_machines` (
  `tree_menu_id` bigint(20) NOT NULL,
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`tree_menu_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `job_meta`;
CREATE TABLE `job_meta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '''自增编号''',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `job_id` varchar(191) DEFAULT NULL COMMENT '''任务ID''',
  `job_name` varchar(191) DEFAULT NULL COMMENT '''任务名称''',
  `user_name` varchar(191) DEFAULT NULL COMMENT '''执行用户''',
  `script_type` varchar(191) DEFAULT NULL COMMENT '''执行类型(ShellScript、PowerShell、Python)''',
  `timeout` bigint(20) DEFAULT NULL COMMENT '''超时时间''',
  `script` varchar(191) DEFAULT NULL COMMENT '''脚本内容''',
  `args` varchar(191) DEFAULT NULL COMMENT '''脚本参数''',
  `creator` varchar(191) DEFAULT NULL COMMENT '''创建者''',
  `hosts_raw` varchar(191) DEFAULT NULL COMMENT '''执行主机列表''',
  `status` bigint(20) DEFAULT NULL COMMENT '''任务状态(Aborted、Failed、Success)''',
  PRIMARY KEY (`id`),
  KEY `idx_job_meta_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `job_result`;
CREATE TABLE `job_result` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `job_id` bigint(20) DEFAULT NULL,
  `host` varchar(191) DEFAULT NULL,
  `status` varchar(191) DEFAULT NULL,
  `stdout` longtext,
  `stderr` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_job_result_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `jump_gateway`;
CREATE TABLE `jump_gateway` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '网关名称',
  `ip` varchar(191) DEFAULT NULL,
  `username` varchar(191) DEFAULT NULL COMMENT '用户',
  `password` varchar(300) DEFAULT NULL COMMENT '''密码''',
  `private_key` text COMMENT '''密钥''',
  `enable` tinyint(1) DEFAULT NULL COMMENT '''是否启用''',
  `login_type` varchar(191) DEFAULT NULL COMMENT '''登陆类型''',
  `protocol` varchar(191) DEFAULT NULL COMMENT '''协议''',
  `desc` varchar(191) DEFAULT NULL COMMENT '''备注''',
  `port` varchar(191) DEFAULT '22' COMMENT '''端口''',
  PRIMARY KEY (`id`),
  KEY `idx_jump_gateway_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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


BEGIN;
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (1, '2022-02-11 15:41:58', NULL, NULL, '仪表盘', 'pigs-icon-ziyuan', '/', 0, 0);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (2, '2022-02-11 15:49:48', NULL, NULL, '资产管理', 'pigs-icon-fuwuqi1', NULL, 0, 0);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (3, '2022-02-11 15:50:23', NULL, NULL, '服务器', '', '/cmdb/server', 1, 2);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (4, '2022-04-30 14:02:53', '2023-02-23 15:26:52', NULL, '系统用户', '', '/cmdb/system/user', 2, 2);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (5, '2022-05-20 15:01:48', NULL, NULL, '资产授权', '', '/cmdb/server/permissions', 3, 2);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (6, '2022-12-12 14:14:36', NULL, NULL, '中转网关', '', '/cmdb/jump/gateway', 4, 2);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (7, '2022-02-11 15:50:27', NULL, NULL, '容器管理', 'pigs-icon-Kubernetes', '', 0, 0);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (8, '2022-02-11 15:50:31', NULL, NULL, '集群管理', NULL, '/k8s/cluster', 1, 7);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (9, '2022-12-29 09:57:17', NULL, NULL, '命名空间', '', '/k8s/namespace', 2, 7);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (10, '2022-02-11 15:52:51', NULL, NULL, '节点管理', NULL, '/k8s/node', 3, 7);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (11, '2022-02-11 15:53:00', NULL, NULL, '工作负载', NULL, '/k8s/workload', 4, 7);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (12, '2022-02-11 15:53:06', NULL, NULL, '存储管理', NULL, '/k8s/storage', 5, 7);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (13, '2022-02-11 15:53:10', NULL, NULL, '网络管理', NULL, '/k8s/network', 6, 7);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (14, '2022-02-11 15:53:14', NULL, NULL, '配置管理', NULL, '/k8s/config', 7, 7);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (15, '2022-02-11 15:53:18', NULL, NULL, '事件中心', NULL, '/k8s/event', 8, 7);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (19, '2022-02-13 11:38:50', NULL, NULL, '应用发布', 'pigs-icon-gengduoyingyong', NULL, 0, 0);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (20, '2022-02-13 11:38:50', NULL, NULL, '应用管理', NULL, '/application/manage', 1, 19);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (21, '2022-02-13 11:38:50', NULL, NULL, '凭证管理', '', '/application/pipeline/credential', 2, 19);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (22, '2022-09-27 21:06:26', NULL, NULL, '构建中心', '', '/application/pipelines', 3, 19);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (23, '2022-02-13 11:38:50', NULL, NULL, '发布申请', '', '/application/apps/deploy', 4, 19);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (24, '2022-02-13 11:38:50', NULL, NULL, '系统管理', 'pigs-icon-yonghuzhongxin_shezhizhongxin', NULL, 0, 0);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (25, '2022-02-13 11:38:50', NULL, NULL, '用户管理', NULL, '/user/manage', 1, 24);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (26, '2022-02-13 11:38:50', NULL, NULL, '角色管理', NULL, '/role/manage', 2, 24);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (27, '2022-02-13 11:38:50', NULL, NULL, '接口管理', NULL, '/grantApi/manage', 3, 24);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (28, '2022-02-13 11:38:50', NULL, NULL, '菜单管理', NULL, '/menu/manage', 4, 24);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (29, '2022-11-28 18:36:42', NULL, NULL, '系统设置', '', '/system/settings', 5, 24);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (30, '2022-08-23 14:27:48', NULL, NULL, '运维工具', 'pigs-icon-bushu', '', 0, 0);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (32, '2023-01-18 20:04:09', NULL, NULL, '隧道转发', '', '/tools/tunnel', 2, 30);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (33, '2022-11-04 15:50:19', NULL, NULL, '操作审计', 'pigs-icon-anquanshenji', '', 0, 0);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (34, '2022-11-04 15:51:21', NULL, NULL, '终端录像', '', '/audit/terminal', 0, 33);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (35, '2023-01-06 18:47:10', NULL, NULL, '容器录像', '', '/audit/pod/terminal', 3, 33);
INSERT INTO `menu` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `icon`, `path`, `sort`, `parent_id`) VALUES (36, '2022-12-21 16:57:57', NULL, NULL, '行为记录', '', '/audit/api', 2, 33);
COMMIT;


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
  `provider` varchar(191) DEFAULT NULL COMMENT 'ali、tencent、huawei、aws',
  PRIMARY KEY (`id`),
  KEY `idx_oss_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=246 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of permissions
-- ----------------------------
BEGIN;
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (1, NULL, NULL, NULL, 4, '资产管理', 1, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (2, NULL, NULL, NULL, 1, '服务器', 1, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (3, '2023-02-23 11:29:10', '2023-02-23 11:29:10', NULL, 2, '获取服务器资产列表', 0, '/api/v1/cmdb/host/servers', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (4, '2022-01-20 14:41:50', NULL, NULL, 0, '所有权限', 1, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (5, '2023-02-23 11:31:56', '2023-02-23 11:31:56', NULL, 2, '获取服务器分组列表', 0, '/api/v1/cmdb/host/groups', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (6, '2023-02-23 13:09:33', '2023-02-23 13:09:33', NULL, 2, '修改资产分组', 0, '/api/v1/cmdb/host/group', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (7, '2023-02-23 13:09:55', '2023-02-23 13:09:55', NULL, 2, '删除资产分组下的所有主机', 0, '/api/v1/cmdb/host/server', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (8, '2023-02-23 13:10:18', '2023-02-23 13:10:18', NULL, 2, '删除资产分组', 0, '/api/v1/cmdb/host/group', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (9, '2023-02-23 13:10:39', '2023-02-23 13:10:39', NULL, 2, '添加云资源同步', 0, '/api/v1/cloud/account', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (10, '2023-02-23 13:11:04', '2023-02-23 13:11:04', NULL, 2, '获取资产分组树', 0, '/api/v1/tree/host/group', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (11, '2023-02-23 13:11:20', '2023-02-23 13:11:20', NULL, 2, '导入资产文件上传', 0, '/api/v1/cmdb/host/import/file', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (12, '2023-02-23 13:11:39', '2023-02-23 13:11:39', NULL, 2, '资产导入', 0, '/api/v1/cmdb/host/import', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (13, '2023-02-23 13:11:53', '2023-02-23 13:11:53', NULL, 2, '获取资产连接右侧节点树', 0, '/api/v1/cmdb/host/ssh/nodes-assets/tree', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (14, '2023-02-23 13:12:49', '2023-02-23 13:12:49', NULL, 2, '获取资产授权用户', 0, '/api/v1/cmdb/host/assets/users', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (15, '2023-02-23 13:13:26', '2023-02-23 13:13:26', NULL, 2, '删除主机', 0, '/api/v1/cmdb/host/servers', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (16, NULL, NULL, NULL, 1, '系统用户', 2, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (17, '2023-02-23 13:18:05', '2023-02-23 13:18:05', NULL, 16, '获取系统用户列表', 0, '/api/v1/cmdb/host/ssh/users', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (18, '2023-02-23 13:18:21', '2023-02-23 13:18:21', NULL, 16, '添加系统用户', 0, '/api/v1/cmdb/host/ssh/user', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (19, '2023-02-23 13:18:35', '2023-02-23 13:18:35', NULL, 16, '删除系统用户', 0, '/api/v1/cmdb/host/ssh/users', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (20, '2023-02-23 13:18:52', '2023-02-23 13:18:52', NULL, 16, '禁用/启用系统用户', 0, '/api/v1/cmdb/host/ssh/users', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (21, '2023-02-23 13:19:08', '2023-02-23 13:19:08', NULL, 16, '更新系统用户', 0, '/api/v1/cmdb/host/ssh/users/:id', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (22, NULL, NULL, NULL, 1, '资产授权', 3, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (23, '2023-02-23 13:20:13', '2023-02-23 13:21:01', NULL, 22, '获取资产授权列表', 0, '/api/v1/cmdb/host/assets', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (24, '2023-02-23 13:20:52', '2023-02-23 13:20:52', NULL, 22, '创建资产授权-不分页获取用户', 0, '/api/v1/user/nopage', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (25, '2023-02-23 13:21:22', '2023-02-23 13:21:22', NULL, 22, '创建资产授权', 0, '/api/v1/cmdb/host/assets', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (26, '2023-02-23 13:21:38', '2023-02-23 13:21:38', NULL, 22, '查看资产授权详情', 0, '/api/v1/cmdb/host/assets/:id', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (27, '2023-02-23 13:21:52', '2023-02-23 13:21:52', NULL, 22, '更新资产授权', 0, '/api/v1/cmdb/host/assets/:id', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (28, '2023-02-23 13:22:12', '2023-02-23 13:22:12', NULL, 22, '禁用/启用资产授权', 0, '/api/v1/cmdb/host/assets/status', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (29, '2023-02-23 13:22:29', '2023-02-23 13:22:29', NULL, 22, '删除资产授权', 0, '/api/v1/cmdb/host/assets', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (30, NULL, NULL, NULL, 1, '中转网关', 4, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (31, '2023-02-23 13:23:29', '2023-02-23 13:23:29', NULL, 30, '获取中转网关列表', 0, '/api/v1/cmdb/jump/gateway', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (32, '2023-02-23 13:23:42', '2023-02-23 13:23:42', NULL, 30, '禁用/启用中转网关', 0, '/api/v1/cmdb/jump/gateway/status', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (33, '2023-02-23 13:24:00', '2023-02-23 13:24:00', NULL, 30, '更新中转网关', 0, '/api/v1/cmdb/jump/gateway/:id', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (34, '2023-02-23 13:24:14', '2023-02-23 13:24:14', NULL, 30, '删除中转网关', 0, '/api/v1/cmdb/jump/gateway', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (35, '2023-02-23 13:24:25', '2023-02-23 13:24:25', NULL, 30, '创建中转网关', 0, '/api/v1/cmdb/jump/gateway', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (36, NULL, NULL, NULL, 4, '容器管理', 2, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (37, NULL, NULL, NULL, 36, '集群管理', 1, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (38, '2023-02-23 13:27:34', '2023-02-23 13:27:34', NULL, 37, '获取容器集群列表', 0, '/api/v1/k8s/clusters', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (39, '2023-02-23 13:27:47', '2023-02-23 13:27:47', NULL, 37, '新增容器集群', 0, '/api/v1/k8s/cluster', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (40, '2023-02-23 13:28:02', '2023-02-23 13:28:14', NULL, 37, '批量删除容器集群', 0, '/api/v1/k8s/clusters', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (41, '2023-02-23 13:28:49', '2023-02-23 13:28:49', NULL, 37, '查看容器集群详情', 0, '/api/v1/k8s/cluster', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (42, '2023-02-23 13:29:04', '2023-02-23 13:29:04', NULL, 37, '查看容器集群凭证', 0, '/api/v1/k8s/cluster/secret', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (43, '2023-02-23 13:29:19', '2023-02-23 13:29:19', NULL, 37, '查看容器集群事件', 0, '/api/v1/k8s/event', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (44, '2023-02-23 13:29:31', '2023-02-23 13:29:31', NULL, 37, '更新集群', 0, '/api/v1/k8s/cluster', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (45, NULL, NULL, NULL, 36, '命名空间', 2, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (46, '2023-02-23 13:31:03', '2023-02-23 13:31:03', NULL, 45, '获取命名空间列表', 0, '/api/v1/k8s/namespaces', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (47, '2023-02-23 13:31:22', '2023-02-23 13:31:22', NULL, 45, '获取命名空间-资源配额', 0, '/api/v1/k8s/namespace/resourcequotas', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (48, '2023-02-23 13:31:38', '2023-02-23 13:31:38', NULL, 45, '创建命名空间-资源配额', 0, '/api/v1/k8s/namespace/resourcequotas', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (49, '2023-02-23 13:31:55', '2023-02-23 13:31:55', NULL, 45, '获取命名空间-资源限制', 0, '/api/v1/k8s/namespace/limitranges', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (50, '2023-02-23 13:32:07', '2023-02-23 13:32:07', NULL, 45, '创建命名空间-资源限制', 0, '/api/v1/k8s/namespace/limitranges', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (51, '2023-02-23 13:32:42', '2023-02-23 13:32:42', NULL, 45, '创建命名空间', 0, '/api/v1/k8s/namespaces', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (52, '2023-02-23 13:32:54', '2023-02-23 13:32:54', NULL, 45, '删除命名空间', 0, '/api/v1/k8s/namespaces', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (53, NULL, NULL, NULL, 36, '节点管理', 3, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (54, '2023-02-23 13:34:48', '2023-02-23 13:34:48', NULL, 53, '获取节点列表', 0, '/api/v1/k8s/nodes', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (55, '2023-02-23 13:35:03', '2023-02-23 13:35:03', NULL, 53, '删除节点', 0, '/api/v1/k8s/node', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (56, '2023-02-23 13:35:28', '2023-02-23 13:35:28', NULL, 53, '批量设置节点排水', 0, '/api/v1/k8s/node/collectionCordon', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (57, '2023-02-23 13:35:43', '2023-02-23 13:35:43', NULL, 53, '批量设置节点调度', 0, '/api/v1/k8s/node/collectionSchedule', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (58, '2023-02-23 13:35:59', '2023-02-23 13:35:59', NULL, 53, '节点排水', 0, '/api/v1/k8s/node/cordon', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (59, '2023-02-23 13:36:14', '2023-02-23 13:36:14', NULL, 53, '节点调度', 0, '/api/v1/k8s/node/schedule', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (60, '2023-02-23 13:36:29', '2023-02-23 13:36:29', NULL, 53, '查看节点详情', 0, '/api/v1/k8s/node', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (61, NULL, NULL, NULL, 36, '工作负载', 4, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (62, '2023-02-23 13:41:59', '2023-02-23 13:41:59', NULL, 61, '获取无状态列表', 0, '/api/v1/k8s/deployments', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (63, '2023-02-23 13:42:19', '2023-02-23 13:42:19', NULL, 61, '删除无状态', 0, '/api/v1/k8s/deployment/delete', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (64, '2023-02-23 13:42:31', '2023-02-23 13:42:31', NULL, 61, '查看无状态详情', 0, '/api/v1/k8s/deployment', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (65, '2023-02-23 13:42:45', '2023-02-23 13:42:45', NULL, 61, '重启无状态', 0, '/api/v1/k8s/deployment/restart', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (66, '2023-02-23 13:43:00', '2023-02-23 13:43:00', NULL, 61, '回滚无状态', 0, '/api/v1/k8s/deployment/rollback', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (67, '2023-02-23 13:43:19', '2023-02-23 13:43:19', NULL, 61, '伸缩无状态', 0, '/api/v1/k8s/deployment/scale', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (68, '2023-02-23 13:43:40', '2023-02-23 13:43:40', NULL, 61, '根据无状态获取关联服务', 0, '/api/v1/k8s/deployment/service', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (69, '2023-02-23 13:43:55', '2023-02-23 13:43:55', NULL, 61, '批量删除无状态', 0, '/api/v1/k8s/deployments', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (70, '2023-02-23 13:47:17', '2023-02-23 13:47:17', NULL, 61, '获取有状态列表', 0, '/api/v1/k8s/statefulsets', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (71, '2023-02-23 13:47:32', '2023-02-23 13:47:32', NULL, 61, '删除有状态', 0, '/api/v1/k8s/statefulset', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (72, '2023-02-23 13:47:49', '2023-02-23 13:47:49', NULL, 61, '查看有状态详情', 0, '/api/v1/k8s/statefulset', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (73, '2023-02-23 13:48:15', '2023-02-23 13:48:15', NULL, 61, '重启有状态', 0, '/api/v1/k8s/statefulset/restart', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (74, '2023-02-23 13:48:26', '2023-02-23 13:48:26', NULL, 61, '伸缩容有状态', 0, '/api/v1/k8s/statefulset/scale', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (75, '2023-02-23 13:48:43', '2023-02-23 13:48:43', NULL, 61, '批量删除有状态', 0, '/api/v1/k8s/statefulsets', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (76, '2023-02-23 13:49:32', '2023-02-23 13:49:32', NULL, 61, '获取守护进程集列表', 0, '/api/v1/k8s/daemonsets', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (77, '2023-02-23 13:49:44', '2023-02-23 13:49:44', NULL, 61, '查看守护进程集详情', 0, '/api/v1/k8s/daemonset', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (78, '2023-02-23 13:50:04', '2023-02-23 13:50:04', NULL, 61, '批量删除守护进程集', 0, '/api/v1/k8s/daemonsets', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (79, '2023-02-23 13:50:19', '2023-02-23 13:50:19', NULL, 61, '删除守护进程集', 0, '/api/v1/k8s/daemonset', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (80, '2023-02-23 13:50:31', '2023-02-23 13:50:31', NULL, 61, '重启守护进程集', 0, '/api/v1/k8s/daemonset/restart', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (81, '2023-02-23 13:52:48', '2023-02-23 13:52:48', NULL, 61, '获取任务列表', 0, '/api/v1/k8s/jobs', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (82, '2023-02-23 13:52:59', '2023-02-23 13:52:59', NULL, 61, '查看任务详情', 0, '/api/v1/k8s/job', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (83, '2023-02-23 13:53:11', '2023-02-23 13:53:11', NULL, 61, '删除任务', 0, '/api/v1/k8s/job', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (84, '2023-02-23 13:53:25', '2023-02-23 13:53:25', NULL, 61, '伸缩容任务', 0, '/api/v1/k8s/job/scale', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (85, '2023-02-23 13:53:41', '2023-02-23 13:53:41', NULL, 61, '批量删除任务', 0, '/api/v1/k8s/jobs', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (86, '2023-02-23 13:53:53', '2023-02-23 13:53:53', NULL, 61, '获取定时任务列表', 0, '/api/v1/k8s/cronjobs', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (87, '2023-02-23 13:54:03', '2023-02-23 13:54:03', NULL, 61, '查看定时任务详情', 0, '/api/v1/k8s/cronjob', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (88, '2023-02-23 13:54:16', '2023-02-23 13:54:16', NULL, 61, '批量删除定时任务', 0, '/api/v1/k8s/cronjobs', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (89, '2023-02-23 13:54:31', '2023-02-23 13:54:31', NULL, 61, '删除定时任务', 0, '/api/v1/k8s/cronjob', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (90, '2023-02-23 13:56:01', '2023-02-23 13:56:01', NULL, 61, '获取容器组列表', 0, '/api/v1/k8s/pods', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (91, '2023-02-23 13:56:12', '2023-02-23 13:56:12', NULL, 61, '查看容器组详情', 0, '/api/v1/k8s/pod', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (92, '2023-02-23 13:56:30', '2023-02-23 13:56:30', NULL, 61, '删除容器组', 0, '/api/v1/k8s/pod', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (93, '2023-02-23 13:56:43', '2023-02-23 13:56:43', NULL, 61, '批量删除容器组', 0, '/api/v1/k8s/pods', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (94, NULL, NULL, NULL, 36, '终端-日志', 5, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (95, '2023-02-23 13:57:53', '2023-02-23 13:57:53', NULL, 94, '获取容器终端大小', 0, '/api/v1/ws/podssh/tty/:id/:id/:id', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (96, '2023-02-23 13:58:04', '2023-02-23 13:58:04', NULL, 94, '获取容器终端信息', 0, '/api/v1/ws/podssh/tty/info', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (97, '2023-02-23 13:58:19', '2023-02-23 13:58:19', NULL, 94, '连接容器终端会话', 0, '/api/v1/k8s/pod/ssh', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (98, '2023-02-23 13:58:38', '2023-02-23 13:58:38', NULL, 94, '获取容器日志内容', 0, '/api/v1/k8s/log/:namespace/:pod', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (99, '2023-02-23 13:58:52', '2023-02-23 13:58:52', NULL, 94, '动态查看容器日志', 0, '/api/v1/k8s/log/:namespace/:pod/:container', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (100, '2023-02-23 13:59:03', '2023-02-23 13:59:03', NULL, 94, '下载容器日志', 0, '/api/v1/k8s/log/file/:namespace/:pod/:container', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (101, '2023-02-23 13:59:22', '2023-02-23 13:59:22', NULL, 94, '获取容器所属资源类型', 0, '/api/v1/k8s/log/source/:namespace/:resourceName/:resourceType', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (102, NULL, NULL, NULL, 36, '存储管理', 6, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (103, NULL, NULL, NULL, 36, '网络管理', 7, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (104, NULL, NULL, NULL, 36, '配置管理', 8, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (105, '2023-02-23 14:00:33', '2023-02-23 14:00:33', NULL, 102, '获取存储卷列表', 0, '/api/v1/k8s/storage/pvs', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (106, '2023-02-23 14:00:43', '2023-02-23 14:00:43', NULL, 102, '查看存储卷详情', 0, '/api/v1/k8s/storage/pv', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (107, '2023-02-23 14:00:57', '2023-02-23 14:00:57', NULL, 102, '删除存储卷', 0, '/api/v1/k8s/storage/pv', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (108, '2023-02-23 14:01:16', '2023-02-23 14:01:16', NULL, 102, '获取存储声明列表', 0, '/api/v1/k8s/storage/pvcs', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (109, '2023-02-23 14:01:35', '2023-02-23 14:01:35', NULL, 102, '查看存储声明详情', 0, '/api/v1/k8s/storage/pvc', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (110, '2023-02-23 14:01:48', '2023-02-23 14:01:48', NULL, 102, '删除存储声明', 0, '/api/v1/k8s/storage/pvc', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (111, '2023-02-23 14:01:59', '2023-02-23 14:01:59', NULL, 102, '获取存储类列表', 0, '/api/v1/k8s/storage/scs', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (112, '2023-02-23 14:02:12', '2023-02-23 14:02:12', NULL, 102, '查看存储类详情', 0, '/api/v1/k8s/storage/sc', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (113, '2023-02-23 14:02:26', '2023-02-23 14:02:26', NULL, 102, '删除存储类', 0, '/api/v1/k8s/storage/sc', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (114, '2023-02-23 14:03:05', '2023-02-23 14:03:05', NULL, 103, '获取路由列表', 0, '/api/v1/k8s/network/ingresss', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (115, '2023-02-23 14:03:17', '2023-02-23 14:03:17', NULL, 103, '删除路由', 0, '/api/v1/k8s/network/ingress', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (116, '2023-02-23 14:03:28', '2023-02-23 14:03:28', NULL, 103, '查看路由详情', 0, '/api/v1/k8s/network/ingress', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (117, '2023-02-23 14:03:40', '2023-02-23 14:03:40', NULL, 103, '批量删除路由', 0, '/api/v1/k8s/network/ingresss', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (118, '2023-02-23 14:03:53', '2023-02-23 14:03:53', NULL, 103, '获取服务列表', 0, '/api/v1/k8s/network/services', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (119, '2023-02-23 14:04:05', '2023-02-23 14:04:05', NULL, 103, '查看服务详情', 0, '/api/v1/k8s/network/service', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (120, '2023-02-23 14:04:18', '2023-02-23 14:04:18', NULL, 103, '删除服务', 0, '/api/v1/k8s/network/service', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (121, '2023-02-23 14:04:30', '2023-02-23 14:04:30', NULL, 103, '批量删除服务', 0, '/api/v1/k8s/network/services', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (122, '2023-02-23 14:04:49', '2023-02-23 14:04:49', NULL, 104, '获取配置项列表', 0, '/api/v1/k8s/config/configmaps', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (123, '2023-02-23 14:05:01', '2023-02-23 14:05:01', NULL, 104, '查看配置项详情', 0, '/api/v1/k8s/config/configmap', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (124, '2023-02-23 14:05:13', '2023-02-23 14:05:13', NULL, 104, '删除配置项', 0, '/api/v1/k8s/config/configmap', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (125, '2023-02-23 14:05:25', '2023-02-23 14:05:25', NULL, 104, '批量删除配置项', 0, '/api/v1/k8s/config/configmaps', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (126, '2023-02-23 14:05:36', '2023-02-23 14:05:36', NULL, 104, '获取保密字典列表', 0, '/api/v1/k8s/config/secrets', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (127, '2023-02-23 14:05:52', '2023-02-23 14:05:52', NULL, 104, '查看保密字典详情', 0, '/api/v1/k8s/config/secret', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (128, '2023-02-23 14:06:07', '2023-02-23 14:06:07', NULL, 104, '删除保密字典', 0, '/api/v1/k8s/config/secret', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (129, '2023-02-23 14:06:19', '2023-02-23 14:06:19', NULL, 104, '批量删除保密字典', 0, '/api/v1/k8s/config/secrets', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (130, NULL, NULL, NULL, 4, '应用发布', 3, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (131, NULL, NULL, NULL, 130, '应用管理', 1, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (132, '2023-02-23 14:13:26', '2023-02-23 14:13:26', NULL, 131, '获取应用列表', 0, '/api/v1/apps', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (133, '2023-02-23 14:13:37', '2023-02-23 14:13:37', NULL, 131, '创建应用', 0, '/api/v1/apps', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (134, '2023-02-23 14:13:51', '2023-02-23 14:13:51', NULL, 131, '查看应用详情', 0, '/api/v1/apps/detail', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (135, '2023-02-23 14:14:05', '2023-02-23 14:14:05', NULL, 131, '获取应用版本Tag', 0, '/api/v1/cicd/deploy/tags', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (136, '2023-02-23 14:14:15', '2023-02-23 14:14:15', NULL, 131, '获取应用实例', 0, '/api/v1/apps/instance', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (137, '2023-02-23 14:14:28', '2023-02-23 14:14:28', NULL, 131, '列出单个应用环境列表', 0, '/api/v1/apps/envs', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (138, '2023-02-23 14:14:46', '2023-02-23 14:14:46', NULL, 131, '创建环境-应用搜索', 0, '/api/v1/apps/search', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (139, NULL, NULL, NULL, 130, '凭证管理', 2, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (140, '2023-02-23 14:16:10', '2023-02-23 14:16:10', NULL, 139, '获取凭证列表', 0, '/api/v1/cicd/secrets', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (141, '2023-02-23 14:16:30', '2023-02-23 14:16:30', NULL, 139, '更新凭证', 0, '/api/v1/cicd/secret', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (142, '2023-02-23 14:16:47', '2023-02-23 14:16:47', NULL, 139, '创建凭证', 0, '/api/v1/cicd/secret', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (143, '2023-02-23 14:16:56', '2023-02-23 14:16:56', NULL, 139, '删除凭证', 0, '/api/v1/cicd/secret', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (144, '2023-02-23 14:17:13', '2023-02-23 14:17:13', NULL, 139, '查看凭证详情', 0, '/api/v1/cicd/secret', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (145, NULL, NULL, NULL, 130, '构建中心', 3, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (146, '2023-02-23 14:18:40', '2023-02-23 14:18:40', NULL, 145, '获取流水线列表', 0, '/api/v1/cicd/pipelines', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (147, '2023-02-23 14:18:58', '2023-02-23 14:18:58', NULL, 145, '查看流水线构建历史', 0, '/api/v1/cicd/pipeline/runHistory/:id', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (148, '2023-02-23 14:19:09', '2023-02-23 14:19:09', NULL, 145, '创建流水线', 0, '/api/v1/cicd/pipeline', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (149, '2023-02-23 14:19:20', '2023-02-23 14:19:20', NULL, 145, '查看流水线详情', 0, '/api/v1/cicd/pipeline/:id', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (150, '2023-02-23 14:19:32', '2023-02-23 14:19:32', NULL, 145, '删除流水线', 0, '/api/v1/cicd/pipelines', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (151, '2023-02-23 14:19:48', '2023-02-23 14:19:48', NULL, 145, '运行-获取Tekton流水线详情', 0, '/api/v1/cicd/tekton/pipeline', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (152, '2023-02-23 14:19:59', '2023-02-23 14:19:59', NULL, 145, '运行流水线', 0, '/api/v1/cicd/pipeline/build', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (153, '2023-02-23 14:20:22', '2023-02-23 14:20:22', NULL, 145, '停止构建', 0, '/api/v1/cicd/pipeline/build/:name', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (154, '2023-02-23 14:20:34', '2023-02-23 14:20:34', NULL, 145, '删除构建历史', 0, '/api/v1/cicd/pipeline/build', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (155, '2023-02-23 14:20:46', '2023-02-23 14:20:46', NULL, 145, '查看构建详情', 0, '/api/v1/ws/build/detail', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (156, NULL, NULL, NULL, 130, '发布申请', 4, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (157, '2023-02-23 14:25:07', '2023-02-23 14:51:30', NULL, 156, '创建应用发布单', 0, '/api/v1/cicd/deploy', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (158, '2023-02-23 14:25:21', '2023-02-23 14:51:19', NULL, 156, '获取发布申请列表', 0, '/api/v1/cicd/deploy', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (159, '2023-02-23 14:25:34', '2023-02-23 14:51:07', NULL, 156, '查看发布单详情', 0, '/api/v1/ws/deploy/:id', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (160, '2023-02-23 14:25:51', '2023-02-23 14:50:57', NULL, 156, '流程审批', 0, '/api/v1/cicd/deploy/approval', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (161, NULL, NULL, NULL, 4, '系统管理', 4, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (162, NULL, NULL, NULL, 161, '用户管理', 1, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (163, NULL, NULL, NULL, 161, '角色管理', 2, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (164, NULL, NULL, NULL, 161, '菜单管理', 3, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (165, NULL, NULL, NULL, 161, '系统设置', 4, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (166, '2023-02-23 14:53:13', '2023-02-23 14:53:13', NULL, 162, '获取用户列表', 0, '/api/v1/user/list', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (167, '2023-02-23 14:53:32', '2023-02-23 14:53:32', '2023-02-23 14:57:43', 162, '批量删除用户', 0, '/api/v1/user/info', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (168, '2023-02-23 14:53:43', '2023-02-23 14:53:43', NULL, 162, '重置用户密码', 0, '/api/v1/user/resetPwd', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (169, '2023-02-23 14:54:00', '2023-02-23 14:54:00', NULL, 162, '修改个人密码', 0, '/api/v1/user/changePwd', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (170, '2023-02-23 14:54:17', '2023-02-23 14:54:17', NULL, 162, '获取个人信息', 0, '/api/v1/user/profile', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (171, '2023-02-23 14:54:32', '2023-02-23 14:54:32', NULL, 162, '修改个人信息', 0, '/api/v1/user/profile', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (172, '2023-02-23 14:54:47', '2023-02-23 14:54:47', NULL, 162, '修改用户状态(启用/禁用)', 0, '/api/v1/user', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (173, '2023-02-23 14:54:57', '2023-02-23 14:54:57', NULL, 162, '删除用户', 0, '/api/v1/user', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (174, '2023-02-23 14:55:15', '2023-02-23 14:55:15', NULL, 163, '获取角色列表', 0, '/api/v1/role', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (175, '2023-02-23 14:55:27', '2023-02-23 14:55:27', NULL, 163, '新增角色', 0, '/api/v1/role', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (176, '2023-02-23 14:55:37', '2023-02-23 14:55:37', NULL, 163, '修改角色', 0, '/api/v1/role', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (177, '2023-02-23 14:55:46', '2023-02-23 14:55:46', NULL, 163, '删除角色', 0, '/api/v1/role', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (178, '2023-02-23 14:58:41', '2023-02-23 14:58:41', NULL, 163, '为用户分配角色', 0, '/api/v1/role/bind', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (179, '2023-02-23 14:59:05', '2023-02-23 14:59:05', NULL, 163, '根据角色获取已授权的API接口', 0, '/api/v1/tree/permission/role', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (180, '2023-02-23 14:59:27', '2023-02-23 14:59:27', NULL, 163, '为角色分配API接口权限', 0, '/api/v1/tree/permission/role', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (181, '2023-02-23 14:59:41', '2023-02-23 14:59:41', NULL, 163, '根据角色获取已授权的菜单树', 0, '/api/v1/tree/menu/role', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (182, '2023-02-23 14:59:55', '2023-02-23 14:59:55', NULL, 163, '为角色分配菜单', 0, '/api/v1/tree/menu/role', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (183, NULL, NULL, NULL, 161, '接口管理', 5, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (184, '2023-02-23 15:03:11', '2023-02-23 15:03:11', NULL, 183, '获取API接口权限树', 0, '/api/v1/tree/permission', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (185, '2023-02-23 15:03:29', '2023-02-23 15:03:29', NULL, 183, '获取api分组列表', 0, '/api/v1/permission/api/group', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (186, '2023-02-23 15:03:44', '2023-02-23 15:03:44', NULL, 183, '新增api分组', 0, '/api/v1/permission/api/group', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (187, '2023-02-23 15:03:55', '2023-02-23 15:03:55', NULL, 183, '获取权限接口列表', 0, '/api/v1/permission/api', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (188, '2023-02-23 15:04:03', '2023-02-23 15:04:03', NULL, 183, '新增权限接口', 0, '/api/v1/permission/api', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (189, '2023-02-23 15:04:19', '2023-02-23 15:04:19', NULL, 183, '修改权限接口', 0, '/api/v1/permission/api', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (190, '2023-02-23 15:04:27', '2023-02-23 15:04:27', NULL, 183, '删除权限接口', 0, '/api/v1/permission/api', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (191, '2023-02-23 15:04:49', '2023-02-23 15:04:49', NULL, 164, '根据用户获取前端左侧菜单树', 0, '/api/v1/menu/role', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (192, '2023-02-23 15:05:04', '2023-02-23 15:05:04', NULL, 164, '获取菜单列表', 0, '/api/v1/menu', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (193, '2023-02-23 15:05:12', '2023-02-23 15:05:12', NULL, 164, '新增菜单', 0, '/api/v1/menu', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (194, '2023-02-23 15:05:25', '2023-02-23 15:05:25', NULL, 164, '修改菜单', 0, '/api/v1/menu', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (195, '2023-02-23 15:05:34', '2023-02-23 15:05:34', NULL, 164, '删除菜单', 0, '/api/v1/menu', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (196, '2023-02-23 15:05:49', '2023-02-23 15:05:49', NULL, 164, '获取菜单树', 0, '/api/v1/tree/menu', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (197, '2023-02-23 15:06:23', '2023-02-23 15:06:23', NULL, 165, '获取流水线设置', 0, '/api/v1/cicd/settings', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (198, '2023-02-23 15:08:01', '2023-02-23 15:08:01', NULL, 165, '创建/更新流水线设置', 0, '/api/v1/cicd/flow/settings', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (199, '2023-02-23 15:08:33', '2023-02-23 15:08:33', NULL, 165, '创建/更新OSS设置', 0, '/api/v1/cicd/oss/settings', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (200, NULL, NULL, NULL, 4, '运维工具', 5, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (201, NULL, NULL, NULL, 200, '隧道转发', 1, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (202, '2023-02-23 15:11:20', '2023-02-23 15:11:20', NULL, 201, '获取隧道列表', 0, '/api/v1/cmdb/tunnel', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (203, '2023-02-23 15:11:29', '2023-02-23 15:11:29', NULL, 201, '创建隧道', 0, '/api/v1/cmdb/tunnel', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (204, '2023-02-23 15:11:42', '2023-02-23 15:11:42', NULL, 201, '启动/停止隧道', 0, '/api/v1/cmdb/tunnel', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (205, '2023-02-23 15:11:52', '2023-02-23 15:11:52', NULL, 201, '删除隧道', 0, '/api/v1/cmdb/tunnel', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (206, NULL, NULL, NULL, 4, '操作审计', 6, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (207, '2023-02-23 15:12:28', '2023-02-23 15:12:28', NULL, 206, '获取SSH录像列表', 0, '/api/v1/audit/ssh/records', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (208, '2023-02-23 15:12:42', '2023-02-23 15:12:42', NULL, 206, '删除SSH录像审计', 0, '/api/v1/audit/ssh/records', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (209, '2023-02-23 15:12:58', '2023-02-23 15:12:58', NULL, 206, '播放SSH录像', 0, '/api/v1/audit/ssh/records/:id', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (210, '2023-02-23 15:14:03', '2023-02-23 15:14:03', NULL, 131, '批量删除应用', 0, '/api/v1/apps', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (211, '2023-02-23 15:14:20', '2023-02-23 15:14:20', NULL, 156, '批量删除发布申请', 0, '/api/v1/cicd/deploy', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (212, '2023-02-23 15:15:10', '2023-02-23 15:15:10', NULL, 206, '获取容器录像列表', 0, '/api/v1/audit/pod/ssh/records', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (213, '2023-02-23 15:15:20', '2023-02-23 15:15:20', NULL, 206, '删除容器录像审计', 0, '/api/v1/audit/pod/ssh/records', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (214, '2023-02-23 15:15:31', '2023-02-23 15:15:31', NULL, 206, '播放容器录像', 0, '/api/v1/audit/pod/ssh/records/:id', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (215, '2023-02-23 15:15:45', '2023-02-23 15:15:45', NULL, 206, '获取行为记录列表', 0, '/api/v1/audit/api', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (216, '2023-02-23 15:15:53', '2023-02-23 15:15:53', NULL, 206, '批量删除行为记录', 0, '/api/v1/audit/api', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (217, '2023-04-07 16:22:46', '2023-04-07 16:23:19', NULL, 104, '修改配置项', 0, '/api/v1/k8s/config/configmap', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (218, '2023-04-07 16:23:10', '2023-04-07 16:23:10', NULL, 104, '修改保密字典', 0, '/api/v1/k8s/config/secret', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (219, '2023-04-07 16:23:54', '2023-04-07 16:23:54', NULL, 131, '获取环境详情', 0, '/api/v1/apps/env', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (220, '2023-04-07 16:24:19', '2023-04-07 16:24:19', NULL, 131, '修改环境', 0, '/api/v1/apps/env', 'PUT');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (221, '2023-04-07 16:24:34', '2023-04-07 16:24:34', NULL, 131, '批量删除环境', 0, '/api/v1/apps/envs', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (222, '2023-05-13 12:55:31', '2023-05-13 12:55:31', NULL, 2, '获取远程登录实例IP', 0, '/api/v1/cmdb/host/server/resource', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (223, NULL, NULL, NULL, 36, '监控', 9, NULL, NULL);
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (224, '2023-05-13 15:24:40', '2023-05-13 15:24:40', NULL, 223, '获取Pod监控图表', 0, '/api/v1/monitoring/describeMetric', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (225, '2023-05-13 16:11:02', '2023-05-13 16:12:37', NULL, 131, '获取应用伸缩指标', 0, '/api/v1/apps/metric', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (226, '2023-05-13 16:11:39', '2023-05-13 16:11:39', NULL, 131, '获取应用伸缩实例', 0, '/api/v1/apps/autoscaling', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (227, '2023-05-13 16:18:52', '2023-05-13 16:18:52', NULL, 145, '获取代码分支', 0, '/api/v1/cicd/git/branches', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (228, '2023-05-15 22:49:25', '2023-05-15 22:49:25', NULL, 2, '远程终端', 0, '/api/v1/ws/webssh', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (229, '2023-05-16 09:15:25', '2023-05-16 09:36:20', NULL, 156, '获取滚动更新详情', 0, '/api/v1/cicd/deploy/rollingUpdate', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (230, '2023-05-16 09:22:42', '2023-05-16 09:36:36', NULL, 156, '修改应用发布暂停', 0, '/api/v1/cicd/deploy/pause', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (231, '2023-05-17 11:08:11', '2023-05-17 11:37:05', NULL, 2, '文件管理-浏览', 0, '/api/v1/cmdb/host/file', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (232, '2023-05-17 11:37:21', '2023-05-17 11:37:21', NULL, 2, '文件管理-上传', 0, '/api/v1/cmdb/host/file', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (233, '2023-05-19 15:26:30', '2023-05-19 15:26:30', NULL, 2, '文件管理-下载', 0, '/api/v1/cmdb/host/file/download', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (234, NULL, NULL, NULL, 212, '查看windows录像回话', 0, '/api/v1/audit/rdp/records/:sessionId', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (235, NULL, NULL, NULL, 8, '创建资产分组', 0, '/api/v1/cmdb/host/group', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (236, NULL, NULL, NULL, 162, '系统安全设置', 0, '/api/v1/system/safe/settings', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (237, NULL, NULL, NULL, 162, '获取系统安全设置', 0, '/api/v1/system/safe/settings', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (239, NULL, NULL, NULL, 162, '系统安全设置', 0, '/api/v1/system/safe/settings', 'POST');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (240, NULL, NULL, NULL, 162, '获取系统安全设置', 0, '/api/v1/system/safe/settings', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (241, NULL, NULL, NULL, 212, '获取文件管理操作记录', 0, '/api/v1/audit/filemanage', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (242, NULL, NULL, NULL, 212, '批量删除文件管理操作记录', 0, '/api/v1/audit/filemanage', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (243, NULL, NULL, NULL, 212, '获取用户登录记录', 0, '/api/v1/audit/login', 'GET');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (244, NULL, NULL, NULL, 212, '批量删除用户登录记录', 0, '/api/v1/audit/login', 'DELETE');
INSERT INTO `permissions` (`id`, `created_at`, `updated_at`, `deleted_at`, `pid`, `name`, `sort`, `path`, `method`) VALUES (245, '2023-10-26 16:20:15', '2023-10-26 16:20:15', NULL, 156, '查看审批详情', 0, '/api/v1/cicd/dingtalk/workflow', 'GET');
COMMIT;


DROP TABLE IF EXISTS `pipeline_notice`;
CREATE TABLE `pipeline_notice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `pipeline_id` bigint(20) DEFAULT NULL COMMENT '流水线ID',
  `enable` tinyint(1) DEFAULT NULL COMMENT '是否启用',
  `notice_type` varchar(191) DEFAULT NULL COMMENT '通知类型(feishu, dingtalk)',
  `notice_event` varchar(191) DEFAULT NULL COMMENT '事件类型',
  `webhook` varchar(256) DEFAULT NULL COMMENT 'webhook通知地址',
  PRIMARY KEY (`id`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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


BEGIN;
INSERT INTO `pipeline_resources` (`id`, `created_at`, `updated_at`, `deleted_at`, `image`, `desc`) VALUES (1, '2022-11-07 14:35:18', '2022-11-07 14:35:21', NULL, 'alpine:latest', NULL);
INSERT INTO `pipeline_resources` (`id`, `created_at`, `updated_at`, `deleted_at`, `image`, `desc`) VALUES (2, '2022-11-07 14:35:18', '2022-11-07 14:35:21', NULL, 'python:3.7', NULL);
COMMIT;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
  `cache_enable` tinyint(1) DEFAULT '0' COMMENT '启用缓存',
  `cache_path` varchar(128) DEFAULT NULL COMMENT '缓存目录',
  `cache_type` varchar(128) DEFAULT NULL COMMENT '缓存类型: workspace默认路径, custom自定义路径',
  PRIMARY KEY (`id`),
  KEY `idx_pipelines_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `relation_env_hosts`;
CREATE TABLE `relation_env_hosts` (
  `biz_env_id` bigint(20) NOT NULL COMMENT '自增编号',
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`biz_env_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `relation_group_host`;
CREATE TABLE `relation_group_host` (
  `tree_menu_id` bigint(20) NOT NULL,
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`tree_menu_id`,`virtual_machine_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;


DROP TABLE IF EXISTS `relation_host_jump_gateway`;
CREATE TABLE `relation_host_jump_gateway` (
  `jump_gateway_id` bigint(20) NOT NULL COMMENT '自增编号',
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`jump_gateway_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `relation_role_menu`;
CREATE TABLE `relation_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '自增编号',
  `menu_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


BEGIN;
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 1);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 3);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 8);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 9);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 10);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 11);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 15);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 20);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 22);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (1, 23);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 1);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 2);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 3);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 4);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 5);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 6);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 7);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 8);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 9);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 10);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 11);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 12);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 13);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 14);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 15);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 16);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 17);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 18);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 19);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 20);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 21);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 22);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 23);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 24);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 25);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 26);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 29);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 30);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 33);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 34);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 35);
INSERT INTO `relation_role_menu` (`role_id`, `menu_id`) VALUES (3, 36);
COMMIT;


DROP TABLE IF EXISTS `relation_virtual_machines_tags`;
CREATE TABLE `relation_virtual_machines_tags` (
  `virtual_machine_id` bigint(20) NOT NULL COMMENT '自增编号',
  `tags_id` bigint(20) NOT NULL COMMENT '自增编号',
  PRIMARY KEY (`virtual_machine_id`,`tags_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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


BEGIN;
INSERT INTO `role` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `desc`, `code`, `permission_id`) VALUES (1, '2021-09-18 12:32:05', '2023-10-27 17:56:24', NULL, '游客', '', 'guest', 1);
INSERT INTO `role` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `desc`, `code`, `permission_id`) VALUES (2, '2022-01-12 13:44:41', '2022-01-17 18:18:52', NULL, '管理员', '暂无', 'admin', 2);
INSERT INTO `role` (`id`, `created_at`, `updated_at`, `deleted_at`, `name`, `desc`, `code`, `permission_id`) VALUES (3, '2022-01-12 14:35:37', '2022-02-12 12:44:38', NULL, '超级管理员', '超级管理员拥有所有权限', 'super', 0);
COMMIT;


DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `role_id` bigint(20) DEFAULT NULL COMMENT '''角色id''',
  `permission_id` bigint(20) DEFAULT NULL COMMENT '''权限id''',
  PRIMARY KEY (`id`),
  KEY `idx_role_permission_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1825 DEFAULT CHARSET=utf8mb4;


BEGIN;
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (2, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (3, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (4, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (5, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (6, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (7, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (8, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (9, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (10, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (11, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (12, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (13, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (14, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (15, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (16, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (17, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (18, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (19, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (20, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (21, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (22, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (23, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (24, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (25, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (26, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (27, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (28, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (29, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (30, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (31, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (32, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (33, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (34, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (35, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (36, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (37, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (38, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (39, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (40, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (41, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (42, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (43, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (44, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (45, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (46, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (47, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (48, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (49, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (50, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (51, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (52, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (53, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (54, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (55, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (56, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (57, '2023-05-13 13:02:39', '2023-05-13 13:02:39', '2023-05-13 15:12:18', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (58, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (59, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (60, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (61, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (62, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (63, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (64, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (65, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (66, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (67, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (68, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (69, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (70, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (71, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (72, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (73, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (74, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (75, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (76, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (77, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (78, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (79, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (80, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (81, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (82, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (83, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (84, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (85, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (86, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (87, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (88, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (89, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (90, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (91, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (92, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (93, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (94, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (95, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (96, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (97, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (98, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (99, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (100, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (101, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (102, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (103, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (104, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (105, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (106, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (107, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (108, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (109, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (110, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (111, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (112, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (113, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (114, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (115, '2023-05-13 15:12:18', '2023-05-13 15:12:18', '2023-05-13 15:25:03', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (116, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (117, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (118, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (119, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (120, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (121, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (122, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (123, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (124, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (125, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (126, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (127, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (128, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (129, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (130, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (131, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (132, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (133, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (134, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (135, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (136, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (137, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (138, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (139, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (140, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (141, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (142, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (143, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (144, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (145, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (146, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (147, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (148, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (149, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (150, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (151, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (152, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (153, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (154, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (155, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (156, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (157, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (158, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (159, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (160, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (161, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (162, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (163, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (164, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (165, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (166, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (167, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (168, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (169, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (170, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (171, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (172, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (173, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (174, '2023-05-13 15:25:03', '2023-05-13 15:25:03', '2023-05-13 16:12:07', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (175, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (176, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (177, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (178, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (179, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (180, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (181, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (182, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (183, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (184, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (185, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (186, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (187, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (188, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (189, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (190, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (191, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (192, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (193, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (194, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (195, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (196, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (197, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (198, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (199, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (200, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (201, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (202, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (203, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (204, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (205, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (206, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (207, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (208, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (209, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (210, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (211, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (212, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (213, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (214, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (215, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (216, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (217, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (218, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (219, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (220, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (221, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (222, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (223, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (224, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (225, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (226, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (227, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (228, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (229, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (230, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (231, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (232, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (233, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (234, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (235, '2023-05-13 16:12:07', '2023-05-13 16:12:07', '2023-05-13 16:15:57', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (236, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (237, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (238, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (239, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (240, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (241, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (242, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (243, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (244, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (245, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (246, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (247, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (248, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (249, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (250, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (251, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (252, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (253, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (254, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (255, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (256, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (257, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (258, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (259, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (260, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (261, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (262, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (263, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (264, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (265, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (266, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (267, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (268, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (269, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (270, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (271, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (272, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (273, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (274, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (275, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (276, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (277, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (278, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (279, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (280, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (281, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (282, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (283, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (284, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (285, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (286, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (287, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (288, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (289, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (290, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (291, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (292, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (293, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (294, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (295, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (296, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (297, '2023-05-13 16:15:57', '2023-05-13 16:15:57', '2023-05-13 16:19:28', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (298, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (299, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (300, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (301, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (302, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (303, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (304, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (305, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (306, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (307, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (308, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (309, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (310, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (311, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (312, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (313, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (314, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (315, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (316, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (317, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (318, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (319, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (320, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (321, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (322, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (323, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (324, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (325, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (326, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (327, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (328, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (329, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (330, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (331, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (332, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (333, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (334, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (335, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (336, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (337, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (338, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (339, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (340, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (341, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (342, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (343, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (344, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (345, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (346, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (347, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (348, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (349, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (350, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (351, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (352, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (353, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (354, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (355, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (356, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (357, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (358, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (359, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (360, '2023-05-13 16:19:28', '2023-05-13 16:19:28', '2023-05-15 22:49:45', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (361, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (362, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (363, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (364, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (365, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (366, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (367, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (368, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (369, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (370, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (371, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (372, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (373, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (374, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (375, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (376, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (377, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (378, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (379, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (380, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (381, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (382, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (383, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (384, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (385, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (386, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (387, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (388, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (389, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (390, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (391, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (392, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (393, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (394, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (395, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (396, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (397, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (398, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (399, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (400, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (401, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (402, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (403, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (404, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (405, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (406, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (407, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (408, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (409, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (410, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (411, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (412, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (413, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (414, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (415, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (416, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (417, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (418, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (419, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (420, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (421, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (422, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (423, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (424, '2023-05-15 22:49:45', '2023-05-15 22:49:45', '2023-05-15 23:51:50', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (425, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (426, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (427, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (428, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (429, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (430, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (431, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (432, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (433, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (434, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (435, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (436, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (437, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (438, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (439, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (440, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (441, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (442, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (443, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (444, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (445, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (446, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (447, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (448, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (449, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (450, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (451, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (452, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (453, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (454, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (455, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (456, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (457, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (458, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (459, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (460, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (461, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (462, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (463, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (464, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (465, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (466, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (467, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (468, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (469, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (470, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (471, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (472, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (473, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (474, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (475, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (476, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (477, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (478, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (479, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (480, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (481, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (482, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (483, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (484, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (485, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (486, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (487, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (488, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (489, '2023-05-15 23:51:50', '2023-05-15 23:51:50', '2023-05-16 09:25:48', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (490, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (491, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (492, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (493, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (494, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (495, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (496, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (497, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (498, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (499, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (500, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (501, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (502, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (503, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (504, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (505, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (506, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (507, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (508, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (509, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (510, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (511, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (512, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (513, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (514, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (515, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (516, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (517, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (518, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (519, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (520, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (521, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (522, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (523, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (524, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (525, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (526, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (527, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (528, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (529, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (530, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (531, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (532, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (533, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (534, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (535, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (536, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (537, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (538, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (539, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (540, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (541, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (542, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (543, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (544, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (545, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (546, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (547, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (548, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (549, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (550, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (551, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (552, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (553, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (554, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (555, '2023-05-16 09:25:48', '2023-05-16 09:25:48', '2023-05-17 11:10:15', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (556, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (557, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (558, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (559, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (560, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (561, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (562, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (563, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (564, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (565, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (566, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (567, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (568, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (569, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (570, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (571, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (572, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (573, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (574, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (575, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (576, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (577, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (578, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (579, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (580, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (581, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (582, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (583, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (584, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (585, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (586, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (587, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (588, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (589, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (590, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (591, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (592, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (593, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (594, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (595, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (596, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (597, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (598, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (599, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (600, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (601, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (602, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (603, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (604, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (605, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (606, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (607, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (608, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (609, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (610, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (611, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (612, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (613, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (614, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (615, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (616, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (617, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (618, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (619, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (620, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (621, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (622, '2023-05-17 11:10:15', '2023-05-17 11:10:15', '2023-05-17 11:10:16', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (623, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (624, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (625, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (626, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (627, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (628, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (629, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (630, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (631, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (632, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (633, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (634, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (635, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (636, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (637, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (638, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (639, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (640, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (641, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (642, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (643, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (644, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (645, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (646, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (647, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (648, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (649, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (650, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (651, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (652, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (653, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (654, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (655, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (656, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (657, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (658, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (659, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (660, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (661, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (662, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (663, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (664, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (665, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (666, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (667, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (668, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (669, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (670, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (671, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (672, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (673, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (674, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (675, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (676, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (677, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (678, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (679, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (680, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (681, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (682, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (683, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (684, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (685, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (686, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (687, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (688, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (689, '2023-05-17 11:10:16', '2023-05-17 11:10:16', '2023-05-17 11:37:29', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (690, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (691, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (692, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (693, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (694, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (695, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (696, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (697, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (698, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (699, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (700, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (701, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (702, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (703, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (704, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (705, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (706, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (707, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (708, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (709, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (710, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (711, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (712, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (713, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (714, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (715, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (716, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (717, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (718, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (719, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (720, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (721, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (722, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (723, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (724, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (725, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (726, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (727, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (728, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (729, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (730, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (731, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (732, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (733, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (734, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (735, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (736, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (737, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (738, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (739, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (740, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (741, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (742, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (743, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (744, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (745, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (746, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (747, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (748, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (749, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (750, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (751, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (752, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (753, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (754, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (755, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (756, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (757, '2023-05-17 11:37:29', '2023-05-17 11:37:29', '2023-05-19 15:26:49', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (758, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (759, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (760, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (761, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (762, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (763, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (764, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (765, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (766, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (767, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (768, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (769, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (770, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (771, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (772, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (773, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (774, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (775, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (776, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (777, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (778, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (779, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (780, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (781, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (782, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (783, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (784, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (785, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (786, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (787, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (788, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (789, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (790, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (791, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (792, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (793, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (794, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (795, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (796, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (797, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (798, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (799, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (800, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (801, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (802, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (803, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (804, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (805, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (806, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (807, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (808, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (809, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (810, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (811, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (812, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (813, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (814, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (815, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (816, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (817, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (818, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (819, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (820, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (821, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (822, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (823, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (824, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (825, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (826, '2023-05-19 15:26:49', '2023-05-19 15:26:49', '2023-07-03 09:43:09', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (827, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (828, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (829, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (830, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (831, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (832, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (833, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (834, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (835, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (836, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (837, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (838, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (839, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (840, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (841, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (842, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (843, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (844, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (845, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (846, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (847, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (848, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (849, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (850, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (851, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (852, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (853, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (854, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (855, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (856, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (857, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (858, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (859, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (860, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (861, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (862, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 122);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (863, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 123);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (864, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (865, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (866, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (867, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (868, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (869, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (870, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (871, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (872, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (873, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (874, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (875, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (876, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (877, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (878, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (879, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (880, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (881, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (882, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (883, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (884, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (885, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (886, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (887, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 217);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (888, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (889, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (890, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (891, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (892, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (893, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (894, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (895, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (896, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (897, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (898, '2023-07-03 09:43:09', '2023-07-03 09:43:09', '2023-07-07 14:54:54', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (899, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (900, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (901, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (902, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (903, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (904, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (905, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (906, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (907, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (908, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (909, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (910, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (911, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (912, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (913, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (914, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (915, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (916, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (917, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (918, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (919, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (920, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (921, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (922, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (923, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (924, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (925, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (926, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (927, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (928, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (929, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (930, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (931, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (932, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (933, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (934, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (935, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (936, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (937, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (938, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (939, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (940, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (941, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (942, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (943, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (944, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (945, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (946, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (947, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (948, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (949, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (950, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (951, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (952, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (953, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (954, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (955, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (956, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (957, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (958, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (959, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (960, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (961, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (962, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (963, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (964, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (965, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (966, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (967, '2023-07-07 14:54:54', '2023-07-07 14:54:54', '2023-07-07 14:57:48', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (968, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (969, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (970, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (971, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (972, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (973, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (974, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (975, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (976, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (977, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (978, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (979, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (980, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (981, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (982, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (983, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (984, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (985, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (986, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (987, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (988, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (989, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (990, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (991, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (992, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (993, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (994, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (995, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (996, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (997, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (998, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (999, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1000, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1001, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1002, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1003, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1004, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1005, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1006, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1007, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1008, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1009, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1010, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1011, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1012, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1013, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1014, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1015, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1016, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1017, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1018, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1019, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1020, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1021, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1022, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1023, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1024, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1025, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1026, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1027, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1028, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1029, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1030, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1031, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1032, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1033, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1034, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1035, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1036, '2023-07-07 14:57:48', '2023-07-07 14:57:48', '2023-07-19 15:37:47', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1037, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1038, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1039, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1040, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1041, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1042, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1043, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1044, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1045, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1046, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1047, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1048, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1049, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1050, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1051, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1052, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1053, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1054, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1055, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1056, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1057, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1058, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1059, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1060, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1061, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1062, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1063, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1064, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1065, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1066, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1067, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1068, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1069, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1070, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1071, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1072, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 122);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1073, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 123);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1074, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 126);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1075, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 127);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1076, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1077, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1078, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1079, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1080, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1081, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1082, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1083, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1084, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1085, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1086, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1087, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1088, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1089, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1090, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1091, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1092, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1093, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1094, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1095, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1096, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1097, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1098, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1099, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 217);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1100, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 218);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1101, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1102, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1103, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1104, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1105, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1106, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1107, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1108, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1109, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1110, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1111, '2023-07-19 15:37:47', '2023-07-19 15:37:47', '2023-07-26 16:49:44', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1112, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1113, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1114, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1115, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1116, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1117, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1118, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1119, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1120, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1121, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1122, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1123, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1124, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1125, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1126, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1127, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1128, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1129, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1130, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1131, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1132, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1133, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1134, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1135, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1136, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1137, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1138, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1139, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1140, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1141, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1142, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1143, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1144, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1145, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1146, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1147, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1148, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1149, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1150, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1151, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1152, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1153, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1154, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1155, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1156, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1157, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1158, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1159, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1160, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1161, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1162, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1163, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1164, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1165, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1166, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1167, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1168, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1169, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1170, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1171, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1172, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1173, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1174, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1175, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1176, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1177, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1178, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1179, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1180, '2023-07-26 16:49:44', '2023-07-26 16:49:44', '2023-08-01 17:41:19', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1181, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1182, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1183, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1184, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1185, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1186, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1187, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1188, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1189, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1190, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1191, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1192, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1193, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1194, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1195, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1196, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1197, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1198, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1199, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1200, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1201, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1202, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1203, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1204, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1205, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1206, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1207, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1208, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1209, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1210, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1211, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1212, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1213, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1214, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1215, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1216, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 122);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1217, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 123);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1218, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 126);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1219, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 127);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1220, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1221, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1222, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1223, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1224, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1225, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1226, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1227, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1228, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1229, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1230, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1231, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1232, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1233, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1234, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1235, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1236, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1237, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1238, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1239, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1240, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1241, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1242, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1243, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 217);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1244, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 218);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1245, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1246, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1247, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1248, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1249, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1250, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1251, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1252, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1253, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1254, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1255, '2023-08-01 17:41:19', '2023-08-01 17:41:19', '2023-08-02 23:28:25', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1256, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1257, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1258, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1259, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1260, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1261, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1262, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1263, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1264, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1265, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1266, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1267, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1268, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1269, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1270, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1271, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1272, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1273, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1274, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1275, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1276, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1277, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1278, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1279, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1280, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1281, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1282, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1283, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1284, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1285, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1286, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1287, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1288, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1289, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1290, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1291, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1292, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1293, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1294, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1295, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1296, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1297, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1298, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1299, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1300, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1301, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1302, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1303, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1304, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1305, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1306, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1307, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1308, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1309, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1310, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1311, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1312, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1313, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1314, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1315, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1316, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1317, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1318, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1319, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1320, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1321, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1322, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1323, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1324, '2023-08-02 23:28:25', '2023-08-02 23:28:25', '2023-08-10 10:56:25', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1325, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1326, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1327, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1328, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1329, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1330, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1331, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1332, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1333, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1334, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1335, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1336, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1337, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1338, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1339, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1340, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1341, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1342, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1343, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1344, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1345, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1346, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1347, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1348, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1349, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1350, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1351, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1352, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1353, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1354, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1355, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1356, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1357, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1358, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1359, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1360, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 122);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1361, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 123);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1362, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1363, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1364, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1365, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1366, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1367, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1368, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1369, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1370, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1371, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1372, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1373, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1374, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1375, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1376, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1377, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1378, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1379, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1380, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1381, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1382, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1383, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1384, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1385, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 217);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1386, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1387, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1388, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1389, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1390, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1391, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1392, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1393, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1394, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1395, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1396, '2023-08-10 10:56:25', '2023-08-10 10:56:25', '2023-09-06 10:02:19', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1397, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1398, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1399, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1400, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1401, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1402, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1403, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1404, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1405, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1406, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1407, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1408, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1409, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1410, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1411, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1412, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1413, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1414, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1415, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1416, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1417, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1418, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1419, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1420, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1421, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1422, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1423, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1424, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1425, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1426, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1427, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1428, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1429, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1430, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1431, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1432, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1433, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1434, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1435, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1436, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1437, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1438, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1439, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1440, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1441, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1442, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1443, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1444, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1445, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1446, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1447, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1448, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1449, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1450, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1451, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1452, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1453, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1454, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1455, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1456, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1457, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1458, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1459, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1460, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1461, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1462, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1463, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1464, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1465, '2023-09-06 10:02:19', '2023-09-06 10:02:19', '2023-09-22 14:14:15', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1466, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1467, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1468, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1469, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1470, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1471, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1472, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1473, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1474, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1475, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1476, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1477, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1478, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1479, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1480, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1481, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1482, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1483, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1484, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1485, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1486, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1487, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1488, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1489, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1490, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1491, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1492, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1493, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1494, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1495, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1496, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1497, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1498, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1499, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1500, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1501, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 122);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1502, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 123);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1503, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 126);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1504, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 127);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1505, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1506, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1507, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1508, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1509, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1510, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1511, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1512, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1513, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1514, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1515, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1516, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1517, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1518, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1519, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1520, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1521, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1522, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1523, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1524, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1525, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1526, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1527, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1528, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 217);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1529, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 218);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1530, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1531, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1532, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1533, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1534, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1535, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1536, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1537, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1538, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1539, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1540, '2023-09-22 14:14:15', '2023-09-22 14:14:15', '2023-10-09 17:58:12', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1541, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1542, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1543, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1544, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1545, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1546, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1547, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1548, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1549, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1550, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1551, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1552, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1553, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1554, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1555, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1556, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1557, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1558, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1559, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1560, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1561, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1562, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1563, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1564, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1565, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1566, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1567, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1568, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1569, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1570, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1571, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1572, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1573, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1574, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1575, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1576, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1577, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1578, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1579, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1580, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1581, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1582, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1583, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1584, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1585, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1586, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1587, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1588, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1589, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1590, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1591, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1592, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1593, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1594, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1595, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1596, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1597, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1598, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1599, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1600, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1601, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1602, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1603, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1604, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1605, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1606, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1607, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1608, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1609, '2023-10-09 17:58:12', '2023-10-09 17:58:12', '2023-10-25 17:53:04', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1610, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1611, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1612, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1613, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1614, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1615, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1616, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1617, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1618, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1619, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1620, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1621, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1622, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1623, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1624, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1625, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1626, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1627, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1628, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1629, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1630, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1631, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1632, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1633, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1634, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1635, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1636, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1637, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1638, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1639, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1640, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1641, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1642, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1643, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1644, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1645, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 122);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1646, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 123);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1647, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1648, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1649, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1650, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1651, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1652, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1653, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1654, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1655, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1656, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1657, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1658, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1659, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1660, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1661, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1662, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1663, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1664, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1665, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1666, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1667, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1668, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1669, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1670, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 217);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1671, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1672, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1673, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1674, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1675, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1676, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1677, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1678, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1679, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1680, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1681, '2023-10-25 17:53:04', '2023-10-25 17:53:04', '2023-10-26 16:23:18', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1682, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1683, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1684, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1685, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1686, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1687, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1688, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1689, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1690, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1691, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1692, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1693, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1694, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1695, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1696, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1697, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1698, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1699, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1700, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1701, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1702, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1703, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1704, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1705, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1706, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1707, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1708, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1709, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1710, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1711, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1712, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1713, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1714, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1715, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1716, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1717, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 122);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1718, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 123);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1719, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1720, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1721, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1722, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1723, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1724, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1725, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1726, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1727, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1728, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1729, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1730, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1731, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1732, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1733, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1734, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1735, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1736, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1737, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1738, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1739, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1740, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1741, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1742, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 217);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1743, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1744, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1745, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1746, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1747, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1748, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1749, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1750, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1751, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1752, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1753, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1754, '2023-10-26 16:23:18', '2023-10-26 16:23:18', '2023-10-27 17:56:24', 1, 245);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1755, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 3);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1756, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 5);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1757, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 10);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1758, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 13);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1759, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 14);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1760, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 17);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1761, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 38);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1762, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 41);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1763, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 43);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1764, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 46);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1765, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 47);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1766, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 49);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1767, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 54);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1768, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 60);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1769, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 62);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1770, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 64);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1771, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 68);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1772, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 70);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1773, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 72);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1774, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 76);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1775, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 77);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1776, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 81);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1777, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 82);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1778, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 86);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1779, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 87);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1780, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 90);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1781, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 91);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1782, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 98);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1783, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 99);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1784, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 100);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1785, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 101);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1786, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 114);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1787, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 116);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1788, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 118);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1789, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 119);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1790, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 132);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1791, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 134);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1792, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 135);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1793, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 136);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1794, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 137);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1795, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 146);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1796, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 147);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1797, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 149);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1798, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 151);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1799, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 152);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1800, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 153);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1801, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 155);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1802, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 157);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1803, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 158);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1804, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 159);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1805, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 166);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1806, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 170);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1807, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 171);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1808, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 181);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1809, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 191);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1810, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 192);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1811, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 196);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1812, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 197);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1813, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 219);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1814, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 222);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1815, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 224);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1816, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 225);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1817, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 226);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1818, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 227);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1819, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 228);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1820, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 229);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1821, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 231);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1822, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 232);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1823, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 233);
INSERT INTO `role_permission` (`id`, `created_at`, `updated_at`, `deleted_at`, `role_id`, `permission_id`) VALUES (1824, '2023-10-27 17:56:24', '2023-10-27 17:56:24', NULL, 1, 245);
COMMIT;


DROP TABLE IF EXISTS `ssh_global_config`;
CREATE TABLE `ssh_global_config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '''自增编号''',
  `username` varchar(191) DEFAULT NULL COMMENT '''用户''',
  `password` varchar(300) DEFAULT NULL COMMENT '''密码''',
  `private_key` text COMMENT '''密钥''',
  `enable` tinyint(1) DEFAULT NULL COMMENT '''是否启用''',
  `login_type` varchar(191) DEFAULT NULL COMMENT '''登陆类型''',
  `protocol` varchar(191) DEFAULT NULL COMMENT '''协议''',
  `desc` varchar(191) DEFAULT NULL COMMENT '''备注''',
  `port` varchar(191) DEFAULT '22' COMMENT '''端口''',
  `created_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `ssh_record`;
CREATE TABLE `ssh_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `connect_id` varchar(64) DEFAULT NULL COMMENT '''连接标识''',
  `username` varchar(128) DEFAULT NULL COMMENT '''用户''',
  `hostname` varchar(128) DEFAULT NULL COMMENT '''主机名''',
  `connect_time` datetime DEFAULT NULL COMMENT '''接入时间''',
  `logout_time` datetime DEFAULT NULL COMMENT '''注销时间''',
  `records` longblob COMMENT '''操作记录(二进制存储)''',
  `host_id` bigint(20) DEFAULT NULL COMMENT '''主机Id外键''',
  `client_ip` varchar(191) DEFAULT NULL COMMENT '客户端地址',
  `user_agent` varchar(191) DEFAULT NULL COMMENT '浏览器标识',
  `ip_location` varchar(128) DEFAULT NULL COMMENT 'ip所在地',
  `protocol` varchar(10) DEFAULT NULL COMMENT '连接协议(rdp、ssh)',
  PRIMARY KEY (`id`),
  KEY `idx_ssh_record_deleted_at` (`deleted_at`),
  KEY `idx_ssh_record_connect_time` (`connect_time`),
  KEY `idx_ssh_record_logout_time` (`logout_time`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;



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
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of system_settings
-- ----------------------------
BEGIN;
INSERT INTO `system_settings` (`id`, `created_at`, `updated_at`, `deleted_at`, `mfa`, `login_fail`, `lock_time`, `password_expire`) VALUES (1, '2023-06-06 17:54:09', '2023-10-26 22:49:47', NULL, 0, 5, 60, -1);
COMMIT;


DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users` (
  `assets_hosts_permissions_id` bigint(20) NOT NULL COMMENT '自增编号',
  `ssh_global_config_id` bigint(20) unsigned NOT NULL COMMENT '''自增编号''',
  PRIMARY KEY (`assets_hosts_permissions_id`,`ssh_global_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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


DROP TABLE IF EXISTS `task_result`;
CREATE TABLE `task_result` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `task_id` varchar(191) DEFAULT NULL COMMENT '任务ID',
  `status` bigint(20) DEFAULT NULL COMMENT '状态',
  `result` varchar(191) DEFAULT NULL COMMENT '结果',
  `err_result` varchar(191) DEFAULT NULL COMMENT '错误结果',
  `max_retry` bigint(20) DEFAULT NULL COMMENT '重试次数',
  PRIMARY KEY (`id`),
  KEY `idx_task_result_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `uid` varchar(191) DEFAULT NULL COMMENT '''用戶uid''',
  `username` varchar(128) DEFAULT NULL COMMENT '''用户名''',
  `password` varchar(128) DEFAULT NULL COMMENT '''用户密码''',
  `phone` varchar(11) DEFAULT NULL COMMENT '''手机号码''',
  `email` varchar(128) DEFAULT NULL COMMENT '''邮箱''',
  `nickname` varchar(128) DEFAULT NULL,
  `avatar` varchar(128) DEFAULT 'https://www.dnsjia.com/luban/img/head.png' COMMENT '''用户头像''',
  `status` tinyint(1) DEFAULT '1' COMMENT '''用户状态(正常/禁用, 默认正常)''',
  `role_id` bigint(20) DEFAULT NULL COMMENT '''角色id外键''',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '''部门id外键''',
  `title` varchar(191) DEFAULT NULL COMMENT '''职位''',
  `create_by` varchar(191) DEFAULT NULL COMMENT '创建来源,ldap/local',
  `mfa_secret` text COMMENT 'mfa密钥',
  `password_updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_users_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `deleted_at`, `uid`, `username`, `password`, `phone`, `email`, `nickname`, `avatar`, `status`, `role_id`, `dept_id`, `title`, `create_by`, `mfa_secret`, `password_updated`) VALUES (1, '2021-09-18 12:30:28', '2023-06-13 16:30:20', NULL, '0', 'luban', '$2a$10$i.wJLtgaGreqPvRPPTOqIuRU6DoKb4WPN1uRPqD0y5xSdYWxtSM3u', '15012341234', 'luban@dnsjia.com', '管理员', 'https://pic3.zhimg.com/v2-10ba6cb8ed5e922d5aa45f3a9abf7fba_xs.jpg?source=172ae18b', 1, 3, 1, '', '', NULL, NULL);
COMMIT;


DROP TABLE IF EXISTS `vm_env_config`;
CREATE TABLE `vm_env_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deploy_path` varchar(191) DEFAULT '/data/webapps' COMMENT '''部署路径''',
  `'runuser'` varchar(191) DEFAULT 'luban' COMMENT '''进程启动用户''',
  `'framework'` varchar(191) DEFAULT NULL COMMENT '''系统框架''',
  `server_port` int(11) DEFAULT NULL COMMENT '''服务端口(30000~50000)''',
  `start_script` longtext COMMENT '''启动脚本''',
  `stop_script` longtext COMMENT '''停止脚本''',
  `check_script` longtext COMMENT '''健康状态检查脚本''',
  `'appctl'` longtext COMMENT '''控制脚本''',
  `package_path` varchar(191) DEFAULT NULL COMMENT '''构建物路径''',
  `is_enable_monitor` tinyint(1) DEFAULT '0' COMMENT '''应用监控接入''',
  `monitor_path` varchar(191) DEFAULT '/actuator/prometheus' COMMENT '''采集路径''',
  `monitor_port` int(11) DEFAULT '30030' COMMENT '''采集端口''',
  `tomcat_path` longtext COMMENT '''tomcat路径''',
  `tomcat_port` int(11) DEFAULT '8080' COMMENT '''tomcat端口''',
  `shutdown_port` int(11) DEFAULT NULL COMMENT '''tomcat关闭端口''',
  `redirect_port` int(11) DEFAULT NULL COMMENT '''redirectPort''',
  `ajp_port` int(11) DEFAULT NULL COMMENT '''ajpPort''',
  PRIMARY KEY (`id`),
  KEY `idx_vm_env_config_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `workflow`;
CREATE TABLE `workflow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `task_id` varchar(191) DEFAULT NULL COMMENT '任务ID',
  `instance_id` varchar(191) DEFAULT NULL COMMENT '审批实例ID',
  PRIMARY KEY (`id`),
  KEY `idx_workflow_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


SET FOREIGN_KEY_CHECKS = 1;
