# JobHub - 跨平台招聘应用

一个基于Flutter和Node.js构建的现代化招聘平台，支持Web、Android、iOS和桌面平台。

## 📚 文档导航

### 🚀 快速开始
- **[快速参考卡](QUICK_REFERENCE.md)** ⭐ 最常用命令和配置速查
- **[启动指南](STARTUP_GUIDE.md)** - 详细的项目启动步骤
- **[项目结构](PROJECT_STRUCTURE.md)** - 完整的项目架构说明

### 🛠️ 开发文档
- **[开发指南](DEVELOPMENT_GUIDE.md)** - 修改需求和开发规范
- **[API配置说明](API_CONFIG_GUIDE.md)** - API环境配置详解
- **[APK构建指南](APK_BUILD_GUIDE.md)** - Android应用打包

### 📖 其他文档
- **[部署指南](DEPLOYMENT_GUIDE.md)** - 生产环境部署
- **[隐私政策](PRIVACY_POLICY.md)** - 用户隐私说明

## ⚡ 快速启动

### 前提条件
- MySQL 8.0+ 正在运行
- Node.js 20+ 已安装
- Flutter 3.41.9 已安装

### 启动命令

```bash
# 1. 启动后端（终端1）
cd D:\Project\JobsHub\JobsProject-Backend
npm start

# 2. 启动前端（终端2）
cd D:\Project\JobsHub\JobsProject
flutter run -d chrome

# 3. （可选）外网映射
cd D:\Project\JobsHub
./cloudflared.exe tunnel --url http://localhost:3000
```

## 🎯 核心功能

### 用户端
- ✅ 职位浏览和搜索
- ✅ 职位详情查看
- ✅ WhatsApp一键联系
- ✅ 多语言支持（中英文）
- ✅ 响应式设计

### 管理端
- ✅ 职位管理（增删改查）
- ✅ 用户管理
- ✅ 国家管理
- ✅ 权重排序

## 🏗️ 技术栈

### 前端
- **Flutter 3.41.9** - 跨平台UI框架
- **Riverpod 2.4.0** - 状态管理
- **Dio 5.3.0** - HTTP客户端
- **Go Router 10.0.0** - 路由管理

### 后端
- **Node.js 20** - 运行时环境
- **Express 5.2.1** - Web框架
- **MySQL 8.0** - 数据库
- **JWT** - 身份认证

## 📊 项目状态

- **开发状态**：✅ 活跃开发中
- **版本**：v1.0.0
- **最后更新**：2026-05-06

## 🌐 访问地址

### 本地开发
- 前端：Chrome自动打开
- 后端API：http://localhost:3000/api
- 健康检查：http://localhost:3000/api/health

### 外网访问（需启动隧道）
- 完整应用：https://xxxxx.trycloudflare.com
- API：https://xxxxx.trycloudflare.com/api

## 🔧 环境配置

### 数据库配置
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=jobshub
```

### API配置
- 本地开发：`http://localhost:3000/api`
- 外网访问：自动检测环境

## 📝 测试账户

- **邮箱**：test@example.com
- **密码**：test123

## 🐛 常见问题

### 后端启动失败
```bash
# 检查端口占用
netstat -ano | findstr :3000

# 停止Node进程
taskkill //F //IM node.exe
```

### CORS错误
重启后端服务即可解决

### 数据库连接失败
```bash
# 启动MySQL服务
net start MySQL80
```

详细问题排查请查看 [启动指南](STARTUP_GUIDE.md)

## 📞 获取帮助

### 下次对话开场白
```
"启动JobHub项目"
或
"我要修改JobHub的[具体功能]"
```

Claude会自动：
1. 检查项目状态
2. 启动必要的服务
3. 定位相关代码
4. 提供修改建议

## 📂 项目结构

```
JobsHub/
├── JobsProject/              # Flutter前端
│   ├── lib/                  # 源代码
│   ├── android/              # Android配置
│   └── build/web/            # Web构建产物
├── JobsProject-Backend/      # Node.js后端
│   ├── src/server.js         # 主服务器文件
│   └── .env                  # 环境配置
├── cloudflared.exe           # 外网映射工具
└── 文档/                     # 项目文档
```

详细结构请查看 [项目结构](PROJECT_STRUCTURE.md)

## 🚀 构建发布

### Web版本
```bash
cd JobsProject
flutter build web --release
```

### Android APK
```bash
cd JobsProject
flutter build apk --release
```

详细步骤请查看 [APK构建指南](APK_BUILD_GUIDE.md)

## 📄 许可证

本项目仅供学习和开发使用。

## 🙏 致谢

- Flutter团队
- Express.js社区
- MySQL开发团队
- Cloudflare

---

**快速链接：**
- [快速参考卡](QUICK_REFERENCE.md) - 最常用的命令和配置
- [启动指南](STARTUP_GUIDE.md) - 如何启动项目
- [开发指南](DEVELOPMENT_GUIDE.md) - 如何修改代码

**最后更新：** 2026-05-06  
**维护者：** Claude Code
