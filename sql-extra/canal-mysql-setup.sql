-- ============================================================
-- Canal 前置配置：MySQL 开启 binlog + 创建 canal 账号
-- ============================================================

-- 【第一步】修改 MySQL 配置文件 my.ini
-- Windows 下一般在：C:\ProgramData\MySQL\MySQL Server 8.4\my.ini
-- 在 [mysqld] 段追加以下内容，然后重启 MySQL 服务：
--
--   [mysqld]
--   server-id = 1
--   log-bin = mysql-bin
--   binlog-format = ROW
--   binlog-row-image = FULL
--   expire_logs_days = 7
--
-- 注意：server-id 在本机唯一即可；binlog-format 必须是 ROW，否则 Canal 解析不了。

-- 【第二步】执行下面的 SQL，创建 Canal 专用账号
-- 账号/密码默认 canal/canal，与 Canal 服务器 conf/canal.properties 一致
CREATE USER IF NOT EXISTS 'canal'@'%' IDENTIFIED BY 'canal';

-- MySQL 8.x 用 REPLICATION SLAVE（8.0.22+ 已弃用但 8.4 通常仍兼容）
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'canal'@'%';
-- 若上面 GRANT 在 MySQL 8.4 报错，改用下面这行（SLAVE 改 REPLICA）：
-- GRANT SELECT, REPLICATION REPLICA, REPLICATION CLIENT ON *.* TO 'canal'@'%';

FLUSH PRIVILEGES;

-- 【验证】执行后应看到 log_bin=ON、binlog_format=ROW、server_id 已设置：
-- SHOW VARIABLES LIKE 'log_bin';
-- SHOW VARIABLES LIKE 'binlog_format';
-- SHOW VARIABLES LIKE 'server_id';
