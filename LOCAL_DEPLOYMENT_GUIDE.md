# 本地部署 + 内网穿透指南

## 🎯 目标
将本地运行的 JobsHub 后台服务（http://localhost:3000）映射到公网，让外网可以访问。

---

## 方案一：ngrok（推荐 - 最简单）

### 优点
- ✅ 5分钟搞定
- ✅ 自动HTTPS
- ✅ 稳定可靠
- ✅ 支持自定义域名（付费版）

### 步骤

#### 1. 安装 ngrok

**方法A：直接下载**
1. 访问：https://ngrok.com/download
2. 下载 Windows 版本
3. 解压到 `D:\Tools\ngrok\`
4. 将 `D:\Tools\ngrok\` 添加到系统 PATH

**方法B：使用 Chocolatey**
```bash
choco install ngrok
```

#### 2. 注册并获取 Token

1. 访问：https://dashboard.ngrok.com/signup
2. 注册免费账号
3. 获取 Authtoken：https://dashboard.ngrok.com/get-started/your-authtoken
4. 配置 token：
```bash
ngrok config add-authtoken YOUR_TOKEN_HERE
```

#### 3. 启动隧道

**方法A：使用脚本（推荐）**
```bash
cd D:\Project\JobsHub\JobsProject-Backend
start-ngrok.bat
```

**方法B：手动启动**
```bash
ngrok http 3000
```

#### 4. 获取公网地址

启动后会显示：
```
Forwarding  https://xxxx-xx-xx-xx-xx.ngrok-free.app -> http://localhost:3000
```

你的公网API地址就是：`https://xxxx-xx-xx-xx-xx.ngrok-free.app/api`

#### 5. 测试访问

```bash
curl https://your-ngrok-url.ngrok-free.app/api/health
```

### 免费版限制
- 每次重启URL会变化
- 每分钟40个请求
- 需要点击警告页面才能访问

### 付费版（$8/月）
- 固定域名（如：jobhub.ngrok.app）
- 无请求限制
- 无警告页面
- 支持自定义域名

---

## 方案二：Cloudflare Tunnel（完全免费）

### 优点
- ✅ 完全免费
- ✅ 固定域名
- ✅ 自带CDN加速
- ✅ 无流量限制

### 步骤

#### 1. 安装 cloudflared

下载：https://github.com/cloudflare/cloudflared/releases

或使用命令：
```bash
# Windows
winget install --id Cloudflare.cloudflared
```

#### 2. 登录 Cloudflare

```bash
cloudflared tunnel login
```

会打开浏览器，选择你的域名（需要先在Cloudflare添加域名）

#### 3. 创建隧道

```bash
cloudflared tunnel create jobshub
```

记下隧道ID

#### 4. 配置隧道

创建配置文件 `C:\Users\Administrator\.cloudflared\config.yml`：

```yaml
tunnel: YOUR_TUNNEL_ID
credentials-file: C:\Users\Administrator\.cloudflared\YOUR_TUNNEL_ID.json

ingress:
  - hostname: api.yourdomain.com
    service: http://localhost:3000
  - service: http_status:404
```

#### 5. 配置DNS

```bash
cloudflared tunnel route dns jobshub api.yourdomain.com
```

#### 6. 运行隧道

```bash
cloudflared tunnel run jobshub
```

或作为服务运行：
```bash
cloudflared service install
```

---

## 方案三：frp（需要有公网服务器）

### 前提条件
- 需要一台有公网IP的服务器（你的阿里云服务器）

### 服务器端配置

1. 在阿里云服务器上安装 frps：
```bash
wget https://github.com/fatedier/frp/releases/download/v0.52.0/frp_0.52.0_linux_amd64.tar.gz
tar -xzf frp_0.52.0_linux_amd64.tar.gz
cd frp_0.52.0_linux_amd64
```

2. 配置 `frps.ini`：
```ini
[common]
bind_port = 7000
token = your_secure_token_here
```

3. 启动服务：
```bash
./frps -c frps.ini
```

### 本地客户端配置

1. 下载 frpc：https://github.com/fatedier/frp/releases

2. 配置 `frpc.ini`：
```ini
[common]
server_addr = your_server_ip
server_port = 7000
token = your_secure_token_here

[jobshub-api]
type = http
local_ip = 127.0.0.1
local_port = 3000
custom_domains = api.yourdomain.com
```

3. 启动客户端：
```bash
frpc.exe -c frpc.ini
```

---

## 方案四：花生壳（国内用户友好）

### 优点
- ✅ 中文界面
- ✅ 国内访问快
- ✅ 简单易用

### 步骤

1. 访问：https://hsk.oray.com/
2. 注册账号
3. 下载客户端
4. 添加映射：
   - 内网主机：127.0.0.1
   - 内网端口：3000
   - 外网域名：自动分配

### 费用
- 免费版：1个映射，速度较慢
- 专业版：¥98/年，多个映射，速度快

---

## 🔧 配置前端连接

无论使用哪种方案，获得公网地址后，需要修改前端配置：

### 修改 Flutter 前端 API 地址

编辑 `D:\Project\JobsHub\JobsProject\lib\services\api_service.dart`：

```dart
class ApiService {
  // 替换为你的公网地址
  static const String baseUrl = 'https://your-public-url.com/api';
  
  // 例如 ngrok:
  // static const String baseUrl = 'https://xxxx.ngrok-free.app/api';
  
  // 例如 Cloudflare:
  // static const String baseUrl = 'https://api.yourdomain.com/api';
}
```

---

## 📊 方案对比

| 方案 | 难度 | 费用 | 稳定性 | 速度 | 推荐度 |
|------|------|------|--------|------|--------|
| ngrok | ⭐ | 免费/$8月 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Cloudflare Tunnel | ⭐⭐ | 免费 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| frp | ⭐⭐⭐ | 需服务器 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| 花生壳 | ⭐ | 免费/¥98年 | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

---

## 🎯 我的推荐

### 测试阶段
使用 **ngrok 免费版**
- 快速启动，5分钟搞定
- 适合开发测试

### 正式运营
使用 **Cloudflare Tunnel**
- 完全免费
- 固定域名
- 专业稳定

### 如果有阿里云服务器
使用 **frp**
- 完全掌控
- 无第三方依赖

---

## 🚀 快速开始（ngrok）

```bash
# 1. 安装 ngrok
choco install ngrok

# 2. 配置 token（从 https://dashboard.ngrok.com 获取）
ngrok config add-authtoken YOUR_TOKEN

# 3. 启动隧道
cd D:\Project\JobsHub\JobsProject-Backend
start-ngrok.bat

# 4. 复制显示的 URL，例如：
# https://xxxx.ngrok-free.app

# 5. 测试
curl https://xxxx.ngrok-free.app/api/health
```

---

## ⚠️ 注意事项

### 安全建议
1. **启用认证**：确保后台有JWT认证
2. **限制访问**：配置CORS只允许你的前端域名
3. **监控日志**：定期查看访问日志
4. **备份数据**：定期备份数据库

### 性能优化
1. **本地网络**：确保本地网络稳定
2. **带宽**：上传带宽至少5Mbps
3. **防火墙**：关闭不必要的防火墙规则

### 生产环境
- 内网穿透适合测试和小规模使用
- 正式运营建议使用云服务器
- 考虑负载均衡和高可用

---

## 📞 需要帮助？

如果遇到问题：
1. 检查本地服务是否运行：`curl http://localhost:3000/api/health`
2. 检查防火墙设置
3. 查看隧道工具日志
4. 测试网络连接

---

**最后更新**：2026-05-04
