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
INSERT INTO `casbin_rule` VALUES ('3', 'p', 'develop', '/api/v1/k8s/cluster', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('2', 'p', 'develop', '/api/v1/k8s/cluster', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('4', 'p', 'develop', '/api/v1/k8s/delCluster', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('1', 'p', 'develop', '/api/v1/user/info', 'GET', null, null, null);
