const mysql = require('mysql2/promise');
require('dotenv').config();

async function createInviteCode() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    console.log('✓ 已连接到 MySQL');

    // 创建邀请码表
    await connection.query(`
      CREATE TABLE IF NOT EXISTS invites (
        id INT PRIMARY KEY AUTO_INCREMENT,
        code VARCHAR(50) UNIQUE NOT NULL,
        created_by INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        expires_at TIMESTAMP,
        used BOOLEAN DEFAULT false,
        used_by INT,
        used_at TIMESTAMP NULL,
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
        FOREIGN KEY (used_by) REFERENCES users(id) ON DELETE SET NULL
      )
    `);

    console.log('✓ 已创建 invites 表');

    // 生成邀请码
    const inviteCode = 'ADMIN_' + Math.random().toString(36).substring(2, 15).toUpperCase();

    // 插入邀请码（30天有效期）
    await connection.query(
      `INSERT INTO invites (code, expires_at, used) VALUES (?, DATE_ADD(NOW(), INTERVAL 30 DAY), false)`,
      [inviteCode]
    );

    console.log('✓ 已生成邀请码:', inviteCode);
    console.log('✓ 有效期: 30天');

    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('❌ 失败:', error.message);
    process.exit(1);
  }
}

createInviteCode();
