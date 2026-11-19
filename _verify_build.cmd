@echo off
chcp 65001 >nul
rem 临时构建验证脚本：用 IDEA 内置 Maven 编译 goods 服务及其依赖链
set "JAVA_HOME=V:\BaiduNetdiskDownload\shop(1)\middleware\jdk8\jdk8u512-b09"
set "MVN=V:\idea\IntelliJ IDEA 2026.2.1\plugins\maven-plugin\lib\maven3\bin\mvn.cmd"
set "REPO=V:\maven_repo"
cd /d "V:\BaiduNetdiskDownload\shop(1)\shop\gupaoedu-vip-mall"
echo ===== 开始编译（goods 服务 + 其依赖模块，离线优先）=====
call "%MVN%" -Dmaven.repo.local=%REPO% -o -pl mall-service/mall-goods-service -am clean install -DskipTests -q
echo ===== EXIT_CODE=%ERRORLEVEL% =====
