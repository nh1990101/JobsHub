# WhatsApp 号码保存问题修复

## 问题描述

在后台管理页面修改职位的WhatsApp号码后，重新打开该职位时，号码会被还原为默认值 `+8613800138000`。

## 根本原因

后端API的创建和更新职位路由中，**没有处理`whatsapp_phone`字段**：

### 问题代码

**创建职位（POST /api/jobs）：**
```javascript
const { title, description, ..., company_logo } = req.body;
// ❌ 缺少 whatsapp_phone

await connection.query(
  'INSERT INTO jobs (..., company_logo, created_at) VALUES (...)',
  [..., company_logo]  // ❌ 没有 whatsapp_phone
);
```

**更新职位（PUT /api/jobs/:id）：**
```javascript
const { title, description, ..., company_logo } = req.body;
// ❌ 缺少 whatsapp_phone

await connection.query(
  'UPDATE jobs SET ..., company_logo=?, updated_at=NOW() WHERE id=?',
  [..., company_logo, id]  // ❌ 没有 whatsapp_phone
);
```

### 导致的问题

1. **创建职位**：WhatsApp号码不会被保存到数据库
2. **更新职位**：修改的WhatsApp号码不会被保存
3. **数据库迁移**：所有职位都有默认值 `+8613800138000`
4. **重新打开**：读取到的是数据库中的默认值

## 解决方案

在创建和更新职位的API路由中添加`whatsapp_phone`字段处理。

### 修复后的代码

**创建职位：**
```javascript
const { title, description, ..., company_logo, whatsapp_phone } = req.body;
// ✅ 添加 whatsapp_phone

await connection.query(
  'INSERT INTO jobs (..., company_logo, whatsapp_phone, created_at) VALUES (?, ..., ?, NOW())',
  [..., company_logo, whatsapp_phone]  // ✅ 包含 whatsapp_phone
);
```

**更新职位：**
```javascript
const { title, description, ..., company_logo, whatsapp_phone } = req.body;
// ✅ 添加 whatsapp_phone

await connection.query(
  'UPDATE jobs SET ..., company_logo=?, whatsapp_phone=?, updated_at=NOW() WHERE id=?',
  [..., company_logo, whatsapp_phone, id]  // ✅ 包含 whatsapp_phone
);
```

## 测试步骤

### 1. 修改WhatsApp号码
1. 登录后台管理：http://localhost:3000/admin.html
2. 编辑任意职位
3. 修改WhatsApp号码为：`+8613912345678`
4. 保存

### 2. 验证保存成功
```bash
# 查询数据库
curl http://localhost:3000/api/jobs/1 | grep whatsappPhone
# 应该返回: "whatsappPhone":"+8613912345678"
```

### 3. 重新打开职位
1. 在后台管理页面重新编辑该职位
2. WhatsApp号码应该显示：`+8613912345678`
3. ✅ 不再被还原为默认值

## 修复时间

2026-05-05

## 状态

✅ 已完成并测试通过
