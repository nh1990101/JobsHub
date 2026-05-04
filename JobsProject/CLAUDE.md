# JobHub - Flutter 招聘应用项目指南

## 📋 项目概述

**项目名称**: JobHub  
**类型**: 跨平台招聘应用  
**目标平台**: Android (APK/Google Play)、iOS、Web、Windows/macOS/Linux  
**技术栈**: Flutter + Dart  
**状态**: Demo 版本已完成，待后端 API 开发

---

## 🎯 核心功能

### 用户端功能
- ✅ 用户注册/登录（待实现）
- ✅ 职位列表展示（按权重排序）
- ✅ 职位详情页
- ✅ 对话页面（自动回复消息）
- ✅ 个人信息页
- ✅ UI 本地化（多语言支持）

### 后端功能（待开发）
- 用户认证 (JWT)
- 职位管理 (CRUD)
- 国家管理 (CRUD)
- 职位筛选（按国家、年龄、性别）
- 权重排序

### 管理后台（待开发）
- 国家管理
- 职位信息编辑
- 权重配置
- 用户管理

---

## 🎨 设计参考

**参考应用**: LemonJob (Google Play)  
**设计风格**: 卡片式布局，Material Design 3  
**主色调**: RGB(0, 182, 182) / #00B6B6 (青绿色)  
**配色方案**:
- 主色：#00B6B6
- 背景：#FFFFFF
- 文本主色：#333333
- 文本辅助色：#999999
- 分割线：#EEEEEE

**UI 参考图片**:
- `D:\Image\lemonJob\main.jpg` - 主页
- `D:\Image\lemonJob\info.jpg` - 个人信息页
- `D:\Image\lemonJob\click1.jpg` - 职位详情页
- `D:\Image\lemonJob\clickAndOpen.jpg` - 对话页面

---

## 📁 项目结构

```
D:\Project\JobsProject/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── config/
│   │   ├── app_colors.dart         # 颜色配置
│   │   ├── app_strings.dart        # 字符串常量
│   │   └── app_routes.dart         # 路由配置
│   ├── models/
│   │   ├── job.dart                # 职位数据模型
│   │   └── chat_message.dart       # 聊天消息模型
│   ├── services/
│   │   └── api_service.dart        # API 服务 (当前 Mock 数据)
│   ├── providers/
│   │   └── job_provider.dart       # Riverpod 状态管理
│   ├── screens/
│   │   ├── home_screen.dart        # 主页
│   │   ├── job_detail_screen.dart  # 职位详情
│   │   ├── chat_screen.dart        # 对话页面
│   │   └── profile_screen.dart     # 个人信息
│   └── widgets/
│       ├── job_card.dart           # 职位卡片
│       └── chat_bubble.dart        # 聊天气泡
├── pubspec.yaml                     # 项目依赖配置
├── README.md                        # 项目说明
├── QUICKSTART.md                    # 快速开始指南
├── FLUTTER_INSTALL_GUIDE.md         # 详细安装指南
├── run.bat                          # Windows 启动脚本
├── run.sh                           # Git Bash 启动脚本
└── CLAUDE.md                        # 本文件
```

---

## 🛠️ 环境配置

### Flutter 路径
```
D:\solfware\flutter_windows_3.41.9-stable\flutter
```

### 环境变量设置
- `FLUTTER_HOME` = `D:\solfware\flutter_windows_3.41.9-stable\flutter`
- `Path` 添加：
  - `D:\solfware\flutter_windows_3.41.9-stable\flutter\bin`
  - `D:\solfware\flutter_windows_3.41.9-stable\flutter\bin\cache\dart-sdk\bin`

### 验证环境
```bash
flutter --version
flutter doctor
```

---

## 🚀 快速启动

### 方法 1：使用启动脚本（最简单）
```bash
# Windows
D:\Project\JobsProject\run.bat

# 或 Git Bash
cd D:\Project\JobsProject
bash run.sh
```

### 方法 2：手动启动
```bash
cd D:\Project\JobsProject
flutter pub get
flutter run
```

### 方法 3：指定平台运行
```bash
flutter run -d chrome      # Web 浏览器
flutter run -d windows     # Windows 桌面
flutter run -d android     # Android 模拟器/真机
```

---

## 📦 主要依赖

| 包名 | 版本 | 用途 |
|------|------|------|
| flutter_riverpod | 2.4.0 | 状态管理 |
| dio | 5.3.0 | HTTP 网络请求 |
| go_router | 10.0.0 | 路由导航 |
| flutter_screenutil | 5.9.0 | 响应式布局 |
| shared_preferences | 2.2.0 | 本地存储 |
| intl | 0.19.0 | 本地化 |

---

## 📝 数据模型

### Job (职位)
```dart
class Job {
  String id;                  // 职位 ID
  String title;               // 职位标题
  String description;         // 职位描述
  String requirements;        // 职位要求
  String companyName;         // 公司名称
  String companyLogo;         // 公司 logo
  String location;            // 工作地点
  String salary;              // 薪资
  String ageRange;            // 年龄范围 (e.g., "18-65")
  String genderRequirement;   // 性别要求 (all/male/female)
  int weight;                 // 权重 (1-100)
  String countryId;           // 国家 ID
}
```

### ChatMessage (聊天消息)
```dart
class ChatMessage {
  String text;                // 消息内容
  bool isUser;                // 是否为用户消息
  DateTime timestamp;         // 时间戳
}
```

---

## 🔌 API 接口设计（待实现）

### 用户认证
```
POST /api/auth/register
POST /api/auth/login
GET /api/auth/profile
```

### 职位管理
```
GET /api/jobs?country=US&age=25&gender=all&limit=20&offset=0
GET /api/jobs/:id
POST /api/jobs (admin)
PUT /api/jobs/:id (admin)
DELETE /api/jobs/:id (admin)
```

### 国家管理
```
GET /api/countries
POST /api/countries (admin)
PUT /api/countries/:id (admin)
DELETE /api/countries/:id (admin)
```

---

## 🎯 开发计划

### Phase 1: Demo 完成 ✅
- [x] 项目结构搭建
- [x] UI 页面实现
- [x] Mock 数据
- [x] 路由配置
- [x] 状态管理框架

### Phase 2: 后端开发（进行中）
- [ ] 设计 API 接口
- [ ] 搭建后端服务 (Node.js/Express 或 Python/Django)
- [ ] 数据库设计 (PostgreSQL/MySQL)
- [ ] 用户认证 (JWT)
- [ ] 职位 CRUD API
- [ ] 国家管理 API

### Phase 3: 前端集成
- [ ] 集成真实 API
- [ ] 实现用户注册/登录
- [ ] 实现本地化 (intl)
- [ ] 添加收藏功能
- [ ] 用户信息编辑

### Phase 4: 测试和优化
- [ ] 单元测试
- [ ] 集成测试
- [ ] 性能优化
- [ ] UI/UX 测试

### Phase 5: 上架准备
- [ ] 隐私政策和服务条款
- [ ] 应用签名和证书
- [ ] Google Play 配置
- [ ] App Store 配置 (iOS)
- [ ] Web 部署

---

## 💡 开发建议

### 代码风格
- 使用 Dart 命名规范 (camelCase for variables, PascalCase for classes)
- 保持函数简洁，单一职责
- 使用 const 构造函数优化性能
- 避免深层嵌套，使用 extract widget

### 状态管理
- 使用 Riverpod 管理全局状态
- 将 API 调用封装在 Provider 中
- 避免在 Widget 中直接调用 API

### 本地化
- 所有 UI 文本使用 `AppStrings` 常量
- 后续集成 intl 包进行多语言支持
- 职位描述不需要翻译（后台自己翻译）

### 性能优化
- 使用 `const` 构造函数
- 使用 `ListView.builder` 处理长列表
- 避免在 build 方法中进行复杂计算
- 使用 `ScreenUtil` 处理响应式布局

---

## 🐛 常见问题

### Q: 如何修改主色？
A: 编辑 `lib/config/app_colors.dart` 中的 `primary` 颜色值

### Q: 如何添加新页面？
A: 
1. 在 `lib/screens/` 创建新文件
2. 在 `lib/config/app_routes.dart` 添加路由
3. 使用 `context.push('/route-name')` 导航

### Q: 如何添加新的 API 调用？
A:
1. 在 `lib/services/api_service.dart` 添加方法
2. 在 `lib/providers/` 创建对应的 Provider
3. 在 Widget 中使用 `ref.watch(provider)`

### Q: 如何本地化文本？
A:
1. 在 `lib/config/app_strings.dart` 添加字符串常量
2. 在 Widget 中使用 `AppStrings.xxx`
3. 后续集成 intl 包进行多语言支持

---

## 📚 参考资源

- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言文档](https://dart.dev/guides)
- [Riverpod 文档](https://riverpod.dev)
- [Material Design 3](https://m3.material.io/)
- [Go Router 文档](https://pub.dev/packages/go_router)

---

## 👤 项目信息

**创建日期**: 2025-05-03  
**最后更新**: 2025-05-03  
**开发者**: Claude Code  
**状态**: 进行中

---

## 📞 后续支持

如果需要：
- 修改 UI 和功能
- 设计后端 API
- 集成 API
- 构建发布版本
- 解决技术问题

直接告诉我项目名称 "JobHub" 或相关需求，我会自动加载项目信息并继续帮助。
