DROP TABLE IF EXISTS `w_flow`;
CREATE TABLE `w_flow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '流程名称',
  `code` varchar(191) DEFAULT NULL COMMENT '流程标识',
  `created_by` varchar(191) DEFAULT NULL COMMENT '创建人',
  `flow_group_id` bigint(20) DEFAULT NULL COMMENT '流程分组ID',
  `flow_template_id` bigint(20) DEFAULT NULL COMMENT '流程模板ID',
  `notice_type` varchar(191) DEFAULT NULL COMMENT '通知类型',
  `webhook` varchar(191) DEFAULT NULL COMMENT 'webhook地址',
  PRIMARY KEY (`id`),
  KEY `idx_w_flow_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `w_flow_approval_log`;
CREATE TABLE `w_flow_approval_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `flow_id` bigint(20) DEFAULT NULL COMMENT '流程ID',
  `step_id` bigint(20) DEFAULT NULL COMMENT '步骤ID',
  `username` varchar(191) DEFAULT NULL COMMENT '用户',
  `status` varchar(191) DEFAULT 'pending' COMMENT '状态（pending等待审批、approved审批同意、rejected审批拒绝）',
  `task_id` varchar(191) DEFAULT NULL COMMENT '任务ID',
  PRIMARY KEY (`id`),
  KEY `idx_w_flow_approval_log_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `w_flow_group`;
CREATE TABLE `w_flow_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '分组名称',
  `label` varchar(191) DEFAULT NULL COMMENT '分组标识',
  `created_by` varchar(191) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_w_flow_group_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `w_flow_step`;
CREATE TABLE `w_flow_step` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `flow_id` bigint(20) DEFAULT NULL COMMENT '流程ID',
  `desc` varchar(191) DEFAULT NULL COMMENT '步骤名称',
  `type` bigint(20) DEFAULT NULL COMMENT '步骤类型',
  `approved_by` json DEFAULT NULL COMMENT '审批人',
  PRIMARY KEY (`id`),
  KEY `idx_w_flow_step_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `w_flow_template`;
CREATE TABLE `w_flow_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '流程模板名称',
  `code` varchar(191) DEFAULT NULL COMMENT '流程模板标识',
  `created_by` varchar(191) DEFAULT NULL COMMENT '创建人',
  `desc` varchar(191) DEFAULT NULL COMMENT '描述信息',
  `form_structure` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_w_flow_template_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;


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
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4;
