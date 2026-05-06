# JobHub 开发指南

## 📝 修改需求前必读

### 开发流程
1. **理解需求** - 明确要修改什么功能
2. **定位代码** - 找到相关文件
3. **修改代码** - 按照规范修改
4. **测试验证** - 确保功能正常
5. **提交代码** - Git提交（可选）

### 代码规范
- **前端**：遵循Dart/Flutter命名规范
- **后端**：遵循JavaScript/Node.js规范
- **注释**：关键逻辑必须添加注释
- **格式化**：保持代码格式一致

## 🎯 常见修改场景

### 场景1：修改API地址

#### 修改本地开发API
**文件**：`JobsProject/lib/config/api_config.dart`
```dart
// 修改这一行
static const String developmentBaseUrl = 'http://localhost:3000/api';
```

#### 修改外网API
**文件**：`JobsProject/lib/config/api_config.dart`
```dart
// 修改这一行
static const String productionBaseUrl = 'https://your-domain.com/api';
```

#### 修改后端端口
**文件**：`JobsProject-Backend/.env`
```env
# 修改这一行
PORT=3000
```

**注意**：修改端口后需要重启后端服务

### 场景2：修改数据库配置

**文件**：`JobsProject-Backend/.env`
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=jobshub
```

**修改后**：重启后端服务

### 场景3：添加新的API接口

#### 步骤1：后端添加路由
**文件**：`JobsProject-Backend/src/server.js`
```javascript
// 在路由部分添加
app.get('/api/your-endpoint', async (req, res) => {
  try {
    // 你的逻辑
    res.json({ success: true, data: [] });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

#### 步骤2：前端添加API方法
**文件**：`JobsProject/lib/services/api_service.dart`
```dart
// 在ApiService类中添加
Future<List<YourModel>> getYourData() async {
  try {
    final response = await _dio.get('/your-endpoint');
    return response.data;
  } catch (e) {
    throw Exception('Failed to get data: $e');
  }
}
```

#### 步骤3：前端调用API
**文件**：相关的Screen文件
```dart
final apiService = ApiService();
final data = await apiService.getYourData();
```

### 场景4：修改UI样式

#### 修改主题色
**文件**：`JobsProject/lib/config/app_colors.dart`
```dart
class AppColors {
  static const Color primary = Color(0xFF00B6B6); // 修改这里
  // ...
}
```

#### 修改文本
**文件**：`JobsProject/lib/config/app_strings.dart`
```dart
class AppStrings {
  static const String appName = 'JobHub'; // 修改这里
  // ...
}
```

### 场景5：添加新页面

#### 步骤1：创建Screen文件
**文件**：`JobsProject/lib/screens/your_screen.dart`
```dart
import 'package:flutter/material.dart';

class YourScreen extends StatelessWidget {
  const YourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Page')),
      body: Center(child: Text('Your Content')),
    );
  }
}
```

#### 步骤2：添加路由
**文件**：`JobsProject/lib/config/app_routes.dart`
```dart
import '../screens/your_screen.dart'; // 添加导入

// 在routes中添加
GoRoute(
  path: '/your-page',
  builder: (context, state) => const YourScreen(),
),
```

#### 步骤3：导航到新页面
```dart
context.push('/your-page');
```

### 场景6：修改数据库表结构

#### 步骤1：编写迁移SQL
**文件**：`JobsProject-Backend/src/server.js`
```javascript
// 在runMigrations函数中添加
async function runMigrations() {
  try {
    // 添加新的迁移
    await pool.query(`
      ALTER TABLE jobs 
      ADD COLUMN your_field VARCHAR(255) DEFAULT NULL
    `);
    console.log('✅ 迁移完成: your_field 字段已添加');
  } catch (error) {
    console.log('⚠️  迁移已存在或失败:', error.message);
  }
}
```

#### 步骤2：更新前端模型
**文件**：`JobsProject/lib/models/job.dart`
```dart
class Job {
  final String yourField; // 添加新字段

  Job({
    // ...
    required this.yourField,
  });
}
```

#### 步骤3：更新API解析
**文件**：`JobsProject/lib/services/api_service.dart`
```dart
Job(
  // ...
  yourField: job['your_field'] ?? '',
)
```

## 🔍 代码定位指南

### 前端代码定位

| 需求 | 文件位置 |
|------|---------|
| 修改API地址 | `lib/config/api_config.dart` |
| 修改颜色 | `lib/config/app_colors.dart` |
| 修改文本 | `lib/config/app_strings.dart` |
| 修改路由 | `lib/config/app_routes.dart` |
| 修改首页 | `lib/screens/home_screen.dart` |
| 修改职位详情 | `lib/screens/job_detail_screen.dart` |
| 修改API调用 | `lib/services/api_service.dart` |
| 修改数据模型 | `lib/models/` |
| 修改状态管理 | `lib/providers/` |

### 后端代码定位

| 需求 | 文件位置 |
|------|---------|
| 修改API路由 | `src/server.js` (路由部分) |
| 修改CORS配置 | `src/server.js` (CORS中间件) |
| 修改数据库配置 | `.env` |
| 修改端口 | `.env` (PORT) |
| 添加数据库迁移 | `src/server.js` (runMigrations) |
| 修改JWT配置 | `.env` (JWT_SECRET) |

## 🧪 测试指南

### 前端测试

#### 热重载测试
1. 修改代码
2. 保存文件
3. 在Flutter终端按 `r` 键
4. 查看Chrome中的变化

#### 完整重启测试
1. 修改代码
2. 在Flutter终端按 `R` 键（大写）
3. 等待应用重启

#### API测试
```dart
// 在代码中添加打印
print('📡 API请求: $url');
print('✅ API响应: $response');
```

### 后端测试

#### 使用curl测试
```bash
# GET请求
curl http://localhost:3000/api/jobs

# POST请求
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

#### 查看日志
后端会自动打印请求日志，查看终端输出

#### 数据库测试
```bash
mysql -u root -p

USE jobshub;
SELECT * FROM jobs LIMIT 5;
```

## 🐛 调试技巧

### 前端调试

#### Chrome开发者工具
1. 按 `F12` 打开开发者工具
2. 查看 **Console** 标签 - 查看日志和错误
3. 查看 **Network** 标签 - 查看API请求
4. 查看 **Application** 标签 - 查看本地存储

#### Flutter DevTools
- 终端会显示DevTools链接
- 点击链接打开Flutter专用调试工具

#### 添加调试日志
```dart
print('🔍 调试信息: $variable');
debugPrint('详细信息: $details');
```

### 后端调试

#### 添加日志
```javascript
console.log('📝 调试信息:', variable);
console.error('❌ 错误信息:', error);
```

#### 查看请求详情
```javascript
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  console.log('Body:', req.body);
  next();
});
```

## 📦 依赖管理

### 前端添加依赖

#### 步骤1：编辑pubspec.yaml
```yaml
dependencies:
  your_package: ^1.0.0
```

#### 步骤2：安装依赖
```bash
cd D:\Project\JobsHub\JobsProject
flutter pub get
```

### 后端添加依赖

#### 安装依赖
```bash
cd D:\Project\JobsHub\JobsProject-Backend
npm install package-name
```

#### 安装开发依赖
```bash
npm install --save-dev package-name
```

## 🔒 安全注意事项

### 敏感信息
- **不要**提交`.env`文件到Git
- **不要**在代码中硬编码密码
- **不要**在前端存储敏感信息

### API安全
- 使用JWT token认证
- 验证所有用户输入
- 使用参数化查询防止SQL注入

### CORS配置
- 生产环境限制允许的域名
- 不要在生产环境使用`*`通配符

## 🚀 构建发布

### 构建Web版本
```bash
cd D:\Project\JobsHub\JobsProject
flutter build web --release
```

**输出目录**：`build/web/`

### 构建Android APK
```bash
cd D:\Project\JobsHub\JobsProject
flutter build apk --release
```

**输出文件**：`build/app/outputs/flutter-apk/app-release.apk`

详细步骤参考：`APK_BUILD_GUIDE.md`

## 📚 参考资源

### 官方文档
- [Flutter文档](https://flutter.dev/docs)
- [Dart文档](https://dart.dev/guides)
- [Express文档](https://expressjs.com/)
- [MySQL文档](https://dev.mysql.com/doc/)

### 项目文档
- `PROJECT_STRUCTURE.md` - 项目结构说明
- `STARTUP_GUIDE.md` - 启动指南
- `API_CONFIG_GUIDE.md` - API配置说明
- `APK_BUILD_GUIDE.md` - APK构建指南

## 💡 最佳实践

### 代码组织
- 一个文件一个类/组件
- 相关功能放在同一目录
- 使用清晰的命名

### 错误处理
- 所有API调用都要try-catch
- 给用户友好的错误提示
- 记录错误日志

### 性能优化
- 使用const构造函数
- 避免不必要的重建
- 合理使用缓存

### Git提交
- 提交前测试功能
- 写清晰的提交信息
- 一次提交一个功能

## 🔄 常见修改流程示例

### 示例1：添加新的职位字段

1. **后端数据库**：添加字段
```javascript
await pool.query(`
  ALTER TABLE jobs 
  ADD COLUMN salary_range VARCHAR(100)
`);
```

2. **后端API**：返回新字段（无需修改，自动返回）

3. **前端模型**：添加字段
```dart
class Job {
  final String salaryRange;
  // ...
}
```

4. **前端解析**：解析新字段
```dart
Job(
  salaryRange: job['salary_range'] ?? '',
  // ...
)
```

5. **前端UI**：显示新字段
```dart
Text('薪资范围: ${job.salaryRange}')
```

6. **测试**：重启服务，验证功能

### 示例2：修改主题颜色

1. **修改颜色配置**
```dart
// lib/config/app_colors.dart
static const Color primary = Color(0xFFFF5722); // 改为橙色
```

2. **热重载**：按 `r` 键

3. **验证**：查看UI颜色变化

## 📞 获取帮助

遇到问题时：
1. 查看错误日志
2. 检查相关文档
3. 搜索错误信息
4. 查看项目文档
5. 询问Claude Code
