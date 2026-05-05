# ngrok CORS 问题解决方案

## 🔍 问题描述

Flutter Web 应用访问 ngrok 公网地址时出现 CORS 错误：
```
DioException [connection error]: The connection errored: 
The XMLHttpRequest onError callback was called.
```

## 🎯 根本原因

ngrok 免费版在首次访问时会显示一个**警告页面**，需要手动点击 "Visit Site" 才能继续访问。这导致浏览器的 CORS 预检请求失败。

---

## ✅ 解决方案

### 方案 1：手动访问 ngrok 地址（最简单）

**步骤：**

1. 在浏览器中打开 ngrok 地址：
   ```
   https://uninstall-escalate-bakeshop.ngrok-free.dev/api/health
   ```

2. 点击 **"Visit Site"** 按钮

3. 刷新 Flutter 应用页面

**原理：** 点击后，ngrok 会在浏览器中设置 cookie，后续请求就不会再显示警告页面。

---

### 方案 2：使用 ngrok 付费版（推荐生产环境）

**优点：**
- ✅ 无警告页面
- ✅ 固定域名
- ✅ 无请求限制
- ✅ 更快的速度

**价格：** $8/月

**升级方法：**
1. 访问：https://dashboard.ngrok.com/billing/subscription
2. 选择 Personal 计划
3. 配置固定域名

---

### 方案 3：使用 Cloudflare Tunnel（免费且无限制）

**优点：**
- ✅ 完全免费
- ✅ 无警告页面
- ✅ 固定域名
- ✅ 自带 CDN 加速

**安装步骤：**

```bash
# 1. 安装 cloudflared
winget install --id Cloudflare.cloudflared

# 2. 登录 Cloudflare
cloudflared tunnel login

# 3. 创建隧道
cloudflared tunnel create jobshub

# 4. 配置隧道（创建 config.yml）
# 见下方配置文件

# 5. 运行隧道
cloudflared tunnel run jobshub
```

**配置文件** (`C:\Users\Administrator\.cloudflared\config.yml`)：
```yaml
tunnel: YOUR_TUNNEL_ID
credentials-file: C:\Users\Administrator\.cloudflared\YOUR_TUNNEL_ID.json

ingress:
  - hostname: api.yourdomain.com
    service: http://localhost:3000
  - service: http_status:404
```

---

### 方案 4：修改 Flutter 应用使用代理

在开发环境中，可以使用 Chrome 禁用 CORS 检查：

**Windows：**
```bash
"C:\Program Files\Google\Chrome\Application\chrome.exe" --disable-web-security --user-data-dir="C:\chrome-dev-session"
```

**然后运行：**
```bash
flutter run -d chrome
```

⚠️ **注意：** 这只适合开发测试，不能用于生产环境。

---

### 方案 5：添加 ngrok 跳过头部（实验性）

修改后端代码，添加 ngrok 跳过警告的头部：

编辑 `JobsProject-Backend/src/server.js`：

```javascript
// 在 CORS 配置后添加
app.use((req, res, next) => {
  // ngrok 跳过警告页面
  res.header('ngrok-skip-browser-warning', 'true');
  next();
});
```

**重启后端服务：**
```bash
cd JobsProject-Backend
node src/server.js
```

---

## 🔧 当前推荐方案

### 开发测试阶段
使用 **方案 1**（手动访问）+ **方案 5**（添加跳过头部）

### 正式运营阶段
使用 **方案 3**（Cloudflare Tunnel）- 完全免费且专业

---

## 📝 快速修复步骤

### 立即修复（5分钟）

1. **在浏览器中访问：**
   ```
   https://uninstall-escalate-bakeshop.ngrok-free.dev/api/health
   ```

2. **点击 "Visit Site"**

3. **刷新 Flutter 应用**

### 永久修复（10分钟）

1. **修改后端代码** - 添加跳过头部（方案 5）

2. **重启后端服务**

3. **测试 Flutter 应用**

---

## 🧪 测试 API 连接

### 测试 1：直接访问
```bash
curl -k https://uninstall-escalate-bakeshop.ngrok-free.dev/api/health
```

**预期结果：**
```json
{"status":"ok","message":"JobHub API is running"}
```

### 测试 2：获取职位列表
```bash
curl -k https://uninstall-escalate-bakeshop.ngrok-free.dev/api/jobs?limit=5
```

**预期结果：** 返回职位列表 JSON

### 测试 3：浏览器访问
在浏览器中打开：
```
https://uninstall-escalate-bakeshop.ngrok-free.dev/api/health
```

---

## 📊 当前状态

- ✅ **后端服务**: 运行正常
- ✅ **ngrok 隧道**: 运行正常
- ✅ **API 响应**: 正常返回数据
- ✅ **CORS 配置**: 已正确配置
- ⚠️  **浏览器访问**: 需要先点击 ngrok 警告页面

---

## 🔗 相关链接

- [ngrok 文档](https://ngrok.com/docs)
- [Cloudflare Tunnel 文档](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [Flutter CORS 问题](https://flutter.dev/docs/development/platform-integration/web)

---

**最后更新**: 2026-05-05  
**问题**: ngrok 免费版警告页面导致 CORS 错误  
**推荐方案**: 手动访问 + 添加跳过头部
