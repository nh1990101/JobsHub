@echo off
chcp 65001 >nul
echo.
echo 🛑 停止 JobHub 后端服务...
echo.
pm2 stop jobshub
echo.
echo ✅ 服务器已停止！
echo.
pause
