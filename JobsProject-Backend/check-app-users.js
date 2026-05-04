const mysql = require('mysql2/promise');
require('dotenv').config();

async function checkAppUsers() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    const [tables] = await connection.query('SHOW TABLES LIKE "app_users"');

    if (tables.length === 0) {
      console.log('❌ app_users 表不存在');
      console.log('\n创建 app_users 表...');

      await connection.query(`
        CREATE TABLE app_users (
          id INT AUTO_INCREMENT PRIMARY KEY,
          device_id VARCHAR(255) UNIQUE,
          name VARCHAR(255),
          email VARCHAR(255),
          phone VARCHAR(20),
          age INT,
          gender VARCHAR(20),
          country_id INT,
          ip_address VARCHAR(50),
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
      `);

      console.log('✅ app_users 表已创建');
    } else {
      console.log('✅ app_users 表已存在');
      const [schema] = await connection.query('DESCRIBE app_users');
      console.log('\n表结构:');
      schema.forEach(col => {
        console.log(`  ${col.Field}: ${col.Type}`);
      });
    }

    await connection.end();
  } catch (error) {
    console.error('错误:', error.message);
  }
}

checkAppUsers();
