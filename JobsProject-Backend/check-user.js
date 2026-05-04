const mysql = require('mysql2/promise');
require('dotenv').config();

async function checkUser() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    const [users] = await connection.query('SELECT id, email, name, role FROM users WHERE email = ?', ['admin@jobjub.com']);

    if (users.length > 0) {
      console.log('✓ 用户存在:');
      console.log(users[0]);
    } else {
      console.log('❌ 用户不存在');
    }

    // 显示所有用户
    const [allUsers] = await connection.query('SELECT id, email, name, role FROM users');
    console.log('\n所有用户:');
    console.log(allUsers);

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ 失败:', error.message);
    process.exit(1);
  }
}

checkUser();
