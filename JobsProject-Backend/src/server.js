require('dotenv').config();

console.log('🚀🚀🚀 SERVER.JS STARTING 🚀🚀🚀');

// 立即执行的测试代码
const fs = require('fs');
const testFile = require('path').join(__dirname, '..', 'test-execution.txt');
fs.writeFileSync(testFile, 'Server.js 已执行于 ' + new Date().toISOString() + '\n');

// 写入调试文件
const debugFile = require('path').join(__dirname, '..', 'debug-startup.txt');
fs.writeFileSync(debugFile, 'DEBUG: Server.js started at ' + new Date().toISOString() + '\n');

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcryptjs = require('bcryptjs');
const mysql = require('mysql2/promise');
const path = require('path');

const app = express();

// 日志文件
const logFile = path.join(__dirname, '..', 'server.log');
const log = (msg) => {
  const timestamp = new Date().toISOString();
  const logMsg = `[${timestamp}] ${msg}\n`;
  console.log(logMsg);
  fs.appendFileSync(logFile, logMsg);
};

// ============ MySQL 连接池 ============
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'jobshub',
  waitForConnections: true,
  connectionLimit: 20,
  queueLimit: 0,
  connectTimeout: 10000,
  acquireTimeout: 10000,
  timeout: 10000,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
});

// 数据库连接错误处理
pool.on('error', (err) => {
  console.error('数据库连接池错误:', err);
  if (err.code === 'PROTOCOL_CONNECTION_LOST') {
    console.log('数据库连接丢失，连接池会自动重连');
  }
});

// 安全的数据库操作辅助函数
async function withConnection(callback) {
  let connection;
  try {
    connection = await pool.getConnection();
    const result = await callback(connection);
    return result;
  } catch (error) {
    throw error;
  } finally {
    if (connection) {
      connection.release();
    }
  }
}

// ============ 中间件 ============
// 手动CORS配置 - 完全控制
app.use((req, res, next) => {
  const origin = req.headers.origin;

  // 允许的来源
  const allowedOrigins = [
    'http://localhost:54884',
    'http://localhost:3000',
    'http://127.0.0.1:54884',
    'http://127.0.0.1:3000',
  ];

  // 检查origin是否匹配正则
  const isLocalhost = origin && /^http:\/\/localhost:\d+$/.test(origin);
  const is127 = origin && /^http:\/\/127\.0\.0\.1:\d+$/.test(origin);
  const isNgrok = origin && /^https:\/\/.*\.ngrok-free\.dev$/.test(origin);
  const isCloudflare = origin && /^https:\/\/.*\.trycloudflare\.com$/.test(origin);

  if (origin && (allowedOrigins.includes(origin) || isLocalhost || is127 || isNgrok || isCloudflare)) {
    res.header('Access-Control-Allow-Origin', origin);
  } else if (!origin) {
    res.header('Access-Control-Allow-Origin', '*');
  } else {
    console.log('⚠️  CORS origin:', origin);
    res.header('Access-Control-Allow-Origin', origin); // 开发环境允许所有
  }

  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, ngrok-skip-browser-warning');
  res.header('Access-Control-Allow-Credentials', 'true');
  res.header('Access-Control-Expose-Headers', 'ngrok-skip-browser-warning');
  res.header('ngrok-skip-browser-warning', 'true');

  // 处理预检请求
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }

  next();
});

// 请求超时中间件
app.use((req, res, next) => {
  req.setTimeout(30000); // 30秒超时
  res.setTimeout(30000);
  next();
});

app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

// ============ JWT 工具 ============
const generateToken = (userId) => {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET || 'jobshub_jwt_secret_key_2025',
    { expiresIn: process.env.JWT_EXPIRE || '7d' }
  );
};

const verifyToken = (token) => {
  try {
    return jwt.verify(token, process.env.JWT_SECRET || 'jobshub_jwt_secret_key_2025');
  } catch (error) {
    return null;
  }
};

// ============ 认证中间件 ============
const authMiddleware = async (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: '缺少认证令牌' });
  }

  const decoded = verifyToken(token);
  if (!decoded) {
    return res.status(401).json({ error: '无效或过期的令牌' });
  }

  try {
    const connection = await pool.getConnection();
    const [users] = await connection.query('SELECT * FROM users WHERE id = ?', [decoded.userId]);
    connection.release();

    if (users.length === 0) {
      return res.status(401).json({ error: '用户不存在' });
    }

    req.userId = decoded.userId;
    req.user = users[0];
    next();
  } catch (error) {
    console.error('Auth middleware error:', error);
    res.status(500).json({ error: '认证失败' });
  }
};

// ============ 管理员中间件 ============
const adminMiddleware = (req, res, next) => {
  if (req.user?.role !== 'admin' && req.user?.role !== 'super_admin') {
    return res.status(403).json({ error: '需要管理员权限' });
  }
  next();
};

// ============ 静态文件服务 ============
const staticPath = path.join(__dirname, '..');
const flutterWebPath = path.join(__dirname, '..', '..', 'JobsProject', 'build', 'web');
console.log('📁 静态文件目录:', staticPath);
console.log('📱 Flutter Web目录:', flutterWebPath);

// Flutter Web 应用 (优先级最高)
app.use(express.static(flutterWebPath));

// 测试路由
app.get('/test-static', (req, res) => {
  res.send('静态路由工作正常！');
});

// 明确的管理后台路由
app.get('/admin.html', (req, res) => {
  const filePath = path.join(staticPath, 'admin.html');
  console.log('📄 请求 admin.html, 文件路径:', filePath);
  res.sendFile(filePath, (err) => {
    if (err) {
      console.error('❌ 发送文件失败:', err);
      res.status(500).send('文件发送失败');
    }
  });
});

// 其他静态文件
app.use(express.static(staticPath));

// ============ 健康检查 ============
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'JobHub API is running' });
});

// ============ 测试端点 ============
app.get('/api/test', (req, res) => {
  res.json({ message: 'Test endpoint works' });
});

// 测试路由
app.get('/api/test-route', (req, res) => {
  const fs = require('fs');
  const debugFile = require('path').join(__dirname, '..', 'test-route-called.txt');
  fs.appendFileSync(debugFile, `[${new Date().toISOString()}] Test route called\n`);
  res.json({ message: 'Test route works' });
});

// ============ 辅助函数 ============

// 将数据库字段名（snake_case）转换为前端字段名（camelCase）
// 同时保留原始字段名以兼容后台管理页面
const convertJobToFrontend = (job) => {
  if (!job) return null;
  return {
    id: job.id,
    title: job.title,
    description: job.description,
    requirements: job.requirements,
    companyName: job.company_name,
    company_name: job.company_name,  // 兼容后台
    companyLogo: job.company_logo,
    company_logo: job.company_logo,  // 兼容后台
    location: job.location,
    salary: job.salary,
    ageRange: job.age_range,
    age_range: job.age_range,  // 兼容后台
    genderRequirement: job.gender_requirement,
    gender_requirement: job.gender_requirement,  // 兼容后台
    weight: job.weight,
    countryId: job.country_id,
    country_id: job.country_id,  // 兼容后台
    whatsappPhone: job.whatsapp_phone,
    whatsapp_phone: job.whatsapp_phone,  // 兼容后台
    createdAt: job.created_at,
    created_at: job.created_at,  // 兼容后台
    updatedAt: job.updated_at,
    updated_at: job.updated_at,  // 兼容后台
  };
};

// ============ 认证路由 ============

// 用户注册
app.post('/api/auth/register', async (req, res) => {
  try {
    const { email, password, name } = req.body;

    if (!email || !password || !name) {
      return res.status(400).json({ error: '邮箱、密码和名字不能为空' });
    }

    const connection = await pool.getConnection();
    const [existingUsers] = await connection.query('SELECT id FROM users WHERE email = ?', [email]);

    if (existingUsers.length > 0) {
      connection.release();
      return res.status(400).json({ error: '邮箱已被注册' });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);
    await connection.query(
      'INSERT INTO users (email, password, name, role, created_at) VALUES (?, ?, ?, ?, NOW())',
      [email, hashedPassword, name, 'user']
    );

    connection.release();

    res.json({ message: '注册成功' });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ error: '注册失败' });
  }
});

// 后台管理员注册
app.post('/api/auth/register-admin', async (req, res) => {
  const fs = require('fs');
  const path = require('path');

  try {
    const { email, password, name, invite_code } = req.body;

    if (!email || !password || !name || !invite_code) {
      return res.status(400).json({ error: '邮箱、密码、名字和邀请码不能为空' });
    }

    const connection = await pool.getConnection();

    // 验证邀请码
    const [invites] = await connection.query('SELECT * FROM invites WHERE code = ?', [invite_code]);

    if (invites.length === 0) {
      connection.release();
      return res.status(400).json({ error: '邀请码无效' });
    }

    const invite = invites[0];

    if (invite.used) {
      connection.release();
      return res.status(400).json({ error: '邀请码已被使用' });
    }

    if (new Date(invite.expires_at) < new Date()) {
      connection.release();
      return res.status(400).json({ error: '邀请码已过期' });
    }

    // 检查邮箱是否已存在
    const [existingUsers] = await connection.query('SELECT id FROM users WHERE email = ?', [email]);

    if (existingUsers.length > 0) {
      connection.release();
      return res.status(400).json({ error: '邮箱已被注册' });
    }

    // 创建新用户（初始角色为普通用户，需要管理员分配权限）
    const hashedPassword = await bcryptjs.hash(password, 8);
    const insertResult = await connection.query(
      'INSERT INTO users (email, password, name, role, created_at) VALUES (?, ?, ?, ?, NOW())',
      [email, hashedPassword, name, 'user']
    );

    // 确保角色被设置为 'user'
    const userId = insertResult[0].insertId;
    await connection.query('UPDATE users SET role = ? WHERE id = ?', ['user', userId]);

    // 标记邀请码为已使用
    await connection.query('UPDATE invites SET used = 1, used_by = LAST_INSERT_ID(), used_at = NOW() WHERE code = ?', [invite_code]);

    connection.release();

    res.json({ message: '注册成功' });
  } catch (error) {
    console.error('Register admin error:', error);
    res.status(500).json({ error: '注册失败: ' + error.message });
  }
});

// 应用用户注册
app.post('/api/app-users/register', async (req, res) => {
  try {
    const { device_id, name, email, phone, age, gender, country_id, ip_address } = req.body;

    if (!device_id || !name) {
      return res.status(400).json({ error: '设备ID和名字不能为空' });
    }

    const connection = await pool.getConnection();
    const [existingUsers] = await connection.query('SELECT id FROM app_users WHERE device_id = ?', [device_id]);

    if (existingUsers.length > 0) {
      connection.release();
      return res.status(400).json({ error: '该设备已注册' });
    }

    const result = await connection.query(
      'INSERT INTO app_users (device_id, name, email, phone, age, gender, country_id, ip_address, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())',
      [device_id, name, email || null, phone || null, age || null, gender || null, country_id || null, ip_address || null]
    );

    connection.release();

    res.status(201).json({
      message: '注册成功',
      user_id: result[0].insertId
    });
  } catch (error) {
    console.error('App user register error:', error);
    res.status(500).json({ error: '注册失败: ' + error.message });
  }
});

// 用户登录
app.post('/api/auth/login', async (req, res) => {
  log('📝 收到登录请求');
  log('请求体: ' + JSON.stringify(req.body));

  try {
    const { email, password } = req.body;
    log('邮箱: ' + email);

    if (!email || !password) {
      log('❌ 邮箱或密码为空');
      return res.status(400).json({ error: '邮箱和密码不能为空' });
    }

    log('🔌 获取数据库连接...');
    const connection = await pool.getConnection();
    log('✓ 已获取连接');

    log('🔍 查询用户...');
    const [users] = await connection.query('SELECT * FROM users WHERE email = ?', [email]);
    log('✓ 查询完成，找到 ' + users.length + ' 个用户');

    connection.release();
    log('✓ 连接已释放');

    if (users.length === 0) {
      log('❌ 用户不存在');
      return res.status(401).json({ error: '邮箱或密码错误' });
    }

    const user = users[0];
    log('✓ 用户: ' + user.email);

    log('🔐 验证密码...');
    const passwordMatch = await bcryptjs.compare(password, user.password);
    log('✓ 密码匹配: ' + passwordMatch);

    if (!passwordMatch) {
      log('❌ 密码不匹配');
      return res.status(401).json({ error: '邮箱或密码错误' });
    }

    log('🎫 生成 Token...');
    const token = generateToken(user.id);
    log('✓ Token 已生成');

    log('✅ 登录成功');
    res.json({
      message: '登录成功',
      token,
      user: { id: user.id, email: user.email, name: user.name, role: user.role }
    });
  } catch (error) {
    log('❌ 登录错误: ' + error.message);
    log('堆栈: ' + error.stack);
    res.status(500).json({ error: '登录失败: ' + error.message });
  }
});

// 获取个人信息
app.get('/api/auth/profile', authMiddleware, async (req, res) => {
  try {
    res.json({
      user: {
        id: req.user.id,
        email: req.user.email,
        name: req.user.name,
        role: req.user.role,
        created_at: req.user.created_at
      }
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: '获取个人信息失败' });
  }
});

// ============ 职位管理路由 ============

// 获取职位列表
app.get('/api/jobs', async (req, res) => {
  try {
    console.log('DEBUG: /api/jobs endpoint called');
    const { country, gender, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    console.log('DEBUG: Getting connection from pool');
    const connection = await pool.getConnection();
    console.log('DEBUG: Connection obtained');

    let query = 'SELECT * FROM jobs WHERE 1=1';
    const params = [];

    if (country) {
      query += ' AND country_id = ?';
      params.push(country);
    }

    if (gender && gender !== 'all') {
      query += ' AND (gender_requirement = ? OR gender_requirement = "all")';
      params.push(gender);
    }

    query += ' ORDER BY weight DESC LIMIT ? OFFSET ?';
    params.push(parseInt(limit), offset);

    const [jobs] = await connection.query(query, params);

    let countQuery = 'SELECT COUNT(*) as total FROM jobs WHERE 1=1';
    const countParams = [];

    if (country) {
      countQuery += ' AND country_id = ?';
      countParams.push(country);
    }

    if (gender && gender !== 'all') {
      countQuery += ' AND (gender_requirement = ? OR gender_requirement = "all")';
      countParams.push(gender);
    }

    const [countResult] = await connection.query(countQuery, countParams);
    const total = countResult[0].total;

    connection.release();

    res.json({
      data: jobs.map(convertJobToFrontend),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        totalPages: Math.ceil(total / limit),
        hasNextPage: page * limit < total,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    console.error('Get jobs error:', error);
    res.status(500).json({ error: '获取职位列表失败' });
  }
});

// 获取单个职位
app.get('/api/jobs/:id', async (req, res) => {
  try {
    const jobId = req.params.id;
    const connection = await pool.getConnection();
    const [jobs] = await connection.query('SELECT * FROM jobs WHERE id = ?', [jobId]);
    connection.release();

    if (jobs.length === 0) {
      return res.status(404).json({ error: '职位不存在' });
    }

    res.json(convertJobToFrontend(jobs[0]));
  } catch (error) {
    console.error('Get job error:', error);
    res.status(500).json({ error: '获取职位详情失败' });
  }
});

// 创建职位
app.post('/api/jobs', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { title, description, country_id, gender_requirement, weight, company_name, requirements, location, salary, age_range, company_logo, whatsapp_phone } = req.body;
    const connection = await pool.getConnection();

    await connection.query(
      'INSERT INTO jobs (title, description, country_id, gender_requirement, weight, company_name, requirements, location, salary, age_range, company_logo, whatsapp_phone, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())',
      [title, description, country_id, gender_requirement || 'all', weight || 0, company_name, requirements, location, salary, age_range, company_logo, whatsapp_phone]
    );

    connection.release();
    res.json({ message: '职位创建成功' });
  } catch (error) {
    console.error('Create job error:', error);
    res.status(500).json({ error: '创建职位失败: ' + error.message });
  }
});

// 编辑职位
app.put('/api/jobs/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, country_id, gender_requirement, weight, company_name, requirements, location, salary, age_range, company_logo, whatsapp_phone } = req.body;
    const connection = await pool.getConnection();

    await connection.query(
      'UPDATE jobs SET title=?, description=?, country_id=?, gender_requirement=?, weight=?, company_name=?, requirements=?, location=?, salary=?, age_range=?, company_logo=?, whatsapp_phone=?, updated_at=NOW() WHERE id=?',
      [title, description, country_id, gender_requirement || 'all', weight || 0, company_name, requirements, location, salary, age_range, company_logo, whatsapp_phone, id]
    );

    connection.release();
    res.json({ message: '职位更新成功' });
  } catch (error) {
    console.error('Update job error:', error);
    res.status(500).json({ error: '更新职位失败: ' + error.message });
  }
});

// 删除职位
app.delete('/api/jobs/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();

    await connection.query('DELETE FROM jobs WHERE id=?', [id]);

    connection.release();
    res.json({ message: '职位删除成功' });
  } catch (error) {
    console.error('Delete job error:', error);
    res.status(500).json({ error: '删除职位失败: ' + error.message });
  }
});

// ============ 国家管理路由 ============

// 获取国家列表
app.get('/api/countries', async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [countries] = await connection.query('SELECT * FROM countries ORDER BY name');
    connection.release();

    res.json(countries);
  } catch (error) {
    console.error('Get countries error:', error);
    res.status(500).json({ error: '获取国家列表失败' });
  }
});

// 获取单个国家
app.get('/api/countries/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();
    const [countries] = await connection.query('SELECT * FROM countries WHERE id = ?', [id]);
    connection.release();

    if (countries.length === 0) {
      return res.status(404).json({ error: '国家不存在' });
    }

    res.json(countries[0]);
  } catch (error) {
    console.error('Get country error:', error);
    res.status(500).json({ error: '获取国家失败' });
  }
});

// 创建国家
app.post('/api/countries', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { name, code } = req.body;

    if (!name || !code) {
      return res.status(400).json({ error: '国家名称和代码不能为空' });
    }

    const connection = await pool.getConnection();

    // 检查代码是否已存在
    const [existing] = await connection.query('SELECT id FROM countries WHERE code = ?', [code]);
    if (existing.length > 0) {
      connection.release();
      return res.status(400).json({ error: '国家代码已存在' });
    }

    await connection.query(
      'INSERT INTO countries (name, code, created_at) VALUES (?, ?, NOW())',
      [name, code]
    );

    connection.release();
    res.json({ message: '国家创建成功' });
  } catch (error) {
    console.error('Create country error:', error);
    res.status(500).json({ error: '创建国家失败: ' + error.message });
  }
});

// 编辑国家
app.put('/api/countries/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, code } = req.body;

    if (!name || !code) {
      return res.status(400).json({ error: '国家名称和代码不能为空' });
    }

    const connection = await pool.getConnection();

    // 检查代码是否被其他国家使用
    const [existing] = await connection.query('SELECT id FROM countries WHERE code = ? AND id != ?', [code, id]);
    if (existing.length > 0) {
      connection.release();
      return res.status(400).json({ error: '国家代码已被其他国家使用' });
    }

    await connection.query(
      'UPDATE countries SET name = ?, code = ? WHERE id = ?',
      [name, code, id]
    );

    connection.release();
    res.json({ message: '国家更新成功' });
  } catch (error) {
    console.error('Update country error:', error);
    res.status(500).json({ error: '更新国家失败: ' + error.message });
  }
});

// 删除国家
app.delete('/api/countries/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();

    // 检查是否有职位关联此国家
    const [jobs] = await connection.query('SELECT COUNT(*) as count FROM jobs WHERE country_id = ?', [id]);
    if (jobs[0].count > 0) {
      connection.release();
      return res.status(400).json({ error: '该国家下还有职位，无法删除' });
    }

    await connection.query('DELETE FROM countries WHERE id = ?', [id]);

    connection.release();
    res.json({ message: '国家删除成功' });
  } catch (error) {
    console.error('Delete country error:', error);
    res.status(500).json({ error: '删除国家失败: ' + error.message });
  }
});

// ============ 用户管理路由 ============

// 获取用户列表
app.get('/api/users', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [users] = await connection.query('SELECT id, email, name, role, created_at FROM users ORDER BY created_at DESC');
    connection.release();

    res.json({
      data: users,
      pagination: {
        page: 1,
        limit: users.length,
        total: users.length,
        totalPages: 1,
        hasNextPage: false,
        hasPrevPage: false
      }
    });
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({ error: '获取用户列表失败' });
  }
});

// 获取应用用户列表（按国家分组）
app.get('/api/app-users-v2', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { page = 1, limit = 20, country_id } = req.query;
    const offset = (page - 1) * limit;

    const connection = await pool.getConnection();

    let query = 'SELECT * FROM app_users WHERE 1=1';
    const params = [];

    if (country_id) {
      query += ' AND country_id = ?';
      params.push(country_id);
    }

    query += ' ORDER BY created_at DESC LIMIT ? OFFSET ?';
    params.push(parseInt(limit), offset);

    const [users] = await connection.query(query, params);

    let countQuery = 'SELECT COUNT(*) as total FROM app_users WHERE 1=1';
    const countParams = [];

    if (country_id) {
      countQuery += ' AND country_id = ?';
      countParams.push(country_id);
    }

    const [countResult] = await connection.query(countQuery, countParams);
    const total = countResult[0].total;

    connection.release();

    const groupedUsers = {};
    users.forEach(user => {
      const cid = user.country_id || 'unknown';
      if (!groupedUsers[cid]) {
        groupedUsers[cid] = [];
      }
      groupedUsers[cid].push(user);
    });

    res.json({
      data: groupedUsers,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        totalPages: Math.ceil(total / limit),
        hasNextPage: page * limit < total,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    console.error('Get app users error:', error);
    res.status(500).json({ error: '获取应用用户列表失败' });
  }
});

// ============ 邀请码管理路由 ============

// 获取邀请码列表
app.get('/api/invites', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [invites] = await connection.query('SELECT * FROM invites ORDER BY created_at DESC');
    connection.release();

    res.json({
      data: invites || []
    });
  } catch (error) {
    console.error('Get invites error:', error);
    res.status(500).json({ error: '获取邀请码列表失败' });
  }
});

// 生成邀请码
app.post('/api/invites/generate', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const code = Math.random().toString(36).substring(2, 10).toUpperCase();
    const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);

    await connection.query(
      'INSERT INTO invites (code, created_by, expires_at, used, created_at) VALUES (?, ?, ?, ?, NOW())',
      [code, req.user.id, expiresAt, false]
    );

    connection.release();
    res.json({ message: '邀请码生成成功', code });
  } catch (error) {
    console.error('Generate invite error:', error);
    res.status(500).json({ error: '生成邀请码失败' });
  }
});

// 删除邀请码
app.delete('/api/invites/:code', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { code } = req.params;
    const connection = await pool.getConnection();

    await connection.query('DELETE FROM invites WHERE code = ?', [code]);

    connection.release();
    res.json({ message: '邀请码删除成功' });
  } catch (error) {
    console.error('Delete invite error:', error);
    res.status(500).json({ error: '删除邀请码失败' });
  }
});

// ============ 管理员管理路由 ============

// 获取管理员列表
app.get('/api/admins', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const connection = await pool.getConnection();
    const [admins] = await connection.query('SELECT id, email, name, role, created_at FROM users WHERE role IN ("admin", "super_admin") ORDER BY created_at DESC');
    connection.release();

    res.json({
      data: admins
    });
  } catch (error) {
    console.error('Get admins error:', error);
    res.status(500).json({ error: '获取管理员列表失败' });
  }
});

// 任命用户为管理员
app.post('/api/admins/assign', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { user_id } = req.body;
    const connection = await pool.getConnection();

    await connection.query('UPDATE users SET role = "admin" WHERE id = ?', [user_id]);

    connection.release();
    res.json({ message: '已任命为管理员' });
  } catch (error) {
    console.error('Assign admin error:', error);
    res.status(500).json({ error: '任命失败' });
  }
});

// 删除管理员权限（仅超级管理员）
app.post('/api/admins/revoke', authMiddleware, async (req, res) => {
  try {
    if (req.user.role !== 'super_admin') {
      return res.status(403).json({ error: '仅超级管理员可以删除管理员权限' });
    }

    const { user_id } = req.body;
    const connection = await pool.getConnection();

    await connection.query('UPDATE users SET role = "user" WHERE id = ?', [user_id]);

    connection.release();
    res.json({ message: '已删除管理员权限' });
  } catch (error) {
    console.error('Revoke admin error:', error);
    res.status(500).json({ error: '删除失败' });
  }
});

// 删除后台用户
app.delete('/api/admins/:user_id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const { user_id } = req.params;
    const connection = await pool.getConnection();

    // 检查要删除的用户角色
    const [targetUser] = await connection.query('SELECT role FROM users WHERE id = ?', [user_id]);

    if (targetUser.length === 0) {
      connection.release();
      return res.status(404).json({ error: '用户不存在' });
    }

    // 如果要删除的是超级管理员，只有超级管理员才能删除
    if (targetUser[0].role === 'super_admin' && req.user.role !== 'super_admin') {
      connection.release();
      return res.status(403).json({ error: '只有超级管理员才能删除超级管理员' });
    }

    // 如果要删除的是管理员，只有超级管理员才能删除
    if (targetUser[0].role === 'admin' && req.user.role !== 'super_admin') {
      connection.release();
      return res.status(403).json({ error: '只有超级管理员才能删除管理员' });
    }

    await connection.query('DELETE FROM users WHERE id = ?', [user_id]);

    connection.release();
    res.json({ message: '用户已删除' });
  } catch (error) {
    console.error('Delete admin user error:', error);
    res.status(500).json({ error: '删除失败' });
  }
});

// ============ 数据库迁移 ============
const runMigrations = async () => {
  try {
    const connection = await pool.getConnection();

    // 迁移1: 修改 company_logo 字段类型
    try {
      await connection.query(
        'ALTER TABLE jobs MODIFY company_logo LONGTEXT'
      );
      console.log('✅ 迁移1: company_logo 字段已更新');
    } catch (error) {
      if (error.code === 'ER_DUP_FIELDNAME' || error.message.includes('Duplicate column')) {
        console.log('⚠️  迁移1: company_logo 字段已存在');
      }
    }

    // 迁移2: 添加 whatsapp_phone 字段
    try {
      await connection.query(
        'ALTER TABLE jobs ADD COLUMN whatsapp_phone VARCHAR(50) AFTER country_id'
      );
      console.log('✅ 迁移2: whatsapp_phone 字段已添加');

      // 为现有职位添加默认 WhatsApp 号码（示例）
      await connection.query(
        "UPDATE jobs SET whatsapp_phone = '+8613800138000' WHERE whatsapp_phone IS NULL"
      );
      console.log('✅ 已为现有职位添加默认 WhatsApp 号码');
    } catch (error) {
      if (error.code === 'ER_DUP_FIELDNAME' || error.message.includes('Duplicate column')) {
        console.log('⚠️  迁移2: whatsapp_phone 字段已存在');
      } else {
        throw error;
      }
    }

    connection.release();
    console.log('✅ 数据库迁移完成');
  } catch (error) {
    if (error.code === 'ER_SYNTAX_ERROR' || error.message.includes('Syntax error')) {
      console.log('⚠️  数据库迁移已跳过（字段可能已存在）');
    } else {
      console.error('❌ 数据库迁移失败:', error.message);
    }
  }
};

// ============ SPA Fallback (必须在所有API路由之后) ============
// 所有非API请求都返回Flutter的index.html，支持前端路由
app.use((req, res, next) => {
  // 排除API请求和静态文件
  if (req.path.startsWith('/api/') || req.path.includes('.')) {
    return next();
  }
  const indexPath = path.join(__dirname, '..', '..', 'JobsProject', 'build', 'web', 'index.html');
  res.sendFile(indexPath);
});

// ============ 启动服务器 ============
const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  await runMigrations();

  console.log('\n╔════════════════════════════════════════╗');
  console.log('║   JobHub API 服务启动成功（MySQL 模式）  ║');
  console.log('╚════════════════════════════════════════╝\n');
  console.log(`✓ 服务地址: http://localhost:${PORT}`);
  console.log(`✓ 健康检查: http://localhost:${PORT}/api/health\n`);
  console.log('📚 API 端点:');
  console.log('  - POST   /api/auth/register      (用户注册)');
  console.log('  - POST   /api/auth/login         (用户登录)');
  console.log('  - GET    /api/auth/profile       (获取个人信息)');
  console.log('  - GET    /api/jobs               (获取职位列表)');
  console.log('  - GET    /api/jobs/:id           (获取职位详情)');
  console.log('  - POST   /api/jobs               (创建职位)');
  console.log('  - GET    /api/countries          (获取国家列表)');
  console.log('\n✅ 数据库: MySQL (jobshub)');
  console.log('✅ 数据持久化: 已启用\n');
});
