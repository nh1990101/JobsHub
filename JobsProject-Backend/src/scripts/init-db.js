const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

async function initializeDatabase() {
  let connection;

  try {
    console.log('🔄 正在连接到 MySQL...');

    // 先连接到 MySQL（不指定数据库）
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
    });

    console.log('✓ MySQL 连接成功');

    // 读取 init.sql 文件
    const sqlPath = path.join(__dirname, '..', 'init.sql');
    const sqlContent = fs.readFileSync(sqlPath, 'utf8');

    // 分割 SQL 语句（简单的分割方式）
    const statements = sqlContent
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0);

    console.log(`📝 执行 ${statements.length} 条 SQL 语句...`);

    for (const statement of statements) {
      try {
        await connection.query(statement);
      } catch (error) {
        // 忽略某些非致命错误（如表已存在）
        if (!error.message.includes('already exists')) {
          console.warn(`⚠️  警告: ${error.message}`);
        }
      }
    }

    console.log('✓ 数据库初始化成功！');
    console.log('');
    console.log('📊 数据库信息:');
    console.log('  - 数据库名: jobshub');
    console.log('  - 表: users, countries, jobs');
    console.log('  - 示例数据: 5 个国家, 3 个职位');
    console.log('');

  } catch (error) {
    console.error('❌ 数据库初始化失败:');
    console.error(error.message);
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

// 需要加载 .env 文件
require('dotenv').config();

initializeDatabase();
