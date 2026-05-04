# JobHub 前后端对接完成

## ✅ 对接内容

### 后端 API (Node.js + Express)
**地址:** `http://localhost:3000/api`

**主要端点:**
- `GET /api/jobs` - 获取职位列表（支持国家、性别、分页过滤）
- `GET /api/countries` - 获取国家列表
- `POST /api/jobs` - 创建职位（需要认证）
- `PUT /api/jobs/:id` - 更新职位（需要认证）
- `DELETE /api/jobs/:id` - 删除职位（需要认证）

### 前端 Flutter 应用
**主要更新:**

1. **API 服务 (lib/services/api_service.dart)**
   - 更新 baseUrl 为 `http://localhost:3000/api`
   - 实现 `getJobs()` 方法，支持国家和性别过滤
   - 自动按权重排序职位（从高到低）

2. **状态管理 (lib/providers/job_provider.dart)**
   - `selectedCountryProvider` - 国家选择状态
   - `jobsProvider` - 根据选择的国家获取职位列表
   - `countriesProvider` - 国家列表

3. **主页面 (lib/screens/home_screen.dart)**
   - 添加国家选择栏（FilterChip）
   - 显示所有国家：中国、美国、日本、新加坡、加拿大
   - 点击国家按钮，自动加载该国家的职位
   - 职位按权重排序显示

## 🎯 功能特性

### 前端功能
✅ 显示当前国家的职业招聘信息
✅ 根据权重排序职位（权重高的优先显示）
✅ 国家选择导航栏
✅ 实时加载职位数据
✅ 错误处理和加载状态

### 后端功能
✅ 职位 CRUD 操作
✅ 国家管理
✅ 权重排序
✅ 国家和性别过滤
✅ 邀请码管理
✅ 用户认证和权限管理

## 📊 数据流

```
前端 (Flutter)
    ↓
API Service (Dio)
    ↓
后端 API (Node.js/Express)
    ↓
Mock 数据库 (内存存储)
    ↓
返回职位列表 (按权重排序)
    ↓
前端显示职位卡片
```

## 🚀 使用方法

### 启动后端服务
```bash
cd D:\Project\JobsProject-Backend
npm run dev
```

### 启动前端应用
```bash
cd D:\Project\JobsProject
flutter run -d chrome  # Web 浏览器
flutter run -d windows # Windows 桌面
flutter run -d android # Android 模拟器
```

### 管理后台
访问 `http://localhost:3000/admin.html` 管理职位和国家

## 📝 初始数据

**预置职位（按权重排序）:**
1. 高级 Flutter 开发工程师 - 权重: 90
2. 全栈工程师 - 权重: 80
3. UI/UX 设计师 - 权重: 70

**预置国家:**
- 中国 (CN) - ID: 1
- 美国 (US) - ID: 2
- 日本 (JP) - ID: 3
- 新加坡 (SG) - ID: 4
- 加拿大 (CA) - ID: 5

## 🔧 技术栈

**后端:**
- Node.js + Express
- Dio (HTTP 客户端)
- JWT 认证
- Mock 数据存储

**前端:**
- Flutter + Dart
- Riverpod (状态管理)
- Dio (HTTP 请求)
- Go Router (路由)
- Flutter ScreenUtil (响应式布局)

## 📌 注意事项

1. **Mock 模式** - 后端使用内存存储，重启后数据会丢失
2. **CORS 配置** - 后端已配置 CORS，支持跨域请求
3. **权重排序** - 前端自动按权重排序职位，权重高的优先显示
4. **国家过滤** - 前端选择国家后，自动加载该国家的职位

## 🎉 完成情况

✅ 后端 API 实现完成
✅ 前端数据对接完成
✅ 国家选择功能完成
✅ 权重排序功能完成
✅ 管理后台完成
✅ 邀请码系统完成
✅ 用户认证系统完成

---

**创建时间:** 2026-05-03
**最后更新:** 2026-05-03
