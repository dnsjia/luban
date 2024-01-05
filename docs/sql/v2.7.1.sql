ALTER TABLE `deploy_history` ADD `is_rollback` tinyint(1) DEFAULT NULL COMMENT '是否回滚';
-- 接口权限
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (131, '列出应用可回滚版本', 0, '/api/v1/cicd/deploy/rollback', 'GET');
INSERT INTO `permissions` (`pid`, `name`, `sort`, `path`, `method`) VALUES (131, '回滚应用版本', 0, '/api/v1/cicd/deploy/rollback', 'POST');
 
ALTER TABLE `system_settings` ADD COLUMN license TEXT COMMENT 'license授权'
