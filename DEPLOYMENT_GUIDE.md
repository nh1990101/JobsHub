# JobsHub 部署与上架指南

## 📋 目录
1. [后台部署到外网](#后台部署到外网)
2. [前端打包与上架Google Play](#前端打包与上架google-play)
3. [域名与SSL配置](#域名与ssl配置)
4. [数据库配置](#数据库配置)

---

## 🚀 后台部署到外网

### 方案选择

#### 方案一：云服务器部署（推荐）
**适合场景**：完全控制、长期运营

**推荐服务商**：
- 阿里云 ECS
- 腾讯云 CVM
- AWS EC2
- Google Cloud Compute Engine
- DigitalOcean Droplet

**配置建议**：
- CPU: 2核
- 内存: 4GB
- 硬盘: 40GB SSD
- 带宽: 5Mbps
- 操作系统: Ubuntu 22.04 LTS

**月费用**：约 $10-30 USD

#### 方案二：容器化部署
**适合场景**：快速部署、自动扩展

**推荐平台**：
- Railway.app（最简单）
- Render.com
- Fly.io
- Heroku

**月费用**：$5-20 USD

---

## 📦 后台部署步骤（云服务器方案）

### 第一步：准备服务器

```bash
# 1. 连接到服务器
ssh root@your-server-ip

# 2. 更新系统
apt update && apt upgrade -y

# 3. 安装 Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# 4. 安装 MySQL
apt install -y mysql-server

# 5. 安装 Nginx（反向代理）
apt install -y nginx

# 6. 安装 PM2（进程管理）
npm install -g pm2

# 7. 安装 Git
apt install -y git
```

### 第二步：配置 MySQL

```bash
# 1. 启动 MySQL
systemctl start mysql
systemctl enable mysql

# 2. 安全配置
mysql_secure_installation

# 3. 创建数据库和用户
mysql -u root -p

# 在 MySQL 中执行：
CREATE DATABASE jobshub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'jobshub_user'@'localhost' IDENTIFIED BY 'your_strong_password';
GRANT ALL PRIVILEGES ON jobshub.* TO 'jobshub_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 第三步：部署后台代码

```bash
# 1. 创建应用目录
mkdir -p /var/www/jobshub
cd /var/www/jobshub

# 2. 克隆代码（或上传代码）
git clone https://github.com/nh1990101/JobsHub.git .

# 3. 进入后台目录
cd JobsProject-Backend

# 4. 安装依赖
npm install --production

# 5. 创建 .env 文件
cat > .env << EOF
NODE_ENV=production
PORT=3000

# 数据库配置
DB_HOST=localhost
DB_USER=jobshub_user
DB_PASSWORD=your_strong_password
DB_NAME=jobshub

# JWT 密钥（生成一个强密钥）
JWT_SECRET=$(openssl rand -base64 32)

# 管理员邀请码（生成一个随机码）
ADMIN_INVITE_CODE=$(openssl rand -hex 16)
EOF

# 6. 初始化数据库
node init-db.js

# 7. 使用 PM2 启动应用
pm2 start src/server.js --name jobshub-api
pm2 save
pm2 startup
```

### 第四步：配置 Nginx 反向代理

```bash
# 1. 创建 Nginx 配置
cat > /etc/nginx/sites-available/jobshub << 'EOF'
server {
    listen 80;
    server_name api.yourdomain.com;  # 替换为你的域名

    # 限制请求体大小（用于上传图片）
    client_max_body_size 10M;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# 2. 启用配置
ln -s /etc/nginx/sites-available/jobshub /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

### 第五步：配置 SSL 证书（HTTPS）

```bash
# 1. 安装 Certbot
apt install -y certbot python3-certbot-nginx

# 2. 获取 SSL 证书
certbot --nginx -d api.yourdomain.com

# 3. 自动续期
certbot renew --dry-run
```

### 第六步：配置防火墙

```bash
# 1. 安装 UFW
apt install -y ufw

# 2. 配置规则
ufw allow ssh
ufw allow 'Nginx Full'
ufw enable
```

### 第七步：设置自动备份

```bash
# 1. 创建备份脚本
cat > /root/backup-jobshub.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# 备份数据库
mysqldump -u jobshub_user -pyour_strong_password jobshub > $BACKUP_DIR/jobshub_$DATE.sql

# 删除 30 天前的备份
find $BACKUP_DIR -name "jobshub_*.sql" -mtime +30 -delete
EOF

chmod +x /root/backup-jobshub.sh

# 2. 添加定时任务（每天凌晨 2 点备份）
crontab -e
# 添加：
0 2 * * * /root/backup-jobshub.sh
```

---

## 📱 前端打包与上架 Google Play

### 第一步：准备工作

#### 1. 注册 Google Play 开发者账号
- 访问：https://play.google.com/console
- 费用：$25 USD（一次性）
- 需要：Google 账号、信用卡

#### 2. 准备应用资料
- 应用名称：JobHub
- 应用图标：512x512 PNG（圆角）
- 功能图片：1024x500 PNG
- 截图：至少 2 张（手机和平板）
- 应用描述（简短和完整）
- 隐私政策 URL
- 分类：商务/招聘

### 第二步：配置前端 API 地址

```bash
# 1. 编辑 API 配置文件
cd D:\Project\JobsHub\JobsProject

# 2. 修改 lib/services/api_service.dart
```

```dart
class ApiService {
  // 生产环境 API 地址
  static const String baseUrl = 'https://api.yourdomain.com/api';
  
  // 开发环境可以用：
  // static const String baseUrl = 'http://localhost:3000/api';
  
  // ...
}
```

### 第三步：配置 Android 应用

#### 1. 修改应用 ID 和名称

编辑 `android/app/build.gradle.kts`：

```kotlin
android {
    namespace = "com.yourcompany.jobhub"  // 修改为你的包名
    compileSdk = 34
    
    defaultConfig {
        applicationId = "com.yourcompany.jobhub"  // 修改为你的包名
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }
}
```

#### 2. 修改应用名称

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<application
    android:label="JobHub"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

#### 3. 添加网络权限

确保 `AndroidManifest.xml` 中有：

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### 第四步：生成签名密钥

```bash
# 1. 生成密钥库
keytool -genkey -v -keystore D:\Project\JobsHub\jobhub-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias jobhub

# 按提示输入：
# - 密钥库密码（记住！）
# - 密钥密码（记住！）
# - 姓名、组织等信息
```

#### 创建密钥配置文件

创建 `android/key.properties`：

```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=jobhub
storeFile=D:/Project/JobsHub/jobhub-release-key.jks
```

**⚠️ 重要：不要将 key.properties 和 .jks 文件提交到 Git！**

#### 配置签名

编辑 `android/app/build.gradle.kts`，在 `android` 块中添加：

```kotlin
// 读取密钥配置
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

### 第五步：打包 APK/AAB

```bash
# 1. 清理构建
flutter clean

# 2. 获取依赖
flutter pub get

# 3. 构建 AAB（Google Play 推荐格式）
flutter build appbundle --release

# 输出位置：build/app/outputs/bundle/release/app-release.aab

# 4. 或构建 APK（用于测试）
flutter build apk --release

# 输出位置：build/app/outputs/flutter-apk/app-release.apk
```

### 第六步：测试 APK

```bash
# 1. 安装到测试设备
flutter install --release

# 2. 测试功能：
# - 用户注册/登录
# - 浏览职位列表
# - 查看职位详情
# - WhatsApp 跳转
# - 多语言切换
```

### 第七步：上传到 Google Play Console

#### 1. 创建应用

1. 登录 https://play.google.com/console
2. 点击"创建应用"
3. 填写应用名称、默认语言、应用类型
4. 声明应用是否为游戏、是否免费

#### 2. 填写应用内容

**应用访问权限**：
- 说明应用是否需要登录
- 提供测试账号（如果需要）

**广告**：
- 声明是否包含广告

**内容分级**：
- 填写问卷获得分级

**目标受众**：
- 选择目标年龄段

**新闻应用**：
- 声明是否为新闻应用

**数据安全**：
- 说明收集的数据类型
- 数据使用方式
- 数据安全措施

#### 3. 准备商店信息

**应用详情**：
- 应用名称：JobHub
- 简短描述（80 字符）：
  ```
  快速找到理想工作，连接全球招聘机会
  ```
- 完整描述（4000 字符）：
  ```
  JobHub 是一款专业的招聘求职应用，帮助求职者快速找到理想工作。

  主要功能：
  • 浏览海量职位信息
  • 按国家、年龄、性别筛选职位
  • 一键通过 WhatsApp 联系招聘方
  • 支持多语言界面
  • 简洁直观的用户体验

  为什么选择 JobHub？
  • 真实可靠的职位信息
  • 快速响应的招聘流程
  • 全球化的工作机会
  • 完全免费使用

  立即下载 JobHub，开启你的职业新篇章！
  ```

**图形资源**：
- 应用图标：512x512 PNG
- 功能图片：1024x500 PNG
- 手机截图：至少 2 张（1080x1920 或 1440x2560）
- 7 英寸平板截图：至少 2 张（可选）
- 10 英寸平板截图：至少 2 张（可选）

**分类**：
- 应用类别：商务
- 标签：招聘、求职、工作

**联系方式**：
- 电子邮件地址
- 网站（可选）
- 电话号码（可选）

**隐私政策**：
- 必须提供隐私政策 URL

#### 4. 创建版本

1. 进入"生产"轨道
2. 点击"创建新版本"
3. 上传 AAB 文件（app-release.aab）
4. 填写版本说明：
   ```
   首次发布
   - 浏览职位列表
   - 查看职位详情
   - WhatsApp 快速联系
   - 多语言支持
   ```
5. 保存并审核

#### 5. 提交审核

1. 检查所有必填项
2. 点击"发送以供审核"
3. 等待审核（通常 1-7 天）

---

## 🌐 域名与 SSL 配置

### 购买域名

**推荐域名注册商**：
- Namecheap
- GoDaddy
- 阿里云（万网）
- 腾讯云

**域名建议**：
- 主域名：jobhub.com（或其他）
- API 子域名：api.jobhub.com
- 管理后台：admin.jobhub.com

### DNS 配置

```
类型    主机记录    记录值
A       api        your-server-ip
A       admin      your-server-ip
A       @          your-server-ip
```

---

## 🗄️ 数据库配置

### 生产环境优化

编辑 MySQL 配置 `/etc/mysql/mysql.conf.d/mysqld.cnf`：

```ini
[mysqld]
# 基本配置
max_connections = 200
max_allowed_packet = 64M

# 性能优化
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2

# 字符集
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# 慢查询日志
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
```

重启 MySQL：
```bash
systemctl restart mysql
```

---

## 📊 监控与维护

### 服务器监控

```bash
# 1. 查看应用状态
pm2 status
pm2 logs jobshub-api

# 2. 查看系统资源
htop
df -h
free -h

# 3. 查看 Nginx 日志
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### 应用更新

```bash
# 1. 拉取最新代码
cd /var/www/jobshub
git pull

# 2. 更新依赖
cd JobsProject-Backend
npm install --production

# 3. 重启应用
pm2 restart jobshub-api
```

---

## ✅ 部署检查清单

### 后台部署
- [ ] 服务器已购买并配置
- [ ] MySQL 已安装并配置
- [ ] 代码已部署
- [ ] .env 文件已配置
- [ ] 数据库已初始化
- [ ] PM2 已启动应用
- [ ] Nginx 已配置反向代理
- [ ] SSL 证书已安装
- [ ] 防火墙已配置
- [ ] 自动备份已设置
- [ ] 域名已解析
- [ ] API 可以访问

### 前端上架
- [ ] Google Play 开发者账号已注册
- [ ] API 地址已更新为生产环境
- [ ] 应用 ID 和名称已修改
- [ ] 签名密钥已生成
- [ ] AAB 文件已构建
- [ ] 应用已测试
- [ ] 应用图标和截图已准备
- [ ] 应用描述已撰写
- [ ] 隐私政策已发布
- [ ] 应用已上传到 Google Play Console
- [ ] 所有必填项已完成
- [ ] 应用已提交审核

---

## 🆘 常见问题

### Q1: 服务器连接不上？
- 检查防火墙规则
- 检查安全组配置
- 确认 SSH 端口是否开放

### Q2: 数据库连接失败？
- 检查 .env 配置
- 确认 MySQL 服务运行中
- 检查数据库用户权限

### Q3: Nginx 502 错误？
- 检查后台应用是否运行：`pm2 status`
- 查看应用日志：`pm2 logs`
- 检查端口是否被占用

### Q4: SSL 证书获取失败？
- 确认域名已正确解析
- 检查 80 端口是否开放
- 确认 Nginx 配置正确

### Q5: Google Play 审核被拒？
- 仔细阅读拒绝原因
- 检查隐私政策是否完整
- 确认应用符合 Google Play 政策
- 修改后重新提交

---

## 📞 技术支持

如有问题，请查阅：
- Flutter 官方文档：https://flutter.dev/docs
- Node.js 文档：https://nodejs.org/docs
- Google Play Console 帮助：https://support.google.com/googleplay/android-developer

---

**最后更新**：2026-05-04
