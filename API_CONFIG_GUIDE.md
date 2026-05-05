# API 配置指南

## 📋 概述

本项目已将所有 API 相关配置集中到 `lib/config/api_config.dart` 文件中，方便统一管理和切换环境。

---

## 🎯 配置文件位置

```
JobsProject/lib/config/api_config.dart
```

---

## 🔧 配置说明

### 环境切换

在 `api_config.dart` 中修改 `environment` 常量：

```dart
// 开发环境（使用本地 API）
static const String environment = 'development';

// 生产环境（使用 ngrok 公网 API）
static const String environment = 'production';
```

### API 地址配置

```dart
// 开发环境地址
static const String developmentBaseUrl = 'http://127.0.0.1:3000/api';

// 生产环境地址（ngrok）
static const String productionBaseUrl = 'https://uninstall-escalate-bakeshop.ngrok-free.dev/api';
```

### 超时配置

```dart
// 连接超时（秒）
static const int connectTimeout = 10;

// 接收超时（秒）
static const int receiveTimeout = 10;
```

---

## 📍 API 路由列表

所有 API 路由都已在配置文件中定义：

### 认证相关
- `ApiConfig.authLogin` → `/auth/login`
- `ApiConfig.authRegister` → `/auth/register`
- `ApiConfig.authProfile` → `/auth/profile`
- `ApiConfig.authRegisterAdmin` → `/auth/register-admin`

### 职位相关
- `ApiConfig.jobs` → `/jobs`
- `ApiConfig.jobDetail(id)` → `/jobs/:id`

### 国家相关
- `ApiConfig.countries` → `/countries`
- `ApiConfig.countryDetail(id)` → `/countries/:id`

### 应用用户相关
- `ApiConfig.appUsersRegister` → `/app-users/register`
- `ApiConfig.appUsersList` → `/app-users-list`
- `ApiConfig.appUserByDeviceId(deviceId)` → `/app-users/:deviceId`

### 其他
- `ApiConfig.geoCountryByIp` → `/geo/country-by-ip`
- `ApiConfig.health` → `/health`

---

## 🚀 使用方法

### 在代码中使用

```dart
import '../config/api_config.dart';

// 获取当前 API 基础地址
String baseUrl = ApiConfig.baseUrl;

// 使用路由常量
final response = await dio.get(ApiConfig.jobs);

// 使用动态路由
final response = await dio.get(ApiConfig.jobDetail('123'));

// 获取完整 URL
String fullUrl = ApiConfig.getFullUrl(ApiConfig.jobs);
```

### 查看当前配置

```dart
// 打印当前配置信息
ApiConfig.printConfig();
```

输出示例：
```
╔════════════════════════════════════════╗
║          API 配置信息                    ║
╚════════════════════════════════════════╝
🌍 当前环境: production
🔗 API 地址: https://uninstall-escalate-bakeshop.ngrok-free.dev/api
⏱️  连接超时: 10s
⏱️  接收超时: 10s
════════════════════════════════════════
```

---

## 🔄 更新 ngrok 地址

当 ngrok 重启后，URL 会变化，需要更新配置：

### 步骤 1：获取新的 ngrok 地址

```bash
curl http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*"'
```

### 步骤 2：更新配置文件

编辑 `lib/config/api_config.dart`：

```dart
static const String productionBaseUrl = 'https://your-new-ngrok-url.ngrok-free.dev/api';
```

### 步骤 3：重启应用

```bash
# 停止应用（按 Ctrl+C）
# 重新运行
flutter run
```

---

## 📝 最佳实践

### 1. 开发时使用本地环境

```dart
static const String environment = 'development';
```

优点：
- 响应速度快
- 不受网络影响
- 方便调试

### 2. 测试时使用生产环境

```dart
static const String environment = 'production';
```

优点：
- 模拟真实环境
- 测试外网访问
- 验证 CORS 配置

### 3. 添加新的 API 路由

在 `api_config.dart` 中添加：

```dart
// 静态路由
static const String newRoute = '/new-route';

// 动态路由
static String newRouteWithId(String id) => '/new-route/$id';
```

在 `api_service.dart` 中使用：

```dart
final response = await _dio.get(ApiConfig.newRoute);
```

### 4. 不要硬编码 URL

❌ 错误做法：
```dart
final response = await _dio.get('/jobs');
```

✅ 正确做法：
```dart
final response = await _dio.get(ApiConfig.jobs);
```

---

## 🐛 常见问题

### Q1: 修改配置后不生效？

**A**: 需要重启应用（热重载不会重新加载常量）

```bash
# 停止应用
Ctrl + C

# 重新运行
flutter run
```

### Q2: ngrok 地址变化后如何快速更新？

**A**: 使用以下命令获取新地址并更新：

```bash
# 1. 获取新地址
curl http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep public_url

# 2. 复制新地址

# 3. 编辑配置文件
# lib/config/api_config.dart

# 4. 重启应用
```

### Q3: 如何添加多个环境（如测试环境）？

**A**: 在 `api_config.dart` 中添加：

```dart
static const String stagingBaseUrl = 'https://staging-api.example.com/api';

static String get baseUrl {
  switch (environment) {
    case 'production':
      return productionBaseUrl;
    case 'staging':
      return stagingBaseUrl;
    case 'development':
    default:
      return developmentBaseUrl;
  }
}
```

### Q4: 如何在运行时切换环境？

**A**: 当前配置使用编译时常量，无法在运行时切换。如需运行时切换，可以：

1. 使用环境变量
2. 使用 SharedPreferences 存储配置
3. 使用 flutter_dotenv 包

---

## 📊 当前配置状态

### 后端服务
- **本地地址**: `http://localhost:3000`
- **公网地址**: `https://uninstall-escalate-bakeshop.ngrok-free.dev`
- **状态**: ✅ 运行中

### Flutter 应用
- **当前环境**: `production`
- **API 地址**: `https://uninstall-escalate-bakeshop.ngrok-free.dev/api`
- **配置文件**: `lib/config/api_config.dart`

---

## 🔗 相关文档

- [本地部署指南](LOCAL_DEPLOYMENT_GUIDE.md)
- [部署成功记录](DEPLOYMENT_SUCCESS.md)
- [项目快速开始](QUICKSTART.md)

---

**最后更新**: 2026-05-05  
**更新内容**: 创建 API 配置文件，统一管理所有 API 路由
