# JobHub 项目结构说明

## 📁 项目目录结构

```
D:\Project\JobsHub/
├── JobsProject/                    # Flutter 前端项目
│   ├── lib/
│   │   ├── main.dart              # 应用入口
│   │   ├── config/
│   │   │   ├── api_config.dart    # API配置（环境自动检测）
│   │   │   ├── app_colors.dart    # 颜色配置
│   │   │   ├── app_strings.dart   # 字符串常量
│   │   │   └── app_routes.dart    # 路由配置
│   │   ├── models/
│   │   │   ├── job.dart           # 职位数据模型
│   │   │   └── chat_message.dart  # 聊天消息模型
│   │   ├── services/
│   │   │   └── api_service.dart   # API服务（Dio网络请求）
│   │   ├── providers/
│   │   │   ├── job_provider.dart  # 职位状态管理
│   │   │   └── language_provider.dart # 语言状态管理
│   │   ├── screens/
│   │   │   ├── home_screen.dart   # 主页（职位列表）
│   │   │   ├── job_detail_screen.dart # 职位详情
│   │   │   ├── chat_screen.dart   # 对话页面
│   │   │   ├── profile_screen.dart # 个人信息
│   │   │   ├── admin_screen.dart  # 后台管理
│   │   │   ├── resume_screen.dart # 简历页面
│   │   │   ├── privacy_screen.dart # 隐私政策
│   │   │   └── language_screen.dart # 语言选择
│   │   └── widgets/
│   │       ├── job_card.dart      # 职位卡片组件
│   │       └── chat_bubble.dart   # 聊天气泡组件
│   ├── android/                   # Android平台配置
│   ├── build/                     # 构建输出目录
│   │   └── web/                   # Web构建产物
│   ├── pubspec.yaml               # Flutter依赖配置
│   └── CLAUDE.md                  # Flutter项目说明文档
│
├── JobsProject-Backend/           # Node.js 后端项目
│   ├── src/
│   │   └── server.js              # Express服务器主文件
│   ├── .env                       # 环境变量配置
│   ├── package.json               # Node.js依赖配置
│   └── admin.html                 # 后台管理页面
│
├── cloudflared.exe                # Cloudflare隧道工具（外网映射）
│
└── 文档/
    ├── PROJECT_STRUCTURE.md       # 本文件
    ├── STARTUP_GUIDE.md           # 启动指南
    ├── DEVELOPMENT_GUIDE.md       # 开发指南
    ├── API_CONFIG_GUIDE.md        # API配置说明
    ├── APK_BUILD_GUIDE.md         # APK构建指南
    └── DEPLOYMENT_GUIDE.md        # 部署指南
```

## 🎯 核心功能模块

### 前端 (Flutter)
- **职位展示**：首页职位列表，按权重排序
- **职位详情**：查看完整职位信息，支持WhatsApp联系
- **对话功能**：与雇主聊天（当前为模拟数据）
- **个人信息**：用户资料管理
- **多语言**：支持中英文切换
- **响应式**：支持Web、Android、iOS、桌面平台

### 后端 (Node.js + Express)
- **用户认证**：JWT token认证
- **职位管理**：CRUD操作，支持筛选和排序
- **国家管理**：国家列表和地理位置检测
- **数据库**：MySQL持久化存储
- **CORS**：支持跨域访问（本地开发+外网映射）
- **静态文件**：提供Flutter Web构建产物

## 🔧 技术栈

### 前端
- **框架**：Flutter 3.41.9
- **状态管理**：Riverpod 2.4.0
- **网络请求**：Dio 5.3.0
- **路由**：Go Router 10.0.0
- **本地存储**：Shared Preferences 2.2.0
- **响应式布局**：Flutter ScreenUtil 5.9.0

### 后端
- **运行时**：Node.js v20.10.0
- **框架**：Express 5.2.1
- **数据库**：MySQL 8.0 (通过mysql2)
- **认证**：JWT (jsonwebtoken 9.0.3)
- **密码加密**：bcryptjs 3.0.3
- **环境变量**：dotenv 17.4.2

### 数据库
- **类型**：MySQL
- **数据库名**：jobshub
- **主要表**：
  - `users` - 管理员用户
  - `app_users` - 应用用户
  - `jobs` - 职位信息
  - `countries` - 国家列表

## 🌐 环境配置

### API环境自动检测
前端会根据访问方式自动选择API地址：
- **localhost访问** → 连接本地API (`http://localhost:3000/api`)
- **外网域名访问** → 使用相对路径 (`/api`)

### 当前配置
- **本地开发API**：`http://localhost:3000/api`
- **外网API**：`https://pubs-closure-near-ranch.trycloudflare.com/api`
- **数据库**：`localhost:3306/jobshub`

## 📦 依赖关系

```
用户浏览器
    ↓
Flutter Web应用 (Chrome)
    ↓ (HTTP请求)
Express后端服务器 (localhost:3000)
    ↓ (SQL查询)
MySQL数据库 (localhost:3306)
```

### 外网访问流程
```
外网用户
    ↓ (HTTPS)
Cloudflare隧道 (trycloudflare.com)
    ↓ (转发到本地)
Express后端 (localhost:3000)
    ↓ (提供静态文件)
Flutter Web应用 (build/web/)
    ↓ (API请求)
Express后端 (同一服务器，相对路径)
    ↓
MySQL数据库
```

## 🔑 关键配置文件

### 前端配置
- **`lib/config/api_config.dart`**：API地址配置，环境检测逻辑
- **`pubspec.yaml`**：Flutter依赖和资源配置
- **`android/app/build.gradle.kts`**：Android构建配置

### 后端配置
- **`.env`**：数据库连接、JWT密钥等敏感配置
- **`package.json`**：Node.js依赖和启动脚本
- **`src/server.js`**：服务器配置、路由、CORS设置

## 🚀 端口使用

| 服务 | 端口 | 说明 |
|------|------|------|
| 后端API | 3000 | Express服务器 |
| MySQL | 3306 | 数据库服务 |
| Flutter开发 | 随机 | Chrome调试端口 |
| Cloudflare隧道 | - | 外网HTTPS访问 |

## 📝 重要说明

1. **CORS配置**：后端已配置支持所有localhost端口和外网域名
2. **环境检测**：前端会自动检测运行环境，无需手动切换
3. **Mock数据**：如果API连接失败，前端会自动使用Mock数据
4. **外网映射**：使用cloudflared.exe创建临时隧道，每次启动URL会变化
5. **数据库**：需要MySQL服务运行，数据库名为jobshub
6. **构建产物**：Web构建产物在`JobsProject/build/web/`，由后端提供静态文件服务

## 🔄 数据流向

### 职位列表加载
1. 用户打开应用
2. Flutter调用`ApiService.getJobs()`
3. 发送GET请求到`/api/jobs`
4. 后端查询MySQL数据库
5. 返回JSON数据
6. Flutter解析为Job对象
7. 按权重排序显示

### 用户注册/登录
1. 用户输入邮箱密码
2. Flutter调用`ApiService.login()`
3. 发送POST请求到`/api/auth/login`
4. 后端验证密码（bcrypt）
5. 生成JWT token
6. 返回token和用户信息
7. Flutter保存token到SharedPreferences

## 🎨 UI设计参考

- **主色调**：#00B6B6 (青绿色)
- **设计风格**：Material Design 3
- **参考应用**：LemonJob
- **布局方式**：卡片式布局
