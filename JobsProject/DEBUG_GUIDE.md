# JobHub 前端调试指南

## 🚀 前端应用启动状态

**应用状态:** ✅ 正在启动中...

**启动命令:**
```bash
cd D:/Project/JobsProject
flutter run -d chrome
```

**后台任务 ID:** `byy28sgzx`

## 📱 访问应用

当 Flutter 应用完全启动后，Chrome 浏览器会自动打开，通常访问地址为：
```
http://localhost:xxxxx
```

或者你可以在 Chrome 地址栏中查看 Flutter 应用的实际端口。

## 🔍 调试步骤

### 1. 等待应用启动
应用启动可能需要 30-60 秒，请耐心等待。你会看到：
```
Launching lib\main.dart on Chrome in debug mode...
Waiting for connection from debug service on Chrome...
```

### 2. 打开 Chrome DevTools
当应用启动后，按 `F12` 或右键 → "检查" 打开开发者工具

### 3. 查看控制台日志
在 DevTools 的 Console 标签中查看：
- API 请求日志
- 错误信息
- 数据加载状态

## 🎯 测试功能

### 测试国家选择
1. 应用启动后，你应该看到国家选择栏
2. 点击不同的国家按钮（中国、美国、日本等）
3. 观察职位列表是否更新

### 测试权重排序
1. 查看职位列表
2. 职位应该按权重从高到低排序
3. 权重高的职位应该显示在前面

### 测试数据加载
1. 打开 Chrome DevTools → Network 标签
2. 切换国家时，应该看到 API 请求
3. 请求 URL 应该是 `http://localhost:3000/api/jobs?country=X`

## 📊 预期结果

### 首次加载（国家 = 中国）
应该显示的职位：
- 全栈工程师 (权重: 80)
- UI/UX 设计师 (权重: 70)

### 切换到美国
应该显示的职位：
- DC (权重: 100)

## 🐛 常见问题

### 问题 1: 应用无法连接到后端
**症状:** 职位列表为空，控制台有错误信息
**解决方案:**
1. 确保后端服务正在运行：`npm run dev` (在 JobsProject-Backend 目录)
2. 检查后端是否在 `http://localhost:3000` 运行
3. 检查 CORS 配置是否正确

### 问题 2: 国家按钮不显示
**症状:** 看不到国家选择栏
**解决方案:**
1. 检查 Flutter 编译是否有错误
2. 刷新浏览器页面
3. 清除浏览器缓存

### 问题 3: 职位不按权重排序
**症状:** 职位顺序不对
**解决方案:**
1. 检查后端是否返回了权重数据
2. 检查前端 API Service 中的排序逻辑
3. 在浏览器 DevTools 中查看 API 响应

## 🔧 调试命令

### 查看后端服务状态
```bash
curl http://localhost:3000/api/health
```

### 测试职位 API
```bash
# 获取所有职位
curl http://localhost:3000/api/jobs

# 获取中国的职位
curl "http://localhost:3000/api/jobs?country=1"

# 获取美国的职位
curl "http://localhost:3000/api/jobs?country=2"
```

### 查看 Flutter 日志
在启动的 Flutter 应用中，按 `r` 进行热重载，按 `R` 进行热重启

## 📝 调试清单

- [ ] 后端服务正在运行 (`http://localhost:3000`)
- [ ] 前端应用已启动
- [ ] Chrome 浏览器已打开
- [ ] 可以看到国家选择栏
- [ ] 可以看到职位列表
- [ ] 职位按权重排序
- [ ] 切换国家时职位列表更新
- [ ] 没有控制台错误

## 🎉 成功标志

当你看到以下情况时，说明前端调试成功：
1. ✅ 应用在 Chrome 中正常显示
2. ✅ 看到国家选择栏（中国、美国、日本等）
3. ✅ 看到职位卡片列表
4. ✅ 职位按权重排序显示
5. ✅ 点击国家按钮时职位列表更新
6. ✅ 没有红色错误信息

---

**创建时间:** 2026-05-03
**应用状态:** 启动中...
