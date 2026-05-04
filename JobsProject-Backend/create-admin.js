const mysql = require('mysql2/promise');
const bcryptjs = require('bcryptjs');
require('dotenv').config();

async function createAdmin() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    console.log('✓ 已连接到 MySQL');

    // 密码加密
    const hashedPassword = await bcryptjs.hash('admin123', 10);

    // 插入管理员用户
    const [result] = await connection.query(
      'INSERT INTO users (email, password, name, role) VALUES (?, ?, ?, ?)',
      ['admin@jobjub.com', hashedPassword, '管理员', 'admin']
    );

    console.log('✓ 管理员账户已创建');
    console.log('  邮箱: admin@jobjub.com');
    console.log('  密码: admin123');
    console.log('  角色: admin');

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ 失败:', error.message);
    process.exit(1);
  }
}

createAdmin();
