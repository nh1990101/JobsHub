# 快速开始指南

## 📋 前置条件检查

你的系统已有:
- ✅ Git 2.38.1
- ✅ Java 1.8.0
- ❌ Flutter (需要安装)
- ❌ Android SDK (可选)

---

## 🚀 快速安装 (5 分钟)

### 步骤 1：下载 Flutter SDK

**选项 A：手动下载 (推荐)**
1. 访问: https://flutter.dev/docs/get-started/install/windows
2. 点击 "Download" 下载 Windows 版本
3. 解压到 `C:\flutter`

**选项 B：命令行下载**
```bash
# 创建下载目录
mkdir C:\downloads
cd C:\downloads

# 下载 (约 500MB，需要几分钟)
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip -o flutter.zip

# 解压
tar -xf flutter.zip -C C:\
```

### 步骤 2：配置环境变量

**方法 A：GUI (推荐)**
1. 按 `Win + X` → 选择 "系统"
2. 点击 "高级系统设置"
3. 点击 "环境变量"
4. 新建用户变量:
   - 名称: `FLUTTER_HOME`
   - 值: `C:\flutter`
5. 编辑 `Path` 变量，添加:
   - `C:\flutter\bin`
   - `C:\flutter\bin\cache\dart-sdk\bin`
6. 点击 "确定"，**重启电脑**

**方法 B：PowerShell (管理员)**
```powershell
[Environment]::SetEnvironmentVariable("FLUTTER_HOME", "C:\flutter", "User")
$path = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$path;C:\flutter\bin;C:\flutter\bin\cache\dart-sdk\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

### 步骤 3：验证安装

**打开新的命令行窗口**，运行:
```bash
flutter --version
flutter doctor
```

应该看到:
```
Flutter 3.16.0 • channel stable
Framework • revision 123abc456
Engine • revision 789def012
Tools • Dart 3.2.0
```

---

## ▶️ 运行项目

### 方法 1：使用启动脚本 (最简单)

**Windows:**
```bash
# 双击运行
D:\Project\JobsProject\run.bat

# 或在命令行运行
cd D:\Project\JobsProject
run.bat
```

**Git Bash:**
```bash
cd D:\Project\JobsProject
bash run.sh
```

### 方法 2：手动运行

```bash
# 1. 进入项目目录
cd D:\Project\JobsProject

# 2. 获取依赖
flutter pub get

# 3. 运行应用
flutter run

# 或指定平台
flutter run -d chrome      # Web
flutter run -d windows     # Windows
flutter run -d android     # Android
```

### 方法 3：使用 IDE

**Android Studio:**
1. File → Open → `D:\Project\JobsProject`
2. 等待 Gradle 同步
3. 点击 "Run" 按钮

**VS Code:**
1. File → Open Folder → `D:\Project\JobsProject`
2. 按 `F5` 运行

---

## 🔧 常见问题

### Q1: flutter 命令找不到

**A:** 
1. 确保 Flutter 解压到 `C:\flutter`
2. 确保环境变量正确设置
3. **重启电脑** 使环境变量生效
4. 在新的命令行窗口中运行

### Q2: 需要 Android SDK 吗?

**A:** 
- 如果只想在 Web 或 Windows 上运行: 不需要
- 如果想在 Android 上运行: 需要
- 安装 Android Studio 会自动配置 Android SDK

### Q3: 如何在 Android 手机上运行?

**A:**
1. 启用手机的 USB 调试 (设置 → 开发者选项)
2. 用 USB 连接手机到电脑
3. 运行: `flutter run -d android`

### Q4: 如何在 Web 上运行?

**A:**
```bash
flutter run -d chrome
```

### Q5: 如何清理缓存?

**A:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📚 详细文档

- **完整安装指南**: `FLUTTER_INSTALL_GUIDE.md`
- **项目说明**: `README.md`
- **项目代码**: `lib/` 目录

---

## 🎯 下一步

1. ✅ 安装 Flutter
2. ✅ 验证环境 (`flutter doctor`)
3. ▶️ 运行项目 (`flutter run`)
4. 🎨 修改 UI 和功能
5. 📦 构建发布版本

---

## 💡 提示

- 首次运行会下载依赖，可能需要 5-10 分钟
- 使用 `flutter run` 后，按 `r` 热重载，按 `q` 退出
- 在 IDE 中运行会有更好的调试体验

---

## 需要帮助?

运行诊断命令查看详细信息:
```bash
flutter doctor -v
```

祝你开发愉快！🚀
