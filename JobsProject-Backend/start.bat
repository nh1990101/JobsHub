@echo off
cd /d "D:\Project\JobsProject-Backend"
pm2 start ecosystem.config.js
pm2 logs jobshub
