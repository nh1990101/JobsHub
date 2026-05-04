@echo off
REM Flutter 项目快速启动脚本 (Windows)
REM 使用方法: 双击运行或在命令行中执行

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   JobHub - Flutter 项目启动脚本
echo ========================================
echo.

REM 检查 Flutter
echo [1/5] 检查 Flutter 环境...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ Flutter 未安装
    echo.
    echo 请按照以下步骤安装 Flutter:
    echo 1. 访问: https://flutter.dev/docs/get-started/install/windows
    echo 2. 下载 Flutter SDK 并解压到 C:\flutter
    echo 3. 配置环境变量 (FLUTTER_HOME 和 Path)
    echo 4. 重启电脑或命令行窗口
    echo.
    echo 或查看详细指南: FLUTTER_INSTALL_GUIDE.md
    echo.
    pause
    exit /b 1
)
echo ✅ Flutter 已安装
flutter --version

REM 检查 Dart
echo.
echo [2/5] 检查 Dart 环境...
dart --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Dart 未安装
    pause
    exit /b 1
)
echo ✅ Dart 已安装

REM 进入项目目录
echo.
echo [3/5] 进入项目目录...
cd /d "%~dp0"
echo ✅ 当前目录: %cd%

REM 获取依赖
echo.
echo [4/5] 获取项目依赖...
echo 这可能需要几分钟，请耐心等待...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ 获取依赖失败
    pause
    exit /b 1
)
echo ✅ 依赖获取完成

REM 列出可用设备
echo.
echo [5/5] 检查可用设备...
flutter devices
echo.

REM 提示用户选择运行方式
echo ========================================
echo   准备就绪！选择运行方式:
echo ========================================
echo.
echo 1. flutter run              (自动选择设备)
echo 2. flutter run -d chrome    (Web 浏览器)
echo 3. flutter run -d windows   (Windows 桌面)
echo 4. flutter run -d android   (Android 模拟器/真机)
echo 5. 退出
echo.

set /p choice="选择 (默认 1): "
if "%choice%"=="" set choice=1

if "%choice%"=="1" (
    flutter run
) else if "%choice%"=="2" (
    flutter run -d chrome
) else if "%choice%"=="3" (
    flutter run -d windows
) else if "%choice%"=="4" (
    flutter run -d android
) else if "%choice%"=="5" (
    exit /b 0
) else (
    echo 无效选择
    pause
    exit /b 1
)

pause
