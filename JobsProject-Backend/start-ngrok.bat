@echo off
echo ========================================
echo   JobsHub 后台 - ngrok 内网穿透启动
echo ========================================
echo.

REM 检查 ngrok 是否安装
where ngrok >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] ngrok 未安装
    echo.
    echo 请按以下步骤安装 ngrok:
    echo 1. 访问 https://ngrok.com/download
    echo 2. 下载 Windows 版本
    echo 3. 解压到任意目录
    echo 4. 将 ngrok.exe 所在目录添加到系统 PATH
    echo.
    echo 或者使用 Chocolatey 安装:
    echo    choco install ngrok
    echo.
    pause
    exit /b 1
)

echo [1/2] 启动 ngrok 隧道...
echo 正在将本地 3000 端口映射到公网...
echo.

REM 启动 ngrok
ngrok http 3000

pause
