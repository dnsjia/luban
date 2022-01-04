/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.96
Source Server Version : 50648
Source Host           : 192.168.1.96:3306
Source Database       : luban

Target Server Type    : MYSQL
Target Server Version : 50648
File Encoding         : 65001

Date: 2022-01-04 15:14:59
*/

SET FOREIGN_KEY_CHECKS=0;

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
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of casbin_rule
-- ----------------------------
INSERT INTO `casbin_rule` VALUES ('81', 'p', 'develop', '/api/v1/casbin', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('30', 'p', 'develop', '/api/v1/cloud/account', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('6', 'p', 'develop', '/api/v1/cmdb/host/group', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('7', 'p', 'develop', '/api/v1/cmdb/host/group', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('19', 'p', 'develop', '/api/v1/cmdb/host/server', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('3', 'p', 'develop', '/api/v1/k8s/cluster', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('2', 'p', 'develop', '/api/v1/k8s/cluster', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('4', 'p', 'develop', '/api/v1/k8s/cluster/delete', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('5', 'p', 'develop', '/api/v1/k8s/cluster/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('10', 'p', 'develop', '/api/v1/k8s/cluster/secret', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('71', 'p', 'develop', '/api/v1/k8s/config/configmap', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('68', 'p', 'develop', '/api/v1/k8s/config/configmap', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('69', 'p', 'develop', '/api/v1/k8s/config/configmap/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('70', 'p', 'develop', '/api/v1/k8s/config/configmaps', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('73', 'p', 'develop', '/api/v1/k8s/config/secret', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('72', 'p', 'develop', '/api/v1/k8s/config/secret', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('74', 'p', 'develop', '/api/v1/k8s/config/secret/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('75', 'p', 'develop', '/api/v1/k8s/config/secrets', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('50', 'p', 'develop', '/api/v1/k8s/cronjob', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('48', 'p', 'develop', '/api/v1/k8s/cronjob', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('51', 'p', 'develop', '/api/v1/k8s/cronjob/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('49', 'p', 'develop', '/api/v1/k8s/cronjobs', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('40', 'p', 'develop', '/api/v1/k8s/daemonset', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('38', 'p', 'develop', '/api/v1/k8s/daemonset', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('42', 'p', 'develop', '/api/v1/k8s/daemonset/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('41', 'p', 'develop', '/api/v1/k8s/daemonset/restart', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('39', 'p', 'develop', '/api/v1/k8s/daemonsets', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('17', 'p', 'develop', '/api/v1/k8s/deployment', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('24', 'p', 'develop', '/api/v1/k8s/deployment/delete', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('25', 'p', 'develop', '/api/v1/k8s/deployment/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('22', 'p', 'develop', '/api/v1/k8s/deployment/restart', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('26', 'p', 'develop', '/api/v1/k8s/deployment/rollback', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('21', 'p', 'develop', '/api/v1/k8s/deployment/scale', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('23', 'p', 'develop', '/api/v1/k8s/deployment/service', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('20', 'p', 'develop', '/api/v1/k8s/deployments', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('8', 'p', 'develop', '/api/v1/k8s/events', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('44', 'p', 'develop', '/api/v1/k8s/job', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('43', 'p', 'develop', '/api/v1/k8s/job', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('47', 'p', 'develop', '/api/v1/k8s/job/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('46', 'p', 'develop', '/api/v1/k8s/job/scale', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('45', 'p', 'develop', '/api/v1/k8s/jobs', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('77', 'p', 'develop', '/api/v1/k8s/log/:namespace/:pod', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('78', 'p', 'develop', '/api/v1/k8s/log/:namespace/:pod/:container', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('79', 'p', 'develop', '/api/v1/k8s/log/file/:namespace/:pod/:container', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('76', 'p', 'develop', '/api/v1/k8s/log/source/:namespace/:resourceName/:resourceType', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('18', 'p', 'develop', '/api/v1/k8s/namespace', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('67', 'p', 'develop', '/api/v1/k8s/network/ingress', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('64', 'p', 'develop', '/api/v1/k8s/network/ingress', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('65', 'p', 'develop', '/api/v1/k8s/network/ingress/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('66', 'p', 'develop', '/api/v1/k8s/network/ingresss', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('62', 'p', 'develop', '/api/v1/k8s/network/service', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('60', 'p', 'develop', '/api/v1/k8s/network/service', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('63', 'p', 'develop', '/api/v1/k8s/network/service/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('61', 'p', 'develop', '/api/v1/k8s/network/services', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('14', 'p', 'develop', '/api/v1/k8s/node', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('9', 'p', 'develop', '/api/v1/k8s/node', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('16', 'p', 'develop', '/api/v1/k8s/node/collectionCordon', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('15', 'p', 'develop', '/api/v1/k8s/node/collectionSchedule', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('13', 'p', 'develop', '/api/v1/k8s/node/cordon', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('11', 'p', 'develop', '/api/v1/k8s/node/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('12', 'p', 'develop', '/api/v1/k8s/node/schedule', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('29', 'p', 'develop', '/api/v1/k8s/pod', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('27', 'p', 'develop', '/api/v1/k8s/pod', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('31', 'p', 'develop', '/api/v1/k8s/pod/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('28', 'p', 'develop', '/api/v1/k8s/pods', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('34', 'p', 'develop', '/api/v1/k8s/statefulset', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('32', 'p', 'develop', '/api/v1/k8s/statefulset', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('37', 'p', 'develop', '/api/v1/k8s/statefulset/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('35', 'p', 'develop', '/api/v1/k8s/statefulset/restart', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('36', 'p', 'develop', '/api/v1/k8s/statefulset/scale', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('33', 'p', 'develop', '/api/v1/k8s/statefulsets', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('56', 'p', 'develop', '/api/v1/k8s/storage/pv', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('55', 'p', 'develop', '/api/v1/k8s/storage/pv', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('57', 'p', 'develop', '/api/v1/k8s/storage/pv/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('54', 'p', 'develop', '/api/v1/k8s/storage/pvc', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('52', 'p', 'develop', '/api/v1/k8s/storage/pvc', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('53', 'p', 'develop', '/api/v1/k8s/storage/pvc/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('58', 'p', 'develop', '/api/v1/k8s/storage/sc', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('59', 'p', 'develop', '/api/v1/k8s/storage/sc/detail', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('1', 'p', 'develop', '/api/v1/user/info', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('83', 'p', 'test', '/api/v1/user/info', 'GET', '', '', '');

-- ----------------------------
-- Table structure for cloud_platform
-- ----------------------------
DROP TABLE IF EXISTS `cloud_platform`;
CREATE TABLE `cloud_platform` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(191) DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL,
  `access_key` varchar(191) DEFAULT NULL,
  `secret_key` varchar(191) DEFAULT NULL,
  `region` varchar(191) DEFAULT NULL,
  `remark` varchar(191) DEFAULT NULL,
  `status` bigint(20) DEFAULT NULL,
  `msg` varchar(191) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sync_time` datetime DEFAULT NULL,
  `enable` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

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
  `hostname` varchar(191) DEFAULT NULL COMMENT '''主机名''',
  `cpu` bigint(20) DEFAULT NULL COMMENT '''CPU''',
  `mem` bigint(20) DEFAULT NULL COMMENT '''内存''',
  `os` varchar(191) DEFAULT NULL COMMENT '''操作系统''',
  `os_type` varchar(191) DEFAULT NULL COMMENT '''系统类型''',
  `mac_addr` varchar(191) DEFAULT NULL COMMENT '''物理地址''',
  `private_addr` varchar(191) DEFAULT NULL COMMENT '''私网地址''',
  `public_addr` varchar(191) DEFAULT NULL COMMENT '''公网地址''',
  `sn` varchar(191) DEFAULT NULL COMMENT '''SN序列号''',
  `bandwidth` bigint(20) DEFAULT NULL COMMENT '''带宽''',
  `status` varchar(191) DEFAULT NULL,
  `region` varchar(191) DEFAULT NULL COMMENT '''机房''',
  `source` varchar(191) DEFAULT NULL,
  `vm_created_time` varchar(191) DEFAULT NULL,
  `vm_expired_time` varchar(191) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `port` varchar(191) DEFAULT NULL,
  `password` varchar(191) DEFAULT NULL,
  `user_name` varchar(191) DEFAULT NULL,
  `username` varchar(191) DEFAULT NULL COMMENT '''用户''',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of cloud_virtual_machine
-- ----------------------------

-- ----------------------------
-- Table structure for dept
-- ----------------------------
DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '''自增编号''',
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
INSERT INTO `dept` VALUES ('1', '2021-09-24 15:56:54', '2021-09-24 15:56:57', null, '开发', '0', '0');
INSERT INTO `dept` VALUES ('2', null, null, null, '测试', '0', '0');

-- ----------------------------
-- Table structure for hosts_group
-- ----------------------------
DROP TABLE IF EXISTS `hosts_group`;
CREATE TABLE `hosts_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `parent_id` bigint(20) DEFAULT '0',
  `sort_id` bigint(20) DEFAULT '0',
  `hide` bigint(20) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of hosts_group
-- ----------------------------
INSERT INTO `hosts_group` VALUES ('1', 'Default', '0', '0', '0');
INSERT INTO `hosts_group` VALUES ('11', '腾讯云', '0', '1', '0');
INSERT INTO `hosts_group` VALUES ('12', '阿里云', '0', '2', '0');

-- ----------------------------
-- Table structure for hosts_group_virtual_machines
-- ----------------------------
DROP TABLE IF EXISTS `hosts_group_virtual_machines`;
CREATE TABLE `hosts_group_virtual_machines` (
  `virtual_machine_id` bigint(20) NOT NULL,
  `tree_menu_id` bigint(20) NOT NULL,
  PRIMARY KEY (`virtual_machine_id`,`tree_menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of hosts_group_virtual_machines
-- ----------------------------

-- ----------------------------
-- Table structure for k8s_cluster
-- ----------------------------
DROP TABLE IF EXISTS `k8s_cluster`;
CREATE TABLE `k8s_cluster` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cluster_name` varchar(191) DEFAULT NULL COMMENT '集群名称',
  `kube_config` varchar(12800) DEFAULT NULL COMMENT '集群凭证',
  `cluster_version` varchar(191) DEFAULT NULL COMMENT '集群版本',
  `node_number` tinyint(4) DEFAULT NULL COMMENT '节点数',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_k8s_cluster_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of k8s_cluster
-- ----------------------------

-- ----------------------------
-- Table structure for k8s_cluster_version
-- ----------------------------
DROP TABLE IF EXISTS `k8s_cluster_version`;
CREATE TABLE `k8s_cluster_version` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '''自增编号''',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `version` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_k8s_cluster_version_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of k8s_cluster_version
-- ----------------------------
INSERT INTO `k8s_cluster_version` VALUES ('1', '2021-09-27 18:55:28', '2021-09-27 18:55:28', null, 'v1.18.11');
INSERT INTO `k8s_cluster_version` VALUES ('2', '2021-09-27 18:55:28', '2021-09-27 18:55:28', null, 'v1.18.12');

-- ----------------------------
-- Table structure for k8s_lists
-- ----------------------------
DROP TABLE IF EXISTS `k8s_lists`;
CREATE TABLE `k8s_lists` (
  `version` varchar(191) DEFAULT NULL COMMENT '''k8s版本''',
  `name` varchar(191) DEFAULT NULL COMMENT '''集群名称'''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of k8s_lists
-- ----------------------------

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '''自增编号''',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL COMMENT '''菜单名称''',
  `icon` varchar(64) DEFAULT NULL COMMENT '''菜单图标''',
  `path` varchar(64) DEFAULT NULL COMMENT '''菜单访问路径''',
  `sort` int(3) DEFAULT '0' COMMENT '''菜单顺序(同级菜单, 从0开始, 越小显示越靠前)''',
  `parent_id` bigint(20) unsigned DEFAULT '0' COMMENT '''父菜单编号(编号为0时表示根菜单)''',
  `creator` varchar(64) DEFAULT NULL COMMENT '''创建人''',
  PRIMARY KEY (`id`),
  KEY `idx_menu_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of menu
-- ----------------------------

-- ----------------------------
-- Table structure for relation_group_host
-- ----------------------------
DROP TABLE IF EXISTS `relation_group_host`;
CREATE TABLE `relation_group_host` (
  `tree_menu_id` bigint(20) NOT NULL,
  `virtual_machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`tree_menu_id`,`virtual_machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of relation_group_host
-- ----------------------------

-- ----------------------------
-- Table structure for relation_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `relation_role_menu`;
CREATE TABLE `relation_role_menu` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  `menu_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '''自增编号''',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of relation_role_menu
-- ----------------------------

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '''自增编号''',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL COMMENT '''角色名称''',
  `desc` varchar(128) DEFAULT NULL COMMENT '''角色描述''',
  PRIMARY KEY (`id`),
  KEY `idx_role_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '2021-09-18 12:32:05', '2021-09-18 12:32:07', null, 'develop', '开发');

-- ----------------------------
-- Table structure for ssh_global_config
-- ----------------------------
DROP TABLE IF EXISTS `ssh_global_config`;
CREATE TABLE `ssh_global_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(191) DEFAULT NULL COMMENT '''用户''',
  `password` varchar(191) DEFAULT NULL COMMENT '''密码''',
  `port` varchar(191) DEFAULT '22' COMMENT '''端口''',
  `private_key` varchar(191) DEFAULT NULL,
  `enable` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of ssh_global_config
-- ----------------------------

-- ----------------------------
-- Table structure for ssh_record
-- ----------------------------
DROP TABLE IF EXISTS `ssh_record`;
CREATE TABLE `ssh_record` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `connect_id` varchar(64) DEFAULT NULL COMMENT '''连接标识''',
  `user_name` varchar(128) DEFAULT NULL COMMENT '''系统用户名''',
  `host_name` varchar(128) DEFAULT NULL COMMENT '''主机名''',
  `connect_time` datetime DEFAULT NULL COMMENT '''接入时间''',
  `logout_time` datetime DEFAULT NULL COMMENT '''注销时间''',
  `records` longblob COMMENT '''操作记录(二进制存储)''',
  `host_id` bigint(20) DEFAULT NULL COMMENT '''主机Id外键''',
  PRIMARY KEY (`id`),
  KEY `idx_ssh_record_deleted_at` (`deleted_at`),
  KEY `idx_ssh_record_connect_time` (`connect_time`),
  KEY `idx_ssh_record_logout_time` (`logout_time`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of ssh_record
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '''自增编号''',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `username` varchar(128) DEFAULT NULL COMMENT '''用户名''',
  `password` varchar(128) DEFAULT NULL COMMENT '''用户密码''',
  `phone` varchar(11) DEFAULT NULL COMMENT '''手机号码''',
  `email` varchar(128) DEFAULT NULL COMMENT '''邮箱''',
  `nick_name` varchar(128) DEFAULT NULL COMMENT '''用户昵称''',
  `avatar` varchar(128) DEFAULT 'http://dnsjia.com/img/avatar.png' COMMENT '''用户头像''',
  `status` tinyint(1) DEFAULT '1' COMMENT '''用户状态(正常/禁用, 默认正常)''',
  `role_id` bigint(20) unsigned DEFAULT NULL COMMENT '''角色id外键''',
  `dept_id` bigint(20) unsigned DEFAULT NULL COMMENT '''部门id外键''',
  `uid` bigint(20) DEFAULT NULL COMMENT '''用戶uid''',
  `create_by` varchar(191) DEFAULT NULL COMMENT '''创建来源''',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_users_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', '2021-09-18 12:30:28', '2021-09-18 12:30:28', null, 'luban', '$2a$10$zn0dAfLmdIC2ff9dkAN7LezbwUFaHfsR6Aqis/jLHTJFy5rBUeey6', '0', 'luban@qq.com', '', 'http://dnsjia.com/img/avatar.png', '1', '1', '0', null, null);
