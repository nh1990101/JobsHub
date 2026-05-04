@echo off
REM JobHub 后台启动脚本

echo.
echo ====================================
echo   JobHub API 服务启动脚本
echo ====================================
echo.

REM 检查 Node.js 是否安装
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ 错误：未找到 Node.js，请先安装 Node.js
    pause
    exit /b 1
)

REM 检查依赖是否已安装
if not exist "node_modules" (
    echo 📦 正在安装依赖...
    call npm install
    if %errorlevel% neq 0 (
        echo ❌ 依赖安装失败
        pause
        exit /b 1
    )
)

REM 检查 .env 文件
if not exist ".env" (
    echo ⚠️  未找到 .env 文件，正在复制 .env.example...
    copy .env.example .env
    echo ✓ 已创建 .env 文件，请修改数据库配置
)

echo.
echo ✓ 环境检查完成
echo.
echo 启动选项：
echo 1. 开发模式（自动重启）
echo 2. 生产模式
echo.

set /p choice="请选择启动模式 (1 或 2): "

if "%choice%"=="1" (
    echo.
    echo 🚀 启动开发服务器...
    call npm run dev
) else if "%choice%"=="2" (
    echo.
    echo 🚀 启动生产服务器...
    call npm start
) else (
    echo ❌ 无效选择
    pause
    exit /b 1
)
