require('dotenv').config();
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

async function checkAndFixDatabase() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'jobshub',
    multipleStatements: true
  });

  console.log('✅ 已连接到数据库');

  // 检查表是否存在
  const [tables] = await connection.query("SHOW TABLES");
  const tableNames = tables.map(t => Object.values(t)[0]);

  console.log('\n📋 现有表:', tableNames.join(', '));

  // 检查 invites 表结构
  if (tableNames.includes('invites')) {
    const [columns] = await connection.query('DESCRIBE invites');
    const columnNames = columns.map(c => c.Field);
    console.log('\n📋 invites 表字段:', columnNames.join(', '));

    if (!columnNames.includes('created_by')) {
      console.log('\n⚠️  invites 表缺少 created_by 字段，正在添加...');
      await connection.query('ALTER TABLE invites ADD COLUMN created_by INT AFTER code');
      console.log('✅ 已添加 created_by 字段');
    }
  }

  // 检查 app_users 表
  if (!tableNames.includes('app_users')) {
    console.log('\n⚠️  app_users 表不存在，正在创建...');
    await connection.query(`
      CREATE TABLE app_users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        device_id VARCHAR(255) UNIQUE NOT NULL,
        name VARCHAR(255),
        email VARCHAR(255),
        phone VARCHAR(20),
        age INT,
        gender VARCHAR(10),
        country_id INT,
        ip_address VARCHAR(50),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (country_id) REFERENCES countries(id)
      )
    `);
    console.log('✅ 已创建 app_users 表');
  }

  console.log('\n✅ 数据库检查完成');
  await connection.end();
}

checkAndFixDatabase().catch(err => {
  console.error('❌ 错误:', err);
  process.exit(1);
});
