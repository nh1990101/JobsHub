@echo off
echo ========================================
echo 下载 JDK 17 到 D:\Java\jdk-17
echo ========================================
echo.

REM 创建目录
if not exist "D:\Java" mkdir "D:\Java"
cd /d "D:\Java"

echo 正在下载 OpenJDK 17 (Eclipse Temurin)...
echo 下载地址: https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/x64/windows/
echo.

REM 使用清华镜像下载
curl -L -o jdk-17.zip "https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/x64/windows/OpenJDK17U-jdk_x64_windows_hotspot_17.0.12_7.zip"

if %errorlevel% neq 0 (
    echo 下载失败，请手动下载：
    echo https://adoptium.net/temurin/releases/?version=17
    pause
    exit /b 1
)

echo.
echo 正在解压...
tar -xf jdk-17.zip

REM 重命名目录
for /d %%i in (jdk-17*) do (
    if exist "jdk-17" rmdir /s /q "jdk-17"
    ren "%%i" "jdk-17"
)

del jdk-17.zip

echo.
echo ========================================
echo JDK 17 安装完成！
echo 安装路径: D:\Java\jdk-17
echo ========================================
echo.
echo 现在配置 Flutter 使用 JDK 17...
flutter config --jdk-dir="D:\Java\jdk-17"

echo.
echo 验证 Java 版本:
"D:\Java\jdk-17\bin\java.exe" -version

echo.
echo 完成！现在可以运行: flutter build apk --release
pause
