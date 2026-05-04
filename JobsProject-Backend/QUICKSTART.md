# JobHub 后台快速入门指南

## 📋 项目已初始化完成

你的 JobHub 后台项目已经完全初始化，包含以下内容：

### ✅ 已完成的工作

1. **项目结构** - 标准的 Node.js + Express 项目结构
2. **依赖安装** - 已安装所有必要的 npm 包
3. **数据库配置** - MySQL 连接配置
4. **认证系统** - JWT 令牌认证
5. **API 路由** - 完整的 RESTful API 接口
6. **数据模型** - User、Job、Country 三个主要模型
7. **数据库初始化脚本** - init.sql 包含表结构和示例数据

---

## 🚀 快速启动步骤

### 步骤 1：配置数据库

编辑 `.env` 文件，修改 MySQL 连接信息：

```env
DB_HOST=localhost      # MySQL 主机
DB_PORT=3306          # MySQL 端口
DB_USER=root          # MySQL 用户名
DB_PASSWORD=password  # MySQL 密码
DB_NAME=jobshub       # 数据库名称
```

### 步骤 2：初始化数据库

使用 MySQL 客户端执行初始化脚本：

```bash
# 方式 1：使用 mysql 命令行
mysql -u root -p < init.sql

# 方式 2：在 MySQL 中执行
mysql> source init.sql;
```

这将创建：
- `users` 表（用户表）
- `countries` 表（国家表）
- `jobs` 表（职位表）
- 5 个示例国家
- 3 个示例职位

### 步骤 3：启动服务

**Windows 用户**：

```bash
# 双击运行
run.bat

# 或在 PowerShell 中运行
.\run.bat
```

**Mac/Linux 用户**：

```bash
# 给脚本执行权限
chmod +x run.sh

# 运行脚本
./run.sh
```

**或直接使用 npm**：

```bash
# 开发模式（推荐）
npm run dev

# 生产模式
npm start
```

### 步骤 4：验证服务

打开浏览器访问：

```
http://localhost:3000/api/health
```

如果看到以下响应，说明服务启动成功：

```json
{
  "status": "OK",
  "message": "JobHub API 服务运行中"
}
```

---

## 🧪 测试 API

### 使用 Postman 或 Insomnia

1. **获取职位列表**

```
GET http://localhost:3000/api/jobs
```

2. **用户注册**

```
POST http://localhost:3000/api/auth/register
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "123456",
  "name": "测试用户"
}
```

3. **用户登录**

```
POST http://localhost:3000/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "123456"
}
```

登录成功后会返回 token，复制这个 token。

4. **获取个人信息**（需要 token）

```
GET http://localhost:3000/api/auth/profile
Authorization: Bearer <你的token>
```

5. **获取国家列表**

```
GET http://localhost:3000/api/countries
```

---

## 📁 项目文件说明

```
JobsProject-Backend/
├── src/
│   ├── config/
│   │   └── database.js          # MySQL 连接配置
│   ├── controllers/
│   │   ├── authController.js    # 认证逻辑
│   │   ├── jobController.js     # 职位逻辑
│   │   └── countryController.js # 国家逻辑
│   ├── middleware/
│   │   └── auth.js              # JWT 认证中间件
│   ├── models/
│   │   ├── User.js              # 用户模型
│   │   ├── Job.js               # 职位模型
│   │   └── Country.js           # 国家模型
│   ├── routes/
│   │   ├── authRoutes.js        # 认证路由
│   │   ├── jobRoutes.js         # 职位路由
│   │   └── countryRoutes.js     # 国家路由
│   ├── utils/
│   │   └── jwt.js               # JWT 工具函数
│   └── server.js                # 应用入口
├── .env.example                 # 环境变量示例
├── .env                         # 环境变量（需要修改）
├── .gitignore                   # Git 忽略文件
├── init.sql                     # 数据库初始化脚本
├── package.json                 # 项目依赖配置
├── README.md                    # 完整 API 文档
├── run.bat                      # Windows 启动脚本
└── run.sh                       # Mac/Linux 启动脚本
```

---

## 🔧 常见操作

### 添加新的 API 端点

1. 在 `src/models/` 中创建数据模型
2. 在 `src/controllers/` 中创建控制器
3. 在 `src/routes/` 中创建路由
4. 在 `src/server.js` 中注册路由

### 修改数据库表结构

1. 修改 `init.sql`
2. 删除现有数据库：`DROP DATABASE jobshub;`
3. 重新执行 `init.sql`

### 修改 JWT 过期时间

编辑 `.env` 文件：

```env
JWT_EXPIRE=30d  # 改为 30 天
```

---

## 🐛 故障排除

### 问题 1：MySQL 连接失败

**解决方案**：
- 确保 MySQL 服务已启动
- 检查 `.env` 中的数据库配置
- 确认用户名和密码正确

### 问题 2：端口 3000 已被占用

**解决方案**：
- 修改 `.env` 中的 `PORT` 值
- 或关闭占用该端口的其他应用

### 问题 3：数据库初始化失败

**解决方案**：
- 检查 MySQL 是否已启动
- 确保有创建数据库的权限
- 查看错误信息并根据提示修复

---

## 📚 下一步

### Phase 2 后续任务

- [ ] 前端集成 API
- [ ] 添加更多业务逻辑
- [ ] 实现数据验证
- [ ] 添加日志系统
- [ ] 编写单元测试
- [ ] 部署到生产环境

### 推荐的增强功能

1. **数据验证** - 使用 `joi` 或 `express-validator`
2. **日志系统** - 使用 `winston` 或 `morgan`
3. **错误处理** - 统一的错误处理中间件
4. **缓存** - 使用 Redis 缓存热数据
5. **文件上传** - 使用 `multer` 处理文件上传
6. **分页优化** - 实现更高效的分页查询

---

## 📞 需要帮助？

如果遇到问题，你可以：

1. 查看 `README.md` 中的完整 API 文档
2. 检查 `src/` 目录中的代码注释
3. 查看错误日志信息
4. 告诉我具体的问题，我会帮助你解决

---

**祝你开发愉快！** 🎉

如果需要添加新功能或修改现有功能，随时告诉我！
