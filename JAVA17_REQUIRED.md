# Java 17 安装说明

## 问题
Android Gradle Plugin 8.x 需要 Java 17 才能运行，但当前系统使用的是 Java 11。

## 解决方案

### 方案1：下载并安装 Java 17（推荐）

1. 下载 Java 17：
   - Oracle JDK 17: https://www.oracle.com/java/technologies/downloads/#java17
   - 或 OpenJDK 17: https://adoptium.net/temurin/releases/?version=17
   
2. 安装到 D 盘（避免占用 C 盘空间），例如：
   ```
   D:\Java\jdk-17
   ```

3. 配置 Flutter 使用 Java 17：
   ```bash
   flutter config --jdk-dir="D:\Java\jdk-17"
   ```

4. 或者在 gradle.properties 中配置：
   ```
   org.gradle.java.home=D:\\Java\\jdk-17
   ```

### 方案2：使用在线 JDK（临时方案）

如果不想安装，可以让 Gradle 自动下载 JDK 17。

在 `android/gradle.properties` 中添加：
```
org.gradle.java.installations.auto-download=true
```

## 当前配置状态

- ✅ Gradle 镜像已配置（阿里云 + 腾讯云）
- ✅ Gradle 缓存目录已设置到 D:\gradle-cache
- ✅ Flutter SDK Gradle 插件已配置国内镜像
- ❌ 需要 Java 17

## 验证安装

安装完成后，运行以下命令验证：
```bash
flutter doctor -v
```

然后重新构建 APK：
```bash
flutter build apk --release
```
