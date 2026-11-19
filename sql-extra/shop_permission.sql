-- ============================================================
-- shop_permission 数据库初始化脚本（本机补齐版）
-- 说明：网盘原 sql 目录未提供该库脚本，本脚本依据 mall-permission-api
--       实体（permission / role_info）与 PermissionMapper 中的
--       SELECT * FROM role_permission（代码读取 rid、pid 两列）反推生成。
--       表结构可直接使用；示例数据仅为让权限初始化逻辑不空转，可按需删改。
-- ============================================================

CREATE DATABASE IF NOT EXISTS shop_permission DEFAULT CHARACTER SET utf8mb4;
USE shop_permission;

-- 权限（资源）表
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `id`          int(11)     NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `source_name` varchar(100) DEFAULT NULL COMMENT '资源名称',
  `url`         varchar(200) DEFAULT NULL COMMENT '资源URL',
  `url_match`   int(3)      DEFAULT NULL COMMENT '匹配方式 0-完全匹配 1-前缀匹配',
  `service_name` varchar(100) DEFAULT NULL COMMENT '所属服务名',
  `method`      varchar(50)  DEFAULT NULL COMMENT '请求方法',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限资源表';

-- 角色表
DROP TABLE IF EXISTS `role_info`;
CREATE TABLE `role_info` (
  `id`          int(11)     NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name`   varchar(100) DEFAULT NULL COMMENT '角色名',
  `description` varchar(200) DEFAULT NULL COMMENT '角色描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 角色-权限关联表（列名 rid/pid 由代码 SELECT * FROM role_permission 后按 rid、pid 取值确定）
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission` (
  `rid` int(11) NOT NULL COMMENT '角色ID',
  `pid` int(11) NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`rid`, `pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 示例数据：一个管理员角色 + 一条放行示例，可按课程需要自行调整或删除
INSERT INTO `role_info` (`id`, `role_name`, `description`) VALUES (1, 'admin', '管理员');
INSERT INTO `permission` (`id`, `source_name`, `url`, `url_match`, `service_name`, `method`) VALUES
  (1, '商品查询', '/brand/**', 1, 'mall-goods', 'GET');
INSERT INTO `role_permission` (`rid`, `pid`) VALUES (1, 1);
