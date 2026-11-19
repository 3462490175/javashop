-- ============================================================
-- shop_pay 数据库初始化脚本（本机补齐版）
-- 说明：网盘原 sql 目录未提供该库脚本，本脚本依据 mall-pay-api
--       中 PayLog 实体（@TableName("pay_log")）反推生成。
--       仅建表结构，无业务数据。
-- ============================================================

CREATE DATABASE IF NOT EXISTS shop_pay DEFAULT CHARACTER SET utf8mb4;
USE shop_pay;

-- 支付流水表
-- id 为 ASSIGN_UUID，故用 varchar(50) 主键，非自增
DROP TABLE IF EXISTS `pay_log`;
CREATE TABLE `pay_log` (
  `id`          varchar(50)  NOT NULL COMMENT '支付流水ID(UUID)',
  `status`      int(11)      DEFAULT NULL COMMENT '支付状态',
  `content`     text         COMMENT '支付内容/回调报文',
  `pay_id`      varchar(50)  DEFAULT NULL COMMENT '关联订单支付ID',
  `create_time` datetime     DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_pay_id` (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付流水表';
