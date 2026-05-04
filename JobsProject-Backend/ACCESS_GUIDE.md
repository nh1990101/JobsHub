# 🎉 JobHub 后台 API 已启动！

## ✅ 服务状态

**服务地址**: `http://localhost:3000`  
**状态**: ✓ **运行中**（Mock 模式）  
**启动时间**: 2026-05-03 09:26:43

---

## 🚀 快速访问

### 方式 1️⃣: 使用 Web 测试工具（推荐）

打开浏览器访问：

```
http://localhost:3000/api-test.html
```

这是一个完整的 Web UI，可以直接测试所有 API 接口，无需使用命令行。

### 方式 2️⃣: 使用 curl 命令

#### 健康检查

```bash
curl http://localhost:3000/api/health
```

#### 用户注册

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "123456",
    "name": "测试用户"
  }'
```

#### 用户登录

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "123456"
  }'
```

#### 获取职位列表

```bash
curl http://localhost:3000/api/jobs
```

#### 获取国家列表

```bash
curl http://localhost:3000/api/countries
```

### 方式 3️⃣: 使用 Postman 或 Insomnia

1. 打开 Postman/Insomnia
2. 创建新请求
3. 输入 URL: `http://localhost:3000/api/health`
4. 点击 Send

---

## 📚 完整文档

| 文档 | 说明 |
|------|------|
| `API_TEST.md` | 详细的 curl 命令测试指南 |
| `README.md` | 完整的 API 接口文档 |
| `QUICKSTART.md` | 快速入门指南 |
| `api-test.html` | Web UI 测试工具 |

---

## 📡 API 端点列表

### 用户认证
- `POST /api/auth/register` - 用户注册
- `POST /api/auth/login` - 用户登录
- `GET /api/auth/profile` - 获取个人信息（需要认证）
- `PUT /api/auth/profile` - 更新个人信息（需要认证）

### 职位管理
- `GET /api/jobs` - 获取职位列表
- `GET /api/jobs/:id` - 获取职位详情
- `POST /api/jobs` - 创建职位（需要认证）
- `PUT /api/jobs/:id` - 更新职位（需要认证）
- `DELETE /api/jobs/:id` - 删除职位（需要认证）

### 国家管理
- `GET /api/countries` - 获取国家列表
- `GET /api/countries/:id` - 获取国家详情
- `POST /api/countries` - 创建国家（需要认证）
- `PUT /api/countries/:id` - 更新国家（需要认证）
- `DELETE /api/countries/:id` - 删除国家（需要认证）

### 其他
- `GET /api/health` - 健康检查

---

## 🧪 测试流程

### 步骤 1: 打开 Web 测试工具

在浏览器中打开：
```
http://localhost:3000/api-test.html
```

### 步骤 2: 注册用户

在"用户认证"部分：
1. 输入邮箱: `test@example.com`
2. 输入密码: `123456`
3. 输入用户名: `测试用户`
4. 点击"注册"按钮

### 步骤 3: 登录用户

在"用户认证"部分：
1. 输入邮箱: `test@example.com`
2. 输入密码: `123456`
3. 点击"登录"按钮
4. 成功后会显示 Token

### 步骤 4: 测试其他 API

- 获取职位列表
- 获取国家列表
- 创建新职位（需要 Token）
- 获取个人信息（需要 Token）

---

## 💡 示例数据

### 预置职位（3 个）

1. **高级 Flutter 开发工程师**
   - 公司: TechCorp
   - 地点: 北京
   - 薪资: 30k-50k
   - 权重: 90

2. **全栈工程师**
   - 公司: StartupXYZ
   - 地点: 上海
   - 薪资: 25k-40k
   - 权重: 80

3. **UI/UX 设计师**
   - 公司: DesignStudio
   - 地点: 深圳
   - 薪资: 20k-35k
   - 权重: 70

### 预置国家（5 个）

1. 中国 (CN)
2. 美国 (US)
3. 日本 (JP)
4. 新加坡 (SG)
5. 加拿大 (CA)

---

## 🔐 认证说明

### 获取 Token

1. 登录成功后，API 会返回 `token`
2. Token 有效期为 7 天
3. Web 测试工具会自动保存 Token 到浏览器本地存储

### 使用 Token

在需要认证的请求中，添加请求头：

```
Authorization: Bearer <your_token>
```

### 示例

```bash
curl -X GET http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## ⚠️ 重要说明

### Mock 模式

当前使用 **Mock 模式**（内存存储），这意味着：

- ✅ 可以完整测试所有 API 功能
- ✅ 无需配置 MySQL 数据库
- ❌ 重启服务后数据会丢失
- ❌ 多个用户的数据会互相影响

### 切换到真实数据库

当 MySQL 可用时：

1. 确保 MySQL 已启动
2. 修改 `.env` 中的数据库配置
3. 执行 `init.sql` 初始化数据库
4. 修改 `src/server.js` 使用真实数据库模型
5. 重启服务

---

## 🛠️ 常见问题

### Q: 如何停止服务？

A: 在启动服务的终端中按 `Ctrl+C`

### Q: 如何重启服务？

A: 
```bash
cd D:\Project\JobsProject-Backend
npm run dev
```

### Q: 如何查看服务日志？

A: 
```bash
# 查看最后 50 行日志
tail -50 server.log

# 实时查看日志
tail -f server.log
```

### Q: Token 过期了怎么办？

A: 重新登录获取新的 Token

### Q: 如何修改服务端口？

A: 编辑 `.env` 文件，修改 `PORT` 值

### Q: 如何使用 Postman 测试？

A: 
1. 打开 Postman
2. 创建新请求
3. 选择 POST 方法
4. 输入 URL: `http://localhost:3000/api/auth/login`
5. 在 Headers 中添加: `Content-Type: application/json`
6. 在 Body 中输入 JSON 数据
7. 点击 Send

---

## 📞 需要帮助？

### 查看完整文档

- **API 详细文档**: `README.md`
- **curl 测试指南**: `API_TEST.md`
- **快速入门**: `QUICKSTART.md`

### 常见错误

| 错误 | 原因 | 解决方案 |
|------|------|--------|
| `Cannot GET /api/health` | 服务未启动 | 运行 `npm run dev` |
| `CORS error` | 跨域问题 | 检查 `.env` 中的 `CORS_ORIGIN` |
| `401 Unauthorized` | Token 缺失或过期 | 重新登录获取新 Token |
| `404 Not Found` | 资源不存在 | 检查 ID 是否正确 |

---

## 🎯 下一步

1. ✅ **测试 API** - 使用 Web 工具或 curl 测试所有接口
2. ⬜ **前端集成** - 在 Flutter 应用中调用这些 API
3. ⬜ **数据库配置** - 配置真实的 MySQL 数据库
4. ⬜ **功能扩展** - 根据需要添加新的 API 端点
5. ⬜ **部署上线** - 部署到生产环境

---

## 🎉 祝你使用愉快！

如果有任何问题或需要帮助，随时告诉我！

**服务地址**: `http://localhost:3000`  
**Web 工具**: `http://localhost:3000/api-test.html`

---

**创建时间**: 2026-05-03  
**最后更新**: 2026-05-03
