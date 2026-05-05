# WhatsApp 功能集成说明

## 功能概述

在职位管理系统中添加了 WhatsApp 联系功能，允许每个职位配置一个 WhatsApp 账号，用户可以直接通过 WhatsApp 与招聘方联系。

## 后端更改

### 1. 数据库字段
在 `jobs` 表中添加了 `whatsapp_phone` 字段：
```sql
ALTER TABLE jobs ADD COLUMN whatsapp_phone VARCHAR(20);
```

### 2. 模型更新
- 文件：`src/models/Job.js`
- 更新了 `create` 方法，支持 `whatsappPhone` 参数
- `update` 方法已支持动态字段更新，无需修改

### 3. API 接口
所有职位相关的 API 现在都会返回 `whatsapp_phone` 字段：
- `GET /api/jobs` - 获取职位列表
- `GET /api/jobs/:id` - 获取职位详情
- `POST /api/jobs` - 创建职位（支持 whatsappPhone）
- `PUT /api/jobs/:id` - 更新职位（支持 whatsappPhone）

### 4. 数据库迁移
运行以下命令添加字段（如果数据库中还没有）：
```bash
node add-whatsapp-field.js
```

## 前端更改

### 1. 模型更新
- 文件：`lib/models/job.dart`
- 已包含 `whatsappPhone` 字段（可选）

### 2. UI 更新
- 文件：`lib/screens/job_detail_screen.dart`
- 添加了 WhatsApp 按钮（绿色，带图标）
- 只有当职位配置了 WhatsApp 号码时才显示
- 点击按钮会打开 WhatsApp 应用并跳转到指定账号

### 3. 依赖
使用 `url_launcher` 包来打开 WhatsApp：
```yaml
dependencies:
  url_launcher: ^6.1.0
```

## 使用方法

### 后端管理
创建或更新职位时，添加 `whatsappPhone` 字段：

```json
{
  "title": "软件工程师",
  "description": "...",
  "whatsappPhone": "+8613800138000"
}
```

**WhatsApp 号码格式：**
- 推荐格式：`+[国家代码][手机号]`
- 例如：`+8613800138000`（中国）
- 例如：`+12025551234`（美国）
- 也支持：`13800138000`（会自动处理）

### 前端显示
- 如果职位有 WhatsApp 号码，详情页会显示绿色的 "WhatsApp咨询" 按钮
- 点击按钮会打开 WhatsApp 应用
- 如果没有配置 WhatsApp 号码，按钮不会显示

## 测试

### 1. 测试数据库迁移
```bash
cd JobsProject-Backend
node add-whatsapp-field.js
```

### 2. 测试创建职位
```bash
curl -X POST http://localhost:3000/api/jobs \
  -H "Content-Type: application/json" \
  -d '{
    "title": "测试职位",
    "description": "测试描述",
    "requirements": "测试要求",
    "companyName": "测试公司",
    "location": "北京",
    "salary": "10K-20K",
    "ageRange": "18-35",
    "genderRequirement": "all",
    "weight": 50,
    "countryId": 1,
    "whatsappPhone": "+8613800138000"
  }'
```

### 3. 测试前端显示
1. 启动后端：`npm run dev`
2. 启动前端：`flutter run -d chrome`
3. 查看职位详情页，应该能看到 WhatsApp 按钮
4. 点击按钮测试跳转

## 注意事项

1. **号码格式**：建议使用国际格式（带国家代码），如 `+8613800138000`
2. **隐私保护**：确保 WhatsApp 号码是公开的招聘联系方式
3. **移动端测试**：WhatsApp 跳转在移动设备上效果最佳
4. **Web 端**：在 Web 浏览器中会打开 WhatsApp Web
5. **可选字段**：whatsappPhone 是可选的，不影响现有职位

## 更新日期
2026-05-04
