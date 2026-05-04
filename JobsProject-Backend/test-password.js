const mysql = require('mysql2/promise');
const bcryptjs = require('bcryptjs');
require('dotenv').config();

async function testPassword() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    const [users] = await connection.query('SELECT password FROM users WHERE email = ?', ['admin@jobjub.com']);

    if (users.length === 0) {
      console.log('❌ 用户不存在');
      process.exit(1);
    }

    const storedHash = users[0].password;
    console.log('存储的密码哈希:', storedHash);

    const testPassword = 'admin123';
    const isMatch = await bcryptjs.compare(testPassword, storedHash);

    console.log('测试密码:', testPassword);
    console.log('密码匹配:', isMatch);

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ 失败:', error.message);
    process.exit(1);
  }
}

testPassword();
