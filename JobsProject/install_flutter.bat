@echo off
REM Flutter 环境安装脚本 (Windows)
REM 这个脚本会自动下载和配置 Flutter

setlocal enabledelayedexpansion

echo.
echo ======================================
echo   Flutter 环境安装脚本
echo ======================================
echo.

REM 设置安装目录
set FLUTTER_DIR=C:\flutter
set ANDROID_SDK_DIR=C:\Android\sdk

echo [1/5] 检查系统环境...
echo.

REM 检查 Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git 未安装，请先安装 Git
    echo 下载地址: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo ✅ Git 已安装

REM 检查 Java
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java 未安装，请先安装 Java JDK 8+
    echo 下载地址: https://www.oracle.com/java/technologies/downloads/
    pause
    exit /b 1
)
echo ✅ Java 已安装

echo.
echo [2/5] 创建安装目录...
if not exist "%FLUTTER_DIR%" (
    mkdir "%FLUTTER_DIR%"
    echo ✅ 创建目录: %FLUTTER_DIR%
) else (
    echo ⚠️  目录已存在: %FLUTTER_DIR%
)

if not exist "%ANDROID_SDK_DIR%" (
    mkdir "%ANDROID_SDK_DIR%"
    echo ✅ 创建目录: %ANDROID_SDK_DIR%
) else (
    echo ⚠️  目录已存在: %ANDROID_SDK_DIR%
)

echo.
echo [3/5] 下载 Flutter SDK...
echo.
echo 请手动下载 Flutter SDK:
echo 1. 访问: https://flutter.dev/docs/get-started/install/windows
echo 2. 下载最新的 Flutter SDK (Windows)
echo 3. 解压到: %FLUTTER_DIR%
echo.
echo 或使用以下命令下载 (需要 curl):
echo   curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip -o flutter.zip
echo   tar -xf flutter.zip -C C:\
echo.
pause

echo.
echo [4/5] 配置环境变量...
echo.
echo 请按照以下步骤配置环境变量:
echo.
echo 1. 右键 "此电脑" 或 "我的电脑"
echo 2. 选择 "属性"
echo 3. 点击 "高级系统设置"
echo 4. 点击 "环境变量"
echo 5. 在 "系统变量" 中新建:
echo    变量名: FLUTTER_HOME
echo    变量值: %FLUTTER_DIR%
echo.
echo 6. 编辑 "Path" 变量，添加以下两行:
echo    %FLUTTER_DIR%\bin
echo    %FLUTTER_DIR%\bin\cache\dart-sdk\bin
echo.
echo 7. 点击 "确定" 保存
echo.
pause

echo.
echo [5/5] 验证安装...
echo.
echo 请在新的命令行窗口中运行以下命令:
echo.
echo   flutter --version
echo   flutter doctor
echo.
echo 如果看到版本信息，说明安装成功！
echo.
pause
