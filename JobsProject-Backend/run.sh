#!/bin/bash

# JobHub 后台启动脚本

echo ""
echo "===================================="
echo "  JobHub API 服务启动脚本"
echo "===================================="
echo ""

# 检查 Node.js 是否安装
if ! command -v node &> /dev/null; then
    echo "❌ 错误：未找到 Node.js，请先安装 Node.js"
    exit 1
fi

# 检查依赖是否已安装
if [ ! -d "node_modules" ]; then
    echo "📦 正在安装依赖..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ 依赖安装失败"
        exit 1
    fi
fi

# 检查 .env 文件
if [ ! -f ".env" ]; then
    echo "⚠️  未找到 .env 文件，正在复制 .env.example..."
    cp .env.example .env
    echo "✓ 已创建 .env 文件，请修改数据库配置"
fi

echo ""
echo "✓ 环境检查完成"
echo ""
echo "启动选项："
echo "1. 开发模式（自动重启）"
echo "2. 生产模式"
echo ""

read -p "请选择启动模式 (1 或 2): " choice

case $choice in
    1)
        echo ""
        echo "🚀 启动开发服务器..."
        npm run dev
        ;;
    2)
        echo ""
        echo "🚀 启动生产服务器..."
        npm start
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac
