# Android APK 打包指南

## 📦 最新构建记录

**构建时间：** 2026-05-06  
**构建结果：** ✅ 成功  
**APK路径：** `D:\Project\JobsHub\JobsProject\build\app\outputs\flutter-apk\app-release.apk`  
**APK大小：** 50.1MB  
**构建类型：** Release（发布版）

---

## 🚀 快速打包命令

```bash
cd D:\Project\JobsHub\JobsProject
export GRADLE_USER_HOME=D:/gradle-cache
flutter build apk --release
```

**APK输出位置：** `build\app\outputs\flutter-apk\app-release.apk`

---

## ⚙️ 环境配置（已完成）

### 1. JDK 17
- **安装路径：** `D:\Java\jdk-17`
- **版本：** OpenJDK 17.0.12+7 (Temurin)
- **配置命令：** `flutter config --jdk-dir="D:\Java\jdk-17"`
- **验证：** `D:\Java\jdk-17\bin\java -version`

### 2. Gradle 配置
- **Gradle版本：** 8.14
- **缓存目录：** `D:\gradle-cache`（避免占用C盘）
- **镜像源：** 腾讯云镜像（gradle-wrapper.properties）
- **Android Gradle Plugin：** 8.11.1
- **Kotlin版本：** 2.2.20

### 3. Android SDK
- **SDK路径：** `C:\Program Files (x86)\Android\android-sdk`
- **许可证：** 已接受所有许可证
- **NDK版本：** 28.2.13676358
- **Build Tools：** 35.0.0
- **Platform：** Android 33, 36

---

## 🔧 关键配置文件

### android/gradle.properties
```properties
org.gradle.jvmargs=-Xmx2G -XX:MaxMetaspaceSize=1G
android.useAndroidX=true
android.enableJetifier=true
android.compileSdk=34
android.minSdk=21
android.targetSdk=34

# Gradle缓存到D盘
org.gradle.caching=true
org.gradle.daemon=true
org.gradle.parallel=true
GRADLE_USER_HOME=D:\\gradle-cache

# 自动下载JDK
org.gradle.java.installations.auto-download=true

# 禁用Kotlin增量编译（避免C盘/D盘路径冲突）
kotlin.incremental=false
```

### android/gradle/wrapper/gradle-wrapper.properties
```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-8.14-all.zip
```

### android/app/build.gradle.kts
```kotlin
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

android {
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
}
```

---

## 🐛 已解决的问题

### 问题1：Java版本不匹配
**错误：** `Android Gradle plugin requires Java 17 to run. You are currently using Java 11.`

**解决方案：**
1. 下载 OpenJDK 17 到 `D:\Java\jdk-17`
2. 配置 Flutter：`flutter config --jdk-dir="D:\Java\jdk-17"`
3. 在 `build.gradle.kts` 中配置 Java 17 工具链

### 问题2：Android SDK 许可证未接受
**错误：** `Failed to install the following Android SDK packages as some licences have not been accepted.`

**解决方案：**
```bash
export JAVA_HOME="D:/Java/jdk-17"
export PATH="$JAVA_HOME/bin:$PATH"
yes | cmd.exe /c "\"C:\Program Files (x86)\Android\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat\" --licenses"
```

### 问题3：dart:html 在 Android 平台不可用
**错误：** `Dart library 'dart:html' is not available on this platform.`

**原因：** `chat_screen.dart` 中使用了 Web 专用的 `dart:html`

**解决方案：**
```dart
// 移除
import 'dart:html' as html;

// 改用 url_launcher（支持所有平台）
final uri = Uri.parse(whatsappUrl);
if (await canLaunchUrl(uri)) {
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
```

### 问题4：Kotlin 增量编译路径冲突
**错误：** `this and base files have different roots: C:\Users\...\Pub\Cache and D:\Project\JobsHub`

**原因：** 项目在D盘，Pub缓存在C盘，Kotlin增量编译无法处理跨盘符路径

**解决方案：**
在 `gradle.properties` 中添加：
```properties
kotlin.incremental=false
```

### 问题5：网络下载失败（502 Bad Gateway）
**错误：** `Could not HEAD 'https://storage.flutter-io.cn/...' Received status code 502`

**解决方案：**
- Flutter 会自动重试（Retrying Gradle Build）
- 通常第二次尝试会成功
- 如果持续失败，可以配置国内镜像源

---

## 📝 打包流程总结

### 首次打包（需要配置环境）

1. **安装 JDK 17**
   ```bash
   # 下载并解压到 D:\Java\jdk-17
   flutter config --jdk-dir="D:\Java\jdk-17"
   ```

2. **接受 Android SDK 许可证**
   ```bash
   export JAVA_HOME="D:/Java/jdk-17"
   yes | cmd.exe /c "sdkmanager.bat --licenses"
   ```

3. **配置 Gradle**
   - 修改 `gradle.properties`（见上文）
   - 修改 `gradle-wrapper.properties`（使用镜像源）
   - 配置 Java 17 工具链

4. **修复代码问题**
   - 移除 `dart:html` 依赖
   - 使用跨平台的 `url_launcher`

5. **构建 APK**
   ```bash
   flutter clean
   export GRADLE_USER_HOME=D:/gradle-cache
   flutter build apk --release
   ```

### 后续打包（环境已配置）

```bash
cd D:\Project\JobsHub\JobsProject
export GRADLE_USER_HOME=D:/gradle-cache
flutter build apk --release
```

**构建时间：** 约 3-5 分钟（首次更长，后续有缓存会更快）

---

## 🔍 验证与测试

### 验证 APK
```bash
# 查看 APK 信息
aapt dump badging build/app/outputs/flutter-apk/app-release.apk

# 检查文件大小
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

### 安装到设备
```bash
# 通过 ADB 安装
adb install build/app/outputs/flutter-apk/app-release.apk

# 或直接复制 APK 到手机安装
```

---

## 📌 注意事项

1. **Java 版本：** 必须使用 Java 17，Java 11 不支持 Android Gradle Plugin 8.x
2. **Gradle 缓存：** 配置到 D 盘避免占用 C 盘空间
3. **Kotlin 增量编译：** 必须禁用，否则会因为跨盘符路径失败
4. **网络问题：** 如果遇到 502 错误，等待 Flutter 自动重试即可
5. **清理缓存：** 如果构建失败，先运行 `flutter clean` 清理缓存
6. **Gradle 守护进程：** 如果遇到锁定问题，运行 `./gradlew --stop` 停止守护进程

---

## 🛠️ 故障排查

### 构建失败时的检查清单

1. ✅ Java 版本是否为 17？
   ```bash
   flutter doctor -v
   ```

2. ✅ Android SDK 许可证是否已接受？
   ```bash
   sdkmanager --licenses
   ```

3. ✅ Gradle 缓存是否正常？
   ```bash
   export GRADLE_USER_HOME=D:/gradle-cache
   cd android && ./gradlew --stop
   ```

4. ✅ 是否有文件被锁定？
   ```bash
   taskkill //F //IM java.exe
   flutter clean
   ```

5. ✅ 网络是否正常？
   - 检查是否能访问 Maven 仓库
   - 等待 Flutter 自动重试

---

## 📚 相关文档

- [Flutter 官方文档 - 构建和发布 Android 应用](https://flutter.dev/docs/deployment/android)
- [Android Gradle Plugin 发布说明](https://developer.android.com/studio/releases/gradle-plugin)
- [Gradle 官方文档](https://docs.gradle.org/)

---

## 🔄 更新记录

### 2026-05-06
- ✅ 首次成功构建 APK
- ✅ 配置 JDK 17 环境
- ✅ 解决 Kotlin 增量编译路径问题
- ✅ 修复 dart:html 平台兼容性问题
- ✅ 配置 Gradle 使用 D 盘缓存
- ✅ APK 大小：50.1MB

---

**最后更新：** 2026-05-06  
**维护者：** Claude (Opus 4.7)
