# JobHub - Flutter Demo

一个跨平台的招聘应用，使用 Flutter 构建，支持 Android、iOS、Web 和桌面平台。

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── config/
│   ├── app_colors.dart         # 颜色配置 (主色: RGB 0,182,182)
│   ├── app_strings.dart        # 字符串常量
│   └── app_routes.dart         # 路由配置
├── models/
│   ├── job.dart                # 职位数据模型
│   └── chat_message.dart       # 聊天消息模型
├── services/
│   └── api_service.dart        # API 服务 (Mock 数据)
├── providers/
│   └── job_provider.dart       # Riverpod 状态管理
├── screens/
│   ├── home_screen.dart        # 主页 - 职位列表
│   ├── job_detail_screen.dart  # 职位详情页
│   ├── chat_screen.dart        # 对话页面
│   └── profile_screen.dart     # 个人信息页
└── widgets/
    ├── job_card.dart           # 职位卡片组件
    └── chat_bubble.dart        # 聊天气泡组件
```

## 功能特性

✅ **主页** - 职位列表（按权重排序）
✅ **职位详情** - 完整的职位信息展示
✅ **对话页面** - 自动回复消息（吸引用户点击 Apply）
✅ **个人信息** - 用户菜单和设置
✅ **响应式布局** - 使用 ScreenUtil 自适应不同屏幕
✅ **状态管理** - Riverpod 管理应用状态
✅ **路由导航** - Go Router 处理页面跳转

## 配色方案

- **主色**：RGB(0, 182, 182) - 青绿色
- **背景**：白色
- **文本**：深灰色
- **辅助文本**：浅灰色

## 快速开始

### 前置条件

- Flutter SDK 3.0+
- Dart 3.0+

### 安装依赖

```bash
cd D:\Project\JobsProject
flutter pub get
```

### 运行应用

**Android**
```bash
flutter run -d android
```

**iOS**
```bash
flutter run -d ios
```

**Web**
```bash
flutter run -d chrome
```

**Windows**
```bash
flutter run -d windows
```

### 构建发布版本

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle (Google Play)**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

**Web**
```bash
flutter build web --release
```

## 当前使用的 Mock 数据

API 服务目前返回 5 个示例职位：
- Software Engineer (Google)
- Product Manager (Meta)
- UI/UX Designer (Apple)
- Data Scientist (Amazon)
- DevOps Engineer (Microsoft)

## 下一步开发计划

1. **后端 API**
   - 搭建 Node.js/Express 或 Python/Django 后端
   - 实现用户认证 (JWT)
   - 实现职位管理 API
   - 实现国家管理 API

2. **前端功能**
   - 实现用户注册/登录
   - 集成真实 API
   - 实现本地化 (intl)
   - 添加收藏功能
   - 实现用户信息编辑

3. **上架准备**
   - 隐私政策和服务条款
   - 应用签名和证书
   - Google Play 和 App Store 配置
   - 性能优化和测试

## 技术栈

- **框架**：Flutter 3.0+
- **语言**：Dart 3.0+
- **状态管理**：Riverpod 2.4.0
- **网络请求**：Dio 5.3.0
- **路由**：Go Router 10.0.0
- **本地存储**：Shared Preferences
- **响应式布局**：Flutter ScreenUtil 5.9.0

## 文件说明

### 配置文件
- `pubspec.yaml` - 项目依赖配置
- `lib/config/app_colors.dart` - 应用颜色常量
- `lib/config/app_strings.dart` - 应用字符串常量
- `lib/config/app_routes.dart` - 路由配置

### 数据模型
- `lib/models/job.dart` - 职位模型
- `lib/models/chat_message.dart` - 聊天消息模型

### 服务层
- `lib/services/api_service.dart` - API 服务（目前使用 Mock 数据）

### 状态管理
- `lib/providers/job_provider.dart` - 职位数据提供者

### UI 层
- `lib/screens/` - 页面组件
- `lib/widgets/` - 可复用的 UI 组件

## 注意事项

1. 当前 API 服务使用 Mock 数据，需要连接真实后端
2. 本地化功能需要在 pubspec.yaml 中配置 intl 支持
3. 图片资源需要放在 `assets/images/` 目录
4. 字体文件需要放在 `assets/fonts/` 目录

## 许可证

MIT License
