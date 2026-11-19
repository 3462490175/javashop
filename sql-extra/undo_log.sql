-- ============================================================
-- Seata AT 模式回滚日志表 undo_log
-- 需要建在「参与分布式事务」的每个业务库中。
-- 本项目至少：shop_goods、shop_order
-- 其余库（shop_pay/shop_permission/shop_seckill/shop_user）若也
-- 作为 RM 参与全局事务（@GlobalTransactional），同样需要此表。
-- ============================================================

CREATE TABLE IF NOT EXISTS `undo_log` (
  `id`            BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `branch_id`     BIGINT(20)   NOT NULL COMMENT '分支事务ID',
  `xid`           VARCHAR(100) NOT NULL COMMENT '全局事务ID',
  `context`       VARCHAR(128) NOT NULL COMMENT '上下文信息',
  `rollback_info` LONGBLOB     NOT NULL COMMENT '回滚信息（before image）',
  `log_status`    INT(11)      NOT NULL COMMENT '状态：0=正常 1=已全局提交',
  `log_created`   DATETIME     NOT NULL COMMENT '创建时间',
  `log_modified`  DATETIME     NOT NULL COMMENT '修改时间',
  `ext`           VARCHAR(100) DEFAULT NULL COMMENT '扩展字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_undo_log` (`xid`, `branch_id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4 COMMENT = 'Seata AT 模式回滚日志表';
