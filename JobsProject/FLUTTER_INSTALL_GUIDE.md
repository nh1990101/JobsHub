# Flutter 环境安装指南 (Windows)

## 系统要求

- **操作系统**: Windows 10 或更高版本
- **磁盘空间**: 至少 1.5 GB
- **已安装**: Git, Java JDK 8+

✅ 你已经有了: Git 2.38.1, Java 1.8.0

---

## 安装步骤

### 第一步：下载 Flutter SDK

1. **访问官方网站**
   ```
   https://flutter.dev/docs/get-started/install/windows
   ```

2. **下载最新版本**
   - 点击 "Download" 按钮
   - 选择 Windows 版本
   - 文件大小约 500MB

3. **或使用命令行下载** (需要 curl)
   ```bash
   # 创建下载目录
   mkdir C:\downloads
   cd C:\downloads
   
   # 下载 Flutter (这会花费几分钟)
   curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip -o flutter.zip
   ```

### 第二步：解压 Flutter

1. **解压到 C:\flutter**
   ```bash
   # 如果使用命令行
   cd C:\downloads
   tar -xf flutter.zip -C C:\
   
   # 或使用 Windows 资源管理器
   # 右键 flutter.zip → 解压到 → C:\
   ```

2. **验证解压成功**
   ```bash
   dir C:\flutter\bin
   ```
   应该看到 `flutter.bat` 文件

### 第三步：配置环境变量

#### 方法 A：使用 GUI（推荐）

1. **打开环境变量设置**
   - 按 `Win + X`，选择 "系统"
   - 或右键 "此电脑" → 属性
   - 点击 "高级系统设置"
   - 点击 "环境变量"

2. **新建用户变量**
   - 点击 "新建"
   - 变量名: `FLUTTER_HOME`
   - 变量值: `C:\flutter`
   - 点击 "确定"

3. **编辑 Path 变量**
   - 在 "系统变量" 中找到 `Path`
   - 点击 "编辑"
   - 点击 "新建"，添加: `C:\flutter\bin`
   - 点击 "新建"，添加: `C:\flutter\bin\cache\dart-sdk\bin`
   - 点击 "确定"

4. **重启电脑** (使环境变量生效)

#### 方法 B：使用命令行

```bash
# 以管理员身份打开 PowerShell

# 设置 FLUTTER_HOME
[Environment]::SetEnvironmentVariable("FLUTTER_HOME", "C:\flutter", "User")

# 添加到 Path
$path = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$path;C:\flutter\bin;C:\flutter\bin\cache\dart-sdk\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# 验证
echo $env:FLUTTER_HOME
echo $env:Path
```

### 第四步：验证安装

1. **打开新的命令行窗口** (重要！必须是新窗口才能读取新的环境变量)

2. **检查 Flutter 版本**
   ```bash
   flutter --version
   ```
   
   应该看到类似输出:
   ```
   Flutter 3.16.0 • channel stable
   Framework • revision 123abc456 (3 weeks ago)
   Engine • revision 789def012
   Tools • Dart 3.2.0
   ```

3. **运行诊断检查**
   ```bash
   flutter doctor
   ```
   
   这会检查所有依赖。输出示例:
   ```
   Doctor summary (to see all details, run flutter doctor -v):
   [✓] Flutter (Channel stable, 3.16.0, on Microsoft Windows [Version 10.0.19045])
   [✓] Windows Version (Installed version of Windows is version 10 or higher)
   [!] Android toolchain - develop for Android devices
       ✗ Android SDK not found.
   [✓] Chrome - develop for the web
   [✓] Visual Studio - develop for Windows
   [✓] Android Studio (not installed)
   [!] Connected device
       ✗ No devices found
   ```

---

## 修复常见问题

### 问题 1：flutter 命令找不到

**原因**: 环境变量未生效

**解决**:
```bash
# 1. 重启电脑
# 2. 或重启 IDE/编辑器
# 3. 或在新的命令行窗口中运行

# 验证环境变量
echo %FLUTTER_HOME%
echo %Path%
```

### 问题 2：Android SDK 未找到

**原因**: 需要安装 Android SDK

**解决**:
```bash
# 方法 1：使用 Android Studio (推荐)
# 下载: https://developer.android.com/studio
# 安装后会自动配置 Android SDK

# 方法 2：手动配置
# 1. 下载 Android SDK: https://developer.android.com/studio#downloads
# 2. 解压到 C:\Android\sdk
# 3. 设置环境变量 ANDROID_HOME = C:\Android\sdk
# 4. 添加到 Path: C:\Android\sdk\tools, C:\Android\sdk\platform-tools
```

### 问题 3：Dart SDK 版本不匹配

**解决**:
```bash
flutter upgrade
flutter pub get
```

---

## 安装 Android Studio (可选但推荐)

### 为什么需要?
- 提供 Android SDK 和模拟器
- 提供更好的 IDE 支持
- 可以在虚拟设备上测试应用

### 安装步骤

1. **下载**
   ```
   https://developer.android.com/studio
   ```

2. **安装**
   - 运行安装程序
   - 选择安装路径 (默认即可)
   - 选择安装组件 (选择 Android SDK, Android Emulator)

3. **配置**
   ```bash
   # 运行 flutter doctor 会自动配置
   flutter doctor
   
   # 同意 Android 许可证
   flutter doctor --android-licenses
   ```

---

## 快速启动项目

安装完成后，运行项目:

```bash
# 1. 进入项目目录
cd D:\Project\JobsProject

# 2. 获取依赖
flutter pub get

# 3. 列出可用设备
flutter devices

# 4. 运行应用
flutter run

# 或运行到特定设备
flutter run -d chrome        # Web 浏览器
flutter run -d windows       # Windows 桌面
flutter run -d android       # Android 模拟器/真机
```

---

## 常用命令

```bash
# 查看版本
flutter --version

# 诊断环境
flutter doctor

# 升级 Flutter
flutter upgrade

# 清理缓存
flutter clean

# 获取依赖
flutter pub get

# 运行应用
flutter run

# 构建发布版本
flutter build apk --release      # Android APK
flutter build appbundle --release # Android App Bundle
flutter build web --release      # Web
flutter build windows --release  # Windows
```

---

## 需要帮助?

如果遇到问题，运行:

```bash
flutter doctor -v
```

这会输出详细的诊断信息，可以帮助定位问题。

---

## 下一步

1. ✅ 安装 Flutter SDK
2. ✅ 配置环境变量
3. ✅ 验证安装 (`flutter doctor`)
4. 🔄 运行项目 (`flutter run`)
5. 🎨 修改 UI 和功能
6. 📦 构建发布版本

祝你开发愉快！🚀
