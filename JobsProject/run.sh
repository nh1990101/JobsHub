#!/bin/bash
# Flutter 项目快速启动脚本 (Windows Git Bash)

set -e

echo ""
echo "========================================"
echo "  JobHub - Flutter 项目启动脚本"
echo "========================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Flutter
echo -e "${YELLOW}[1/5] 检查 Flutter 环境...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter 未安装${NC}"
    echo ""
    echo "请按照以下步骤安装 Flutter:"
    echo "1. 访问: https://flutter.dev/docs/get-started/install/windows"
    echo "2. 下载 Flutter SDK 并解压到 C:\\flutter"
    echo "3. 配置环境变量 (FLUTTER_HOME 和 Path)"
    echo "4. 重启电脑或命令行窗口"
    echo ""
    echo "或查看详细指南: FLUTTER_INSTALL_GUIDE.md"
    exit 1
fi
echo -e "${GREEN}✅ Flutter 已安装${NC}"
flutter --version

# 检查 Dart
echo ""
echo -e "${YELLOW}[2/5] 检查 Dart 环境...${NC}"
if ! command -v dart &> /dev/null; then
    echo -e "${RED}❌ Dart 未安装${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Dart 已安装${NC}"
dart --version

# 进入项目目录
echo ""
echo -e "${YELLOW}[3/5] 进入项目目录...${NC}"
cd "$(dirname "$0")"
echo -e "${GREEN}✅ 当前目录: $(pwd)${NC}"

# 获取依赖
echo ""
echo -e "${YELLOW}[4/5] 获取项目依赖...${NC}"
flutter pub get
echo -e "${GREEN}✅ 依赖获取完成${NC}"

# 列出可用设备
echo ""
echo -e "${YELLOW}[5/5] 检查可用设备...${NC}"
flutter devices
echo ""

# 提示用户选择运行方式
echo -e "${GREEN}========================================"
echo "  准备就绪！选择运行方式:"
echo "========================================${NC}"
echo ""
echo "1. flutter run              (自动选择设备)"
echo "2. flutter run -d chrome    (Web 浏览器)"
echo "3. flutter run -d windows   (Windows 桌面)"
echo "4. flutter run -d android   (Android 模拟器/真机)"
echo ""
echo "直接运行命令或按 Ctrl+C 退出"
echo ""

# 默认运行
read -p "选择 (默认 1): " choice
choice=${choice:-1}

case $choice in
    1)
        flutter run
        ;;
    2)
        flutter run -d chrome
        ;;
    3)
        flutter run -d windows
        ;;
    4)
        flutter run -d android
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac
