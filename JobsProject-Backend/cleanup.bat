@echo off
REM 杀死所有 Node 进程
echo 正在清理 Node 进程...
powershell -Command "Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force"
echo ✓ 清理完成
timeout /t 2
