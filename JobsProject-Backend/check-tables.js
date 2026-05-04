const mysql = require('mysql2/promise');
require('dotenv').config();

async function checkTables() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    const [tables] = await connection.query('SHOW TABLES');
    console.log('数据库中的表:');
    tables.forEach(t => {
      const tableName = Object.values(t)[0];
      console.log(`  - ${tableName}`);
    });

    await connection.end();
  } catch (error) {
    console.error('错误:', error.message);
  }
}

checkTables();
