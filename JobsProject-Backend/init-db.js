const mysql = require('mysql2/promise');
const fs = require('fs');
require('dotenv').config();

async function initDatabase() {
  try {
    // 连接到 MySQL（不指定数据库）
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      port: process.env.DB_PORT,
    });

    console.log('✓ 已连接到 MySQL');

    // 读取 init.sql 文件
    const sql = fs.readFileSync('./init.sql', 'utf8');

    // 执行 SQL 脚本
    const statements = sql.split(';').filter(stmt => stmt.trim());

    for (const statement of statements) {
      if (statement.trim()) {
        await connection.query(statement);
      }
    }

    console.log('✓ 数据库初始化成功');
    console.log('✓ 已创建表: users, countries, jobs');
    console.log('✓ 已插入示例数据');

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ 数据库初始化失败:', error.message);
    process.exit(1);
  }
}

initDatabase();
