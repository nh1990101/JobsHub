const mysql = require('mysql2/promise');
require('dotenv').config();

async function addRoleColumn() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    console.log('✓ 已连接到 MySQL');

    // 添加 role 列到 users 表
    await connection.query(`
      ALTER TABLE users ADD COLUMN role VARCHAR(50) DEFAULT 'user' AFTER name
    `).catch(err => {
      if (err.code === 'ER_DUP_FIELDNAME') {
        console.log('✓ role 列已存在');
      } else {
        throw err;
      }
    });

    console.log('✓ 已添加 role 列到 users 表');

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ 失败:', error.message);
    process.exit(1);
  }
}

addRoleColumn();
