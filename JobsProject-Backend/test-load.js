const http = require('http');

const API_BASE = 'http://localhost:3000/api';
const countries = [
  { id: 1, name: '中国' },
  { id: 2, name: '美国' },
  { id: 3, name: '日本' },
  { id: 4, name: '新加坡' },
  { id: 5, name: '加拿大' }
];

let adminToken = '';

// 发送 HTTP 请求
function makeRequest(method, path, data = null, token = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(API_BASE + path);
    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      method: method,
      headers: {
        'Content-Type': 'application/json'
      }
    };

    if (token) {
      options.headers['Authorization'] = `Bearer ${token}`;
    }

    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: JSON.parse(body) });
        } catch (e) {
          resolve({ status: res.statusCode, data: body });
        }
      });
    });

    req.on('error', reject);
    if (data) req.write(JSON.stringify(data));
    req.end();
  });
}

// 登录获取 token
async function login() {
  console.log('📝 正在登录...');
  const res = await makeRequest('POST', '/auth/login', {
    email: 'admin@jobjub.com',
    password: 'admin123'
  });

  if (res.data.token) {
    adminToken = res.data.token;
    console.log('✅ 登录成功');
    return true;
  } else {
    console.log('❌ 登录失败');
    return false;
  }
}

// 为每个国家创建30个职位
async function createJobs() {
  console.log('\n📋 开始创建职位...');
  let count = 0;

  for (const country of countries) {
    for (let i = 1; i <= 30; i++) {
      const job = {
        title: `${country.name} - 职位 ${i}`,
        description: `这是${country.name}的第${i}个职位`,
        requirements: `需要相关经验`,
        company_name: `公司${i}`,
        location: `城市${i}`,
        salary: `${10 + i}k-${20 + i}k`,
        age_range: '25-40',
        gender_requirement: 'all',
        weight: 80,
        country_id: country.id
      };

      try {
        await makeRequest('POST', '/jobs', job, adminToken);
        count++;
        if (count % 10 === 0) {
          process.stdout.write(`\r✅ 已创建 ${count} 个职位`);
        }
      } catch (e) {
        console.error(`❌ 创建职位失败: ${e.message}`);
      }
    }
  }

  console.log(`\n✅ 职位创建完成，共 ${count} 个`);
}

// 为每个国家创建50个用户
async function createUsers() {
  console.log('\n👥 开始创建用户...');
  let count = 0;

  for (const country of countries) {
    for (let i = 1; i <= 50; i++) {
      const user = {
        device_id: `device_${country.id}_${i}`,
        name: `${country.name}用户${i}`,
        email: `user_${country.id}_${i}@test.com`,
        phone: '',
        age: 25 + Math.floor(Math.random() * 30),
        gender: Math.random() > 0.5 ? 'M' : 'F',
        country_id: country.id,
        ip_address: '127.0.0.1'
      };

      try {
        await makeRequest('POST', '/app-users/register', user);
        count++;
        if (count % 20 === 0) {
          process.stdout.write(`\r✅ 已创建 ${count} 个用户`);
        }
      } catch (e) {
        // 忽略错误继续
      }
    }
  }

  console.log(`\n✅ 用户创建完成，共 ${count} 个`);
}

// 并发测试
async function concurrencyTest() {
  console.log('\n⚡ 开始并发测试...');

  const tests = [
    { name: '获取职位列表', method: 'GET', path: '/jobs' },
    { name: '获取国家列表', method: 'GET', path: '/countries' },
    { name: '获取用户列表', method: 'GET', path: '/users' }
  ];

  for (const test of tests) {
    console.log(`\n测试: ${test.name}`);

    // 100个并发请求
    const startTime = Date.now();
    const promises = [];

    for (let i = 0; i < 100; i++) {
      promises.push(
        makeRequest(test.method, test.path, null, adminToken)
          .catch(e => ({ error: e.message }))
      );
    }

    const results = await Promise.all(promises);
    const endTime = Date.now();
    const duration = endTime - startTime;

    const successful = results.filter(r => r.status === 200).length;
    const failed = results.filter(r => !r.status || r.status !== 200).length;

    console.log(`  ✅ 成功: ${successful}/100`);
    console.log(`  ❌ 失败: ${failed}/100`);
    console.log(`  ⏱️  耗时: ${duration}ms`);
    console.log(`  📊 平均响应时间: ${(duration / 100).toFixed(2)}ms`);
  }
}

// 主函数
async function main() {
  try {
    console.log('🚀 开始测试...\n');

    if (!await login()) {
      console.log('登录失败，请检查后端是否运行');
      return;
    }

    await createJobs();
    await createUsers();
    await concurrencyTest();

    console.log('\n✅ 所有测试完成！');
  } catch (error) {
    console.error('❌ 测试出错:', error);
  }
}

main();
