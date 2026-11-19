@echo off
chcp 65001 >nul
rem ============================================================
rem  云商城中间件一键启动
rem  组件：Nacos(8848) + Redis(6379) + RocketMQ(9876/10911) + Elasticsearch(9200)
rem  说明：Nacos 官方 startup.cmd 在含括号路径 shop(1) 下会解析失败，
rem        故 Nacos 直接用 java 命令行启动，效果等同 standalone 模式。
rem        RocketMQ / ES 路径不含括号，用官方脚本即可。
rem ============================================================

set "PROJ=V:\BaiduNetdiskDownload\shop(1)"
set "JAVA=%PROJ%\middleware\jdk8\jdk8u512-b09\bin\java.exe"
set "JAVA_HOME=%PROJ%\middleware\jdk8\jdk8u512-b09"
set "NACOS=%PROJ%\middleware\nacos\nacos"
set "REDIS=%PROJ%\middleware\redis"
set "ROCKETMQ_HOME=V:\BaiduNetdiskDownload\rocketmq-all-4.7.1-bin-release\rocketmq-all-4.7.1-bin-release"
set "ES_HOME=V:\BaiduNetdiskDownload\elasticsearch-6.8.12\elasticsearch-6.8.12"
set "ES_PATH_CONF=%ES_HOME%\config"

echo [1/5] 启动 Nacos 注册与配置中心（端口 8848）...
start "nacos" "%JAVA%" -Xms512m -Xmx512m -Xmn256m ^
  -Dnacos.standalone=true ^
  "-Dloader.path=%NACOS%/plugins,%NACOS%/plugins/health,%NACOS%/plugins/cmdb,%NACOS%/plugins/selector" ^
  "-Dnacos.home=%NACOS%" ^
  -jar "%NACOS%\target\nacos-server.jar" ^
  "--spring.config.additional-location=file:%NACOS%/conf/" ^
  "--logging.config=%NACOS%/conf/nacos-logback.xml" ^
  nacos.nacos -m standalone

echo [2/5] 启动 Redis（端口 6379）...
start "redis" "%REDIS%\redis-server.exe" "%REDIS%\redis.windows.conf"

echo [3/5] 启动 RocketMQ NameServer（端口 9876）...
start "rocketmq-namesrv" cmd /c "call "%ROCKETMQ_HOME%\bin\mqnamesrv.cmd" & pause"

rem NameServer 需要几秒就绪，稍候再拉起 Broker
timeout /t 8 /nobreak >nul

echo [4/5] 启动 RocketMQ Broker（端口 10911，brokerIP1=10.86.107.170）...
start "rocketmq-broker" cmd /c "call "%ROCKETMQ_HOME%\bin\mqbroker.cmd" -n 127.0.0.1:9876 -c "%ROCKETMQ_HOME%\conf\broker.conf" & pause"

echo [5/5] 启动 Elasticsearch（端口 9200，已装 IK 分词器）...
start "elasticsearch" cmd /c "call "%ES_HOME%\bin\elasticsearch.bat" & pause"

echo.
echo ============================================================
echo  五个服务已在新窗口启动，请稍候约 30 秒待其完全就绪。
echo.
echo  验证地址：
echo    Nacos 控制台   http://127.0.0.1:8848/nacos/   （账号 nacos/nacos）
echo    Elasticsearch  http://127.0.0.1:9200/         （返回 JSON 即正常）
echo    RocketMQ       9876 / 10911 端口（无自带界面，需另配 console）
echo    Redis          6379 端口
echo.
echo  关闭服务：直接关掉对应的命令行窗口即可。
echo ============================================================
pause
