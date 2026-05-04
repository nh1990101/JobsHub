require('dotenv').config();
const mysql = require('mysql2/promise');

async function setSuperAdmin() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'jobshub',
  });

  console.log('✅ 已连接到数据库');

  // 查询用户信息
  const [users] = await connection.query('SELECT id, email, name, role FROM users WHERE id = 9');

  if (users.length === 0) {
    console.log('❌ 用户ID 9 不存在');
    await connection.end();
    return;
  }

  console.log('\n当前用户信息:');
  console.log(users[0]);

  // 更新为超级管理员
  await connection.query('UPDATE users SET role = ? WHERE id = ?', ['super_admin', 9]);

  console.log('\n✅ 已将用户ID 9 设置为超级管理员');

  // 验证更新
  const [updated] = await connection.query('SELECT id, email, name, role FROM users WHERE id = 9');
  console.log('\n更新后的用户信息:');
  console.log(updated[0]);

  await connection.end();
}

setSuperAdmin().catch(err => {
  console.error('❌ 错误:', err);
  process.exit(1);
});
