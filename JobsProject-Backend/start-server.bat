@echo off
chcp 65001 >nul
cd /d "D:\Project\JobsProject-Backend"
echo.
echo 🚀 启动 JobHub 后端服务...
echo.
pm2 start ecosystem.config.js
echo.
echo ✅ 服务器已启动！
echo 📍 访问地址: http://localhost:3000
echo 📋 查看日志: pm2 logs jobshub
echo.
pause
