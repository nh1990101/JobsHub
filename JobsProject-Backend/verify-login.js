const mysql = require('mysql2/promise');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();

async function testLoginLogic() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    console.log('✓ 已连接到 MySQL');

    const email = 'admin@jobjub.com';
    const password = 'admin123';

    // 查询用户
    const [users] = await connection.query('SELECT * FROM users WHERE email = ?', [email]);
    console.log('查询结果:', users.length, '个用户');

    if (users.length === 0) {
      console.log('❌ 用户不存在');
      process.exit(1);
    }

    const user = users[0];
    console.log('✓ 用户找到:', user.email);
    console.log('  ID:', user.id);
    console.log('  Name:', user.name);
    console.log('  Role:', user.role);

    // 验证密码
    const passwordMatch = await bcryptjs.compare(password, user.password);
    console.log('✓ 密码匹配:', passwordMatch);

    if (!passwordMatch) {
      console.log('❌ 密码不匹配');
      process.exit(1);
    }

    // 生成 token
    const token = jwt.sign(
      { userId: user.id },
      process.env.JWT_SECRET || 'jobshub_jwt_secret_key_2025',
      { expiresIn: process.env.JWT_EXPIRE || '7d' }
    );

    console.log('✓ Token 已生成');
    console.log('  Token:', token.substring(0, 50) + '...');

    console.log('\n✅ 登录逻辑验证成功！');

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ 失败:', error.message);
    process.exit(1);
  }
}

testLoginLogic();
