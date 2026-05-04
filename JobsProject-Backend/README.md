# JobHub 后台 API 服务

## 📋 项目概述

JobHub 招聘应用的 Node.js + Express 后台 API 服务，提供用户认证、职位管理、国家管理等功能。

## 🛠️ 技术栈

- **框架**: Express.js
- **数据库**: MySQL
- **认证**: JWT (JSON Web Token)
- **密码加密**: bcryptjs
- **开发工具**: Nodemon

## 📦 项目结构

```
src/
├── config/          # 配置文件（数据库连接等）
├── controllers/     # 业务逻辑控制器
├── middleware/      # 中间件（认证等）
├── models/          # 数据模型
├── routes/          # 路由定义
├── utils/           # 工具函数
└── server.js        # 应用入口
```

## 🚀 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 配置环境变量

复制 `.env.example` 为 `.env` 并修改配置：

```bash
cp .env.example .env
```

编辑 `.env` 文件：

```env
PORT=3000
NODE_ENV=development

DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=jobshub

JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRE=7d

CORS_ORIGIN=http://localhost:3000,http://localhost:5173
```

### 3. 初始化数据库

使用 MySQL 客户端执行 `init.sql`：

```bash
mysql -u root -p < init.sql
```

或在 MySQL 中执行：

```sql
source init.sql;
```

### 4. 启动服务

**开发模式**（自动重启）：

```bash
npm run dev
```

**生产模式**：

```bash
npm start
```

服务将在 `http://localhost:3000` 启动。

## 📡 API 接口文档

### 健康检查

```
GET /api/health
```

响应：

```json
{
  "status": "OK",
  "message": "JobHub API 服务运行中"
}
```

### 用户认证

#### 注册

```
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "用户名"
}
```

响应：

```json
{
  "message": "注册成功",
  "userId": 1
}
```

#### 登录

```
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

响应：

```json
{
  "id": 1,
  "email": "user@example.com",
  "name": "用户名",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### 获取个人信息

```
GET /api/auth/profile
Authorization: Bearer <token>
```

响应：

```json
{
  "id": 1,
  "email": "user@example.com",
  "name": "用户名",
  "created_at": "2025-05-03T10:00:00Z"
}
```

#### 更新个人信息

```
PUT /api/auth/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "新用户名",
  "email": "newemail@example.com"
}
```

### 职位管理

#### 获取职位列表

```
GET /api/jobs?country=1&gender=all&limit=20&offset=0
```

查询参数：

- `country`: 国家 ID（可选）
- `gender`: 性别要求 (all/male/female)（可选）
- `limit`: 每页数量（默认 20）
- `offset`: 偏移量（默认 0）

响应：

```json
[
  {
    "id": 1,
    "title": "高级 Flutter 开发工程师",
    "description": "我们正在寻找一位经验丰富的 Flutter 开发工程师...",
    "requirements": "5年以上 Flutter 开发经验...",
    "company_name": "TechCorp",
    "company_logo": "https://example.com/logo.png",
    "location": "北京",
    "salary": "30k-50k",
    "age_range": "25-40",
    "gender_requirement": "all",
    "weight": 90,
    "country_id": 1,
    "created_at": "2025-05-03T10:00:00Z",
    "updated_at": "2025-05-03T10:00:00Z"
  }
]
```

#### 获取职位详情

```
GET /api/jobs/:id
```

#### 创建职位（需要认证）

```
POST /api/jobs
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "职位标题",
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
}
```

#### 更新职位（需要认证）

```
PUT /api/jobs/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "新职位标题",
  "salary": "新薪资范围"
}
```

#### 删除职位（需要认证）

```
DELETE /api/jobs/:id
Authorization: Bearer <token>
```

### 国家管理

#### 获取国家列表

```
GET /api/countries
```

响应：

```json
[
  {
    "id": 1,
    "name": "中国",
    "code": "CN",
    "created_at": "2025-05-03T10:00:00Z",
    "updated_at": "2025-05-03T10:00:00Z"
  }
]
```

#### 获取国家详情

```
GET /api/countries/:id
```

#### 创建国家（需要认证）

```
POST /api/countries
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "国家名称",
  "code": "COUNTRY_CODE"
}
```

#### 更新国家（需要认证）

```
PUT /api/countries/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "新国家名称",
  "code": "NEW_CODE"
}
```

#### 删除国家（需要认证）

```
DELETE /api/countries/:id
Authorization: Bearer <token>
```

## 🔐 认证说明

- 需要认证的接口在请求头中添加 `Authorization: Bearer <token>`
- token 由登录接口返回，有效期为 7 天
- token 过期后需要重新登录获取新的 token

## 📝 错误处理

所有错误响应格式：

```json
{
  "error": "错误信息"
}
```

常见错误码：

- `400`: 请求参数错误
- `401`: 认证失败或 token 过期
- `404`: 资源不存在
- `500`: 服务器错误

## 🧪 测试

可以使用 Postman、Insomnia 或 curl 进行 API 测试。

示例（使用 curl）：

```bash
# 注册
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123456","name":"Test User"}'

# 登录
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123456"}'

# 获取职位列表
curl http://localhost:3000/api/jobs
```

## 🐛 常见问题

### Q: 数据库连接失败？

A: 检查 `.env` 中的数据库配置是否正确，确保 MySQL 服务已启动。

### Q: token 过期怎么办？

A: 需要重新登录获取新的 token。

### Q: 如何修改 JWT 过期时间？

A: 修改 `.env` 中的 `JWT_EXPIRE` 参数（例如 `30d` 表示 30 天）。

## 📚 参考资源

- [Express.js 官方文档](https://expressjs.com/)
- [MySQL 官方文档](https://dev.mysql.com/doc/)
- [JWT 官方文档](https://jwt.io/)
- [bcryptjs 文档](https://www.npmjs.com/package/bcryptjs)

## 📞 支持

如有问题，请提出 issue 或联系开发团队。

---

**创建日期**: 2025-05-03  
**最后更新**: 2025-05-03
