const mysql = require('mysql2/promise');
require('dotenv').config();

async function checkJobsSchema() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    console.log('=== jobs 表结构 ===');
    const [jobsSchema] = await connection.query('DESCRIBE jobs');
    jobsSchema.forEach(col => {
      console.log(`  ${col.Field}: ${col.Type} ${col.Null === 'NO' ? 'NOT NULL' : 'NULL'}`);
    });

    console.log('\n=== 示例职位数据 ===');
    const [jobs] = await connection.query('SELECT * FROM jobs LIMIT 1');
    if (jobs.length > 0) {
      console.log(JSON.stringify(jobs[0], null, 2));
    }

    await connection.end();
  } catch (error) {
    console.error('错误:', error.message);
  }
}

checkJobsSchema();
