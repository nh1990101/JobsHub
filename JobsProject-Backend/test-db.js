const mysql = require('mysql2/promise');
require('dotenv').config();

async function testConnection() {
  try {
    console.log('尝试连接到 MySQL...');
    console.log('Host:', process.env.DB_HOST);
    console.log('Port:', process.env.DB_PORT);
    console.log('User:', process.env.DB_USER);
    console.log('Database:', process.env.DB_NAME);

    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      port: process.env.DB_PORT,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    console.log('✓ 连接成功');

    const [result] = await connection.query('SELECT 1 as test');
    console.log('✓ 查询成功:', result);

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ 连接失败:', error.message);
    process.exit(1);
  }
}

testConnection();
