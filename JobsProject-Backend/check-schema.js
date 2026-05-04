const mysql = require('mysql2/promise');
require('dotenv').config();

async function checkSchema() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    console.log('=== users 表结构 ===');
    const [usersSchema] = await connection.query('DESCRIBE users');
    usersSchema.forEach(col => {
      console.log(`  ${col.Field}: ${col.Type} ${col.Null === 'NO' ? 'NOT NULL' : 'NULL'}`);
    });

    console.log('\n=== invites 表结构 ===');
    const [invitesSchema] = await connection.query('DESCRIBE invites');
    invitesSchema.forEach(col => {
      console.log(`  ${col.Field}: ${col.Type} ${col.Null === 'NO' ? 'NOT NULL' : 'NULL'}`);
    });

    await connection.end();
  } catch (error) {
    console.error('错误:', error.message);
  }
}

checkSchema();
