@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:menu
cls
echo.
echo ╔════════════════════════════════════════╗
echo ║     JobHub 后端服务管理工具            ║
echo ╚════════════════════════════════════════╝
echo.
echo 1. 启动服务器
echo 2. 停止服务器
echo 3. 重启服务器
echo 4. 查看日志
echo 5. 查看进程状态
echo 6. 退出
echo.
set /p choice="请选择操作 (1-6): "

if "%choice%"=="1" goto start
if "%choice%"=="2" goto stop
if "%choice%"=="3" goto restart
if "%choice%"=="4" goto logs
if "%choice%"=="5" goto status
if "%choice%"=="6" goto exit
echo ❌ 无效选择，请重试
timeout /t 2 >nul
goto menu

:start
cls
echo.
echo 🚀 正在启动服务器...
echo.
cd /d "D:\Project\JobsProject-Backend"
pm2 start ecosystem.config.js
echo.
echo ✅ 服务器已启动
echo.
timeout /t 3 >nul
goto menu

:stop
cls
echo.
echo 🛑 正在停止服务器...
echo.
pm2 stop jobshub
echo.
echo ✅ 服务器已停止
echo.
timeout /t 3 >nul
goto menu

:restart
cls
echo.
echo 🔄 正在重启服务器...
echo.
pm2 restart jobshub
echo.
echo ✅ 服务器已重启
echo.
timeout /t 3 >nul
goto menu

:logs
cls
echo.
echo 📋 实时日志（按 Ctrl+C 退出）
echo.
pm2 logs jobshub
goto menu

:status
cls
echo.
echo 📊 进程状态
echo.
pm2 list
echo.
pause
goto menu

:exit
exit /b 0
