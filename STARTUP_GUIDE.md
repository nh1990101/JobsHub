# JobHub 项目启动指南

## 🚀 快速启动（推荐）

### 1. 启动后端服务器
```bash
cd D:\Project\JobsHub\JobsProject-Backend
npm start
```

**预期输出：**
```
✓ 服务地址: http://localhost:3000
✓ 健康检查: http://localhost:3000/api/health
✅ 数据库: MySQL (jobshub)
```

### 2. 启动Flutter前端
```bash
cd D:\Project\JobsHub\JobsProject
flutter run -d chrome
```

**预期结果：**
- Chrome浏览器自动打开
- 显示JobHub应用界面
- 职位列表正常加载

### 3. （可选）映射到外网
```bash
cd D:\Project\JobsHub
./cloudflared.exe tunnel --url http://localhost:3000
```

**预期输出：**
```
Your quick Tunnel has been created! Visit it at:
https://xxxxx.trycloudflare.com
```

## 📋 启动前检查清单

### 必需服务
- [ ] MySQL服务正在运行
- [ ] 数据库`jobshub`已创建
- [ ] Node.js已安装 (v20+)
- [ ] Flutter已安装 (3.41.9)

### 验证命令
```bash
# 检查MySQL
mysql -u root -p -e "SHOW DATABASES LIKE 'jobshub';"

# 检查Node.js
node --version

# 检查Flutter
flutter --version
```

## 🔧 详细启动步骤

### 步骤1：启动MySQL数据库
```bash
# Windows服务方式
net start MySQL80

# 或通过MySQL Workbench启动
```

### 步骤2：启动后端API服务器

#### 方式A：直接启动（推荐）
```bash
cd D:\Project\JobsHub\JobsProject-Backend
npm start
```

#### 方式B：开发模式（支持热重载）
```bash
cd D:\Project\JobsHub\JobsProject-Backend
npm run dev
```

#### 验证后端启动成功
```bash
# 测试健康检查
curl http://localhost:3000/api/health

# 预期返回
{"status":"ok","message":"JobHub API is running"}
```

### 步骤3：启动Flutter前端

#### 方式A：Chrome浏览器（推荐）
```bash
cd D:\Project\JobsHub\JobsProject
flutter run -d chrome
```

#### 方式B：Windows桌面应用
```bash
cd D:\Project\JobsHub\JobsProject
flutter run -d windows
```

#### 方式C：Android设备/模拟器
```bash
cd D:\Project\JobsHub\JobsProject
flutter run -d android
```

### 步骤4：（可选）外网映射

#### 启动Cloudflare隧道
```bash
cd D:\Project\JobsHub
./cloudflared.exe tunnel --url http://localhost:3000
```

#### 更新前端配置
1. 复制隧道URL（如：`https://xxxxx.trycloudflare.com`）
2. 编辑 `JobsProject/lib/config/api_config.dart`
3. 更新 `productionBaseUrl` 为新的隧道URL
4. 重新构建Web版本：
```bash
cd D:\Project\JobsHub\JobsProject
flutter build web --release
```

## 🛑 停止服务

### 停止后端
- 在后端终端按 `Ctrl+C`
- 或关闭终端窗口

### 停止Flutter
- 在Flutter终端按 `q` 键
- 或按 `Ctrl+C`

### 停止Cloudflare隧道
- 在隧道终端按 `Ctrl+C`

### 停止所有Node进程（强制）
```bash
taskkill //F //IM node.exe
```

## ⚠️ 常见启动问题

### 问题1：后端启动失败 - 端口被占用
**错误信息：** `Error: listen EADDRINUSE: address already in use :::3000`

**解决方案：**
```bash
# 查找占用3000端口的进程
netstat -ano | findstr :3000

# 结束进程（替换PID为实际进程ID）
taskkill /F /PID <PID>
```

### 问题2：数据库连接失败
**错误信息：** `Error: connect ECONNREFUSED 127.0.0.1:3306`

**解决方案：**
1. 检查MySQL服务是否运行
2. 验证`.env`文件中的数据库配置
3. 确认数据库`jobshub`已创建

### 问题3：Flutter编译失败
**错误信息：** `Flutter SDK not found`

**解决方案：**
```bash
# 验证Flutter路径
echo %FLUTTER_HOME%

# 应该输出：D:\solfware\flutter_windows_3.41.9-stable\flutter

# 运行Flutter doctor
flutter doctor
```

### 问题4：CORS错误
**错误信息：** `Access to XMLHttpRequest has been blocked by CORS policy`

**解决方案：**
1. 确认后端已启动
2. 检查后端CORS配置（已修复，应该不会出现）
3. 清除浏览器缓存并刷新

### 问题5：Chrome没有自动打开
**解决方案：**
- 查找新打开的Chrome窗口/标签页
- 或手动打开Chrome，查看是否有Flutter应用标签
- 检查终端输出的调试URL

## 📊 启动状态检查

### 检查后端状态
```bash
# 健康检查
curl http://localhost:3000/api/health

# 获取职位列表
curl http://localhost:3000/api/jobs?limit=5

# 获取国家列表
curl http://localhost:3000/api/countries
```

### 检查前端状态
- 打开Chrome开发者工具 (F12)
- 查看Console标签，应该看到：
```
╔════════════════════════════════════════╗
║          API 配置信息                    ║
╚════════════════════════════════════════╝
🌍 当前环境: auto
🔗 API 地址: http://localhost:3000/api
✅ API响应状态码: 200
```

### 检查数据库状态
```bash
mysql -u root -p

# 在MySQL命令行中
USE jobshub;
SHOW TABLES;
SELECT COUNT(*) FROM jobs;
SELECT COUNT(*) FROM users;
```

## 🔄 重启服务

### 完全重启（推荐）
```bash
# 1. 停止所有服务
taskkill //F //IM node.exe
# 在Flutter终端按 q

# 2. 等待2秒

# 3. 重新启动后端
cd D:\Project\JobsHub\JobsProject-Backend
npm start

# 4. 重新启动前端
cd D:\Project\JobsHub\JobsProject
flutter run -d chrome
```

### 热重载（仅前端代码修改）
- 在Flutter终端按 `r` 键（热重载）
- 或按 `R` 键（热重启）

## 🌐 访问地址

### 本地开发
- **前端**：Chrome自动打开（无固定URL）
- **后端API**：http://localhost:3000/api
- **健康检查**：http://localhost:3000/api/health
- **后台管理**：http://localhost:3000/admin.html

### 外网访问（需启动隧道）
- **完整应用**：https://xxxxx.trycloudflare.com
- **API**：https://xxxxx.trycloudflare.com/api
- **健康检查**：https://xxxxx.trycloudflare.com/api/health

## 📝 启动日志示例

### 正常启动的后端日志
```
🚀🚀🚀 SERVER.JS STARTING 🚀🚀🚀
✅ 迁移1: company_logo 字段已更新
✅ 数据库迁移完成

╔════════════════════════════════════════╗
║   JobHub API 服务启动成功（MySQL 模式）  ║
╚════════════════════════════════════════╝

✓ 服务地址: http://localhost:3000
✓ 健康检查: http://localhost:3000/api/health

📚 API 端点:
  - POST   /api/auth/register      (用户注册)
  - POST   /api/auth/login         (用户登录)
  - GET    /api/jobs               (获取职位列表)
  - GET    /api/jobs/:id           (获取职位详情)

✅ 数据库: MySQL (jobshub)
✅ 数据持久化: 已启用
```

### 正常启动的前端日志
```
Launching lib\main.dart on Chrome in debug mode...
Waiting for connection from debug service on Chrome...

Flutter run key commands.
r Hot reload. 
R Hot restart.

Debug service listening on ws://127.0.0.1:xxxxx/ws

╔════════════════════════════════════════╗
║          API 配置信息                    ║
╚════════════════════════════════════════╝
🌍 当前环境: auto
🔗 API 地址: http://localhost:3000/api
📡 API请求: GET /jobs
✅ API响应状态码: 200
✅ 获取职位数: 5
```

## 🎯 下次启动提示

**最简单的启动方式：**
1. 打开两个终端窗口
2. 终端1：`cd D:\Project\JobsHub\JobsProject-Backend && npm start`
3. 终端2：`cd D:\Project\JobsHub\JobsProject && flutter run -d chrome`
4. 等待Chrome自动打开

**记住：**
- 先启动后端，再启动前端
- 确保MySQL服务正在运行
- 如果遇到CORS错误，重启后端服务
- Chrome会自动打开，不要手动输入URL
