/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.96
Source Server Version : 50648
Source Host           : 192.168.1.96:3306
Source Database       : go_test

Target Server Type    : MYSQL
Target Server Version : 50648
File Encoding         : 65001

Date: 2021-09-27 14:32:56
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of casbin_rule
-- ----------------------------
INSERT INTO `casbin_rule` VALUES (81, 'p', 'develop', '/api/v1/casbin', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (30, 'p', 'develop', '/api/v1/cloud/account', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (6, 'p', 'develop', '/api/v1/cmdb/host/group', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (7, 'p', 'develop', '/api/v1/cmdb/host/group', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (19, 'p', 'develop', '/api/v1/cmdb/host/server', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (3, 'p', 'develop', '/api/v1/k8s/cluster', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (2, 'p', 'develop', '/api/v1/k8s/cluster', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (4, 'p', 'develop', '/api/v1/k8s/cluster/delete', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (5, 'p', 'develop', '/api/v1/k8s/cluster/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (10, 'p', 'develop', '/api/v1/k8s/cluster/secret', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (71, 'p', 'develop', '/api/v1/k8s/config/configmap', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (68, 'p', 'develop', '/api/v1/k8s/config/configmap', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (69, 'p', 'develop', '/api/v1/k8s/config/configmap/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (70, 'p', 'develop', '/api/v1/k8s/config/configmaps', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (73, 'p', 'develop', '/api/v1/k8s/config/secret', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (72, 'p', 'develop', '/api/v1/k8s/config/secret', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (74, 'p', 'develop', '/api/v1/k8s/config/secret/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (75, 'p', 'develop', '/api/v1/k8s/config/secrets', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (50, 'p', 'develop', '/api/v1/k8s/cronjob', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (48, 'p', 'develop', '/api/v1/k8s/cronjob', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (51, 'p', 'develop', '/api/v1/k8s/cronjob/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (49, 'p', 'develop', '/api/v1/k8s/cronjobs', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (40, 'p', 'develop', '/api/v1/k8s/daemonset', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (38, 'p', 'develop', '/api/v1/k8s/daemonset', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (42, 'p', 'develop', '/api/v1/k8s/daemonset/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (41, 'p', 'develop', '/api/v1/k8s/daemonset/restart', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (39, 'p', 'develop', '/api/v1/k8s/daemonsets', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (17, 'p', 'develop', '/api/v1/k8s/deployment', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (24, 'p', 'develop', '/api/v1/k8s/deployment/delete', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (25, 'p', 'develop', '/api/v1/k8s/deployment/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (22, 'p', 'develop', '/api/v1/k8s/deployment/restart', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (26, 'p', 'develop', '/api/v1/k8s/deployment/rollback', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (21, 'p', 'develop', '/api/v1/k8s/deployment/scale', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (23, 'p', 'develop', '/api/v1/k8s/deployment/service', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (20, 'p', 'develop', '/api/v1/k8s/deployments', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (8, 'p', 'develop', '/api/v1/k8s/events', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (44, 'p', 'develop', '/api/v1/k8s/job', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (43, 'p', 'develop', '/api/v1/k8s/job', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (47, 'p', 'develop', '/api/v1/k8s/job/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (46, 'p', 'develop', '/api/v1/k8s/job/scale', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (45, 'p', 'develop', '/api/v1/k8s/jobs', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (77, 'p', 'develop', '/api/v1/k8s/log/:namespace/:pod', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (78, 'p', 'develop', '/api/v1/k8s/log/:namespace/:pod/:container', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (79, 'p', 'develop', '/api/v1/k8s/log/file/:namespace/:pod/:container', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (76, 'p', 'develop', '/api/v1/k8s/log/source/:namespace/:resourceName/:resourceType', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (18, 'p', 'develop', '/api/v1/k8s/namespace', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (67, 'p', 'develop', '/api/v1/k8s/network/ingress', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (64, 'p', 'develop', '/api/v1/k8s/network/ingress', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (65, 'p', 'develop', '/api/v1/k8s/network/ingress/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (66, 'p', 'develop', '/api/v1/k8s/network/ingresss', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (62, 'p', 'develop', '/api/v1/k8s/network/service', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (60, 'p', 'develop', '/api/v1/k8s/network/service', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (63, 'p', 'develop', '/api/v1/k8s/network/service/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (61, 'p', 'develop', '/api/v1/k8s/network/services', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (14, 'p', 'develop', '/api/v1/k8s/node', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (9, 'p', 'develop', '/api/v1/k8s/node', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (16, 'p', 'develop', '/api/v1/k8s/node/collectionCordon', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (15, 'p', 'develop', '/api/v1/k8s/node/collectionSchedule', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (13, 'p', 'develop', '/api/v1/k8s/node/cordon', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (11, 'p', 'develop', '/api/v1/k8s/node/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (12, 'p', 'develop', '/api/v1/k8s/node/schedule', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (29, 'p', 'develop', '/api/v1/k8s/pod', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (27, 'p', 'develop', '/api/v1/k8s/pod', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (31, 'p', 'develop', '/api/v1/k8s/pod/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (28, 'p', 'develop', '/api/v1/k8s/pods', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (34, 'p', 'develop', '/api/v1/k8s/statefulset', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (32, 'p', 'develop', '/api/v1/k8s/statefulset', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (37, 'p', 'develop', '/api/v1/k8s/statefulset/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (35, 'p', 'develop', '/api/v1/k8s/statefulset/restart', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (36, 'p', 'develop', '/api/v1/k8s/statefulset/scale', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (33, 'p', 'develop', '/api/v1/k8s/statefulsets', 'POST', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (56, 'p', 'develop', '/api/v1/k8s/storage/pv', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (55, 'p', 'develop', '/api/v1/k8s/storage/pv', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (57, 'p', 'develop', '/api/v1/k8s/storage/pv/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (54, 'p', 'develop', '/api/v1/k8s/storage/pvc', 'DELETE', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (52, 'p', 'develop', '/api/v1/k8s/storage/pvc', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (53, 'p', 'develop', '/api/v1/k8s/storage/pvc/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (58, 'p', 'develop', '/api/v1/k8s/storage/sc', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (59, 'p', 'develop', '/api/v1/k8s/storage/sc/detail', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (1, 'p', 'develop', '/api/v1/user/info', 'GET', NULL, NULL, NULL);
INSERT INTO `casbin_rule` VALUES (83, 'p', 'test', '/api/v1/user/info', 'GET', '', '', '');

