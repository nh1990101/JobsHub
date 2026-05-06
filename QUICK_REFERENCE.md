# JobHub 项目快速参考卡

## 🚀 一键启动命令

### 启动后端
```bash
cd D:\Project\JobsHub\JobsProject-Backend && npm start
```

### 启动前端
```bash
cd D:\Project\JobsHub\JobsProject && flutter run -d chrome
```

### 启动外网映射
```bash
cd D:\Project\JobsHub && ./cloudflared.exe tunnel --url http://localhost:3000
```

## 📁 关键文件速查

| 功能 | 文件路径 |
|------|---------|
| API配置 | `JobsProject/lib/config/api_config.dart` |
| 后端主文件 | `JobsProject-Backend/src/server.js` |
| 数据库配置 | `JobsProject-Backend/.env` |
| 颜色配置 | `JobsProject/lib/config/app_colors.dart` |
| 路由配置 | `JobsProject/lib/config/app_routes.dart` |
| API服务 | `JobsProject/lib/services/api_service.dart` |

## 🔧 常用命令

### Flutter
```bash
flutter pub get          # 安装依赖
flutter run -d chrome    # 运行Web版
flutter run -d windows   # 运行桌面版
flutter build web        # 构建Web版
flutter build apk        # 构建Android APK
r                        # 热重载（在运行时按）
R                        # 热重启（在运行时按）
q                        # 退出（在运行时按）
```

### 后端
```bash
npm start                # 启动服务器
npm run dev              # 开发模式（热重载）
npm install              # 安装依赖
```

### 数据库
```bash
mysql -u root -p         # 登录MySQL
USE jobshub;             # 切换数据库
SHOW TABLES;             # 查看表
SELECT * FROM jobs;      # 查询职位
```

### 测试API
```bash
# 健康检查
curl http://localhost:3000/api/health

# 获取职位列表
curl http://localhost:3000/api/jobs

# 登录
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

## 🌐 访问地址

| 服务 | 本地地址 | 外网地址 |
|------|---------|---------|
| 前端应用 | Chrome自动打开 | https://xxxxx.trycloudflare.com |
| 后端API | http://localhost:3000/api | https://xxxxx.trycloudflare.com/api |
| 健康检查 | http://localhost:3000/api/health | https://xxxxx.trycloudflare.com/api/health |
| 后台管理 | http://localhost:3000/admin.html | https://xxxxx.trycloudflare.com/admin.html |

## 🐛 快速排错

### 后端启动失败
```bash
# 检查端口占用
netstat -ano | findstr :3000

# 停止所有Node进程
taskkill //F //IM node.exe
```

### 数据库连接失败
```bash
# 检查MySQL服务
net start MySQL80

# 验证数据库存在
mysql -u root -p -e "SHOW DATABASES LIKE 'jobshub';"
```

### CORS错误
```bash
# 重启后端服务
cd D:\Project\JobsHub\JobsProject-Backend
npm start
```

### Flutter编译失败
```bash
# 清理缓存
flutter clean
flutter pub get

# 检查Flutter
flutter doctor
```

## 📊 项目状态检查

### 检查后端
```bash
curl http://localhost:3000/api/health
# 预期: {"status":"ok","message":"JobHub API is running"}
```

### 检查数据库
```bash
mysql -u root -p -e "USE jobshub; SELECT COUNT(*) FROM jobs;"
```

### 检查前端
- 打开Chrome开发者工具 (F12)
- 查看Console，应该看到：`✅ API响应状态码: 200`

## 🔑 重要配置

### 数据库配置 (.env)
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=5229933aa
DB_NAME=jobshub
```

### API环境配置
- **本地开发**：`http://localhost:3000/api`
- **外网访问**：自动检测，使用相对路径 `/api`

### 端口使用
- 后端：3000
- MySQL：3306
- Flutter：随机（Chrome调试端口）

## 📝 测试账户

### 管理员账户
- 邮箱：`test@example.com`
- 密码：`test123`

## 🔄 完全重启流程

```bash
# 1. 停止所有服务
taskkill //F //IM node.exe
# 在Flutter终端按 q

# 2. 启动后端
cd D:\Project\JobsHub\JobsProject-Backend && npm start

# 3. 启动前端
cd D:\Project\JobsHub\JobsProject && flutter run -d chrome
```

## 📚 文档索引

- `PROJECT_STRUCTURE.md` - 项目结构详解
- `STARTUP_GUIDE.md` - 详细启动指南
- `DEVELOPMENT_GUIDE.md` - 开发修改指南
- `API_CONFIG_GUIDE.md` - API配置说明
- `APK_BUILD_GUIDE.md` - Android构建指南
- `DEPLOYMENT_GUIDE.md` - 部署指南

## 💡 下次对话开场白

**推荐说法：**
```
"启动JobHub项目"
或
"我要修改JobHub的[具体功能]"
```

**Claude会自动：**
1. 检查项目状态
2. 启动必要的服务
3. 定位相关代码
4. 提供修改建议

## ⚠️ 重要提醒

1. **先启动后端，再启动前端**
2. **确保MySQL服务运行**
3. **CORS问题 = 重启后端**
4. **Chrome会自动打开，不要手动输入URL**
5. **外网URL每次启动都会变化**
6. **修改.env后必须重启后端**
7. **修改Dart代码后按 r 热重载**

## 🎯 常见需求快速定位

| 需求 | 文件 | 行数参考 |
|------|------|---------|
| 修改主色调 | `lib/config/app_colors.dart` | 第5行 |
| 修改API地址 | `lib/config/api_config.dart` | 第10-13行 |
| 修改数据库密码 | `.env` | 第9行 |
| 添加API路由 | `src/server.js` | 路由部分 |
| 修改CORS | `src/server.js` | 第74-114行 |

## 🔍 日志关键词

### 成功标志
- ✅ `API响应状态码: 200`
- ✅ `数据库: MySQL (jobshub)`
- ✅ `服务地址: http://localhost:3000`

### 错误标志
- ❌ `CORS policy`
- ❌ `ECONNREFUSED`
- ❌ `EADDRINUSE`
- ❌ `connection error`

## 📞 紧急救援

### 一切都不工作了
```bash
# 完全重置
taskkill //F //IM node.exe
taskkill //F //IM chrome.exe
net stop MySQL80
net start MySQL80

# 等待10秒

# 重新启动
cd D:\Project\JobsHub\JobsProject-Backend && npm start
# 等待后端启动完成
cd D:\Project\JobsHub\JobsProject && flutter run -d chrome
```

### 数据库损坏
```bash
# 备份数据
mysqldump -u root -p jobshub > backup.sql

# 重新创建数据库
mysql -u root -p -e "DROP DATABASE jobshub; CREATE DATABASE jobshub;"

# 恢复数据
mysql -u root -p jobshub < backup.sql
```

---

**保存此文件为书签，随时查阅！**
