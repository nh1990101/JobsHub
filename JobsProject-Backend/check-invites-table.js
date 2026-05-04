require('dotenv').config();
const mysql = require('mysql2/promise');

async function checkTable() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'jobshub',
  });

  const [columns] = await connection.query('DESCRIBE invites');
  console.log('invites 表结构:');
  console.table(columns);

  await connection.end();
}

checkTable().catch(console.error);
