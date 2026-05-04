# 🚀 JobHub API 测试指南

## ✅ 服务状态

**服务地址**: `http://localhost:3000`  
**状态**: ✓ 运行中（Mock 模式）

---

## 📡 API 测试命令

### 1️⃣ 健康检查

```bash
curl http://localhost:3000/api/health
```

**响应**:
```json
{
  "status": "OK",
  "message": "JobHub API 服务运行中（Mock 模式）",
  "timestamp": "2026-05-03T09:27:06.533Z"
}
```

---

## 👤 用户认证 API

### 1. 用户注册

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "name": "用户名"
  }'
```

**响应**:
```json
{
  "message": "注册成功",
  "userId": 1
}
```

### 2. 用户登录

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

**响应**:
```json
{
  "id": 1,
  "email": "user@example.com",
  "name": "用户名",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**⚠️ 重要**: 保存返回的 `token`，后续认证请求需要使用。

### 3. 获取个人信息

```bash
curl -X GET http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**响应**:
```json
{
  "id": 1,
  "email": "user@example.com",
  "name": "用户名",
  "created_at": "2026-05-03T09:26:43.794Z"
}
```

### 4. 更新个人信息

```bash
curl -X PUT http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "新用户名",
    "email": "newemail@example.com"
  }'
```

**响应**:
```json
{
  "message": "更新成功"
}
```

---

## 💼 职位管理 API

### 1. 获取职位列表

```bash
# 获取所有职位
curl http://localhost:3000/api/jobs

# 按国家筛选
curl "http://localhost:3000/api/jobs?country=1"

# 按性别筛选
curl "http://localhost:3000/api/jobs?gender=all"

# 分页
curl "http://localhost:3000/api/jobs?limit=10&offset=0"

# 组合查询
curl "http://localhost:3000/api/jobs?country=1&gender=all&limit=20&offset=0"
```

**响应**:
```json
[
  {
    "id": 1,
    "title": "高级 Flutter 开发工程师",
    "description": "我们正在寻找一位经验丰富的 Flutter 开发工程师...",
    "requirements": "5年以上 Flutter 开发经验...",
    "company_name": "TechCorp",
    "company_logo": "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100'%3E%3Crect fill='%23e0e0e0' width='100' height='100'/%3E%3Ctext x='50' y='50' font-size='12' fill='%23999' text-anchor='middle' dy='.3em'%3ETechCorp%3C/text%3E%3C/svg%3E",
    "location": "北京",
    "salary": "30k-50k",
    "age_range": "25-40",
    "gender_requirement": "all",
    "weight": 90,
    "country_id": 1,
    "created_at": "2026-05-03T09:26:43.794Z",
    "updated_at": "2026-05-03T09:26:43.794Z"
  }
]
```

### 2. 获取职位详情

```bash
curl http://localhost:3000/api/jobs/1
```

**响应**: 单个职位对象

### 3. 创建职位（需要认证）

```bash
curl -X POST http://localhost:3000/api/jobs \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "新职位",
    "description": "职位描述",
    "requirements": "职位要求",
    "company_name": "公司名称",
    "company_logo": "https://example.com/logo.png",
    "location": "工作地点",
    "salary": "薪资范围",
    "age_range": "25-40",
    "gender_requirement": "all",
    "weight": 80,
    "country_id": 1
  }'
```

**响应**:
```json
{
  "message": "职位创建成功",
  "jobId": 4
}
```

### 4. 更新职位（需要认证）

```bash
curl -X PUT http://localhost:3000/api/jobs/1 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "更新后的职位标题",
    "salary": "新薪资范围"
  }'
```

**响应**:
```json
{
  "message": "职位更新成功"
}
```

### 5. 删除职位（需要认证）

```bash
curl -X DELETE http://localhost:3000/api/jobs/1 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**响应**:
```json
{
  "message": "职位删除成功"
}
```

---

## 🌍 国家管理 API

### 1. 获取国家列表

```bash
curl http://localhost:3000/api/countries
```

**响应**:
```json
[
  {
    "id": 1,
    "name": "中国",
    "code": "CN",
    "created_at": "2026-05-03T09:26:43.794Z",
    "updated_at": "2026-05-03T09:26:43.794Z"
  }
]
```

### 2. 获取国家详情

```bash
curl http://localhost:3000/api/countries/1
```

**响应**: 单个国家对象

### 3. 创建国家（需要认证）

```bash
curl -X POST http://localhost:3000/api/countries \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "新国家",
    "code": "XX"
  }'
```

**响应**:
```json
{
  "message": "国家创建成功",
  "countryId": 6
}
```

### 4. 更新国家（需要认证）

```bash
curl -X PUT http://localhost:3000/api/countries/1 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "新国家名称",
    "code": "NEW"
  }'
```

**响应**:
```json
{
  "message": "国家更新成功"
}
```

### 5. 删除国家（需要认证）

```bash
curl -X DELETE http://localhost:3000/api/countries/1 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**响应**:
```json
{
  "message": "国家删除成功"
}
```

---

## 🔐 认证说明

### 获取 Token

1. 先注册或登录用户
2. 登录响应中会返回 `token`
3. 在需要认证的请求中，添加请求头：

```
Authorization: Bearer <your_token>
```

### 示例

```bash
# 1. 登录获取 token
TOKEN=$(curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123456"}' | grep -o '"token":"[^"]*' | cut -d'"' -f4)

# 2. 使用 token 访问受保护的端点
curl -X GET http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer $TOKEN"
```

---

## 🧪 完整测试流程

### 步骤 1: 注册用户

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@example.com",
    "password": "demo123",
    "name": "演示用户"
  }'
```

### 步骤 2: 登录用户

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@example.com",
    "password": "demo123"
  }'
```

保存返回的 `token`。

### 步骤 3: 获取职位列表

```bash
curl http://localhost:3000/api/jobs
```

### 步骤 4: 创建新职位

```bash
curl -X POST http://localhost:3000/api/jobs \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "测试职位",
    "description": "这是一个测试职位",
    "requirements": "测试要求",
    "company_name": "测试公司",
    "location": "测试地点",
    "salary": "15k-25k",
    "weight": 50,
    "country_id": 1
  }'
```

### 步骤 5: 获取个人信息

```bash
curl http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 💡 使用 Postman 或 Insomnia

如果你使用 Postman 或 Insomnia，可以：

1. 创建新的 POST 请求
2. URL: `http://localhost:3000/api/auth/login`
3. Headers: `Content-Type: application/json`
4. Body:
```json
{
  "email": "test@example.com",
  "password": "123456"
}
```
5. 点击 Send

---

## ⚠️ 重要说明

- **Mock 模式**: 当前使用内存存储，重启服务后数据会丢失
- **示例数据**: 已预置 5 个国家和 3 个职位
- **Token 有效期**: 7 天
- **密码**: 当前未加密存储（仅用于测试）

---

## 🔄 切换到真实数据库

当 MySQL 可用时，修改 `src/server.js` 使用真实数据库模型：

1. 确保 MySQL 已启动
2. 执行 `init.sql` 初始化数据库
3. 将 `src/server.js` 恢复为使用 models 和 database 配置
4. 重启服务

---

**祝你测试愉快！** 🎉
