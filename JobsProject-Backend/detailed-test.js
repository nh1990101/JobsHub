const http = require('http');

function makeRequest(path, method, data) {
  return new Promise((resolve, reject) => {
    const postData = data ? JSON.stringify(data) : '';

    const options = {
      hostname: 'localhost',
      port: 3000,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
      }
    };

    const req = http.request(options, (res) => {
      let responseData = '';

      res.on('data', (chunk) => {
        responseData += chunk;
      });

      res.on('end', () => {
        resolve({
          status: res.statusCode,
          data: responseData
        });
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    if (postData) {
      req.write(postData);
    }
    req.end();
  });
}

async function test() {
  try {
    console.log('测试 1: 健康检查');
    let result = await makeRequest('/api/health', 'GET', );
    console.log('状态:', result.status);
    console.log('响应:', result.data);

    console.log('\n测试 2: 获取职位列表');
    result = await makeRequest('/api/jobs', 'GET', {});
    console.log('状态:', result.status);
    console.log('响应:', result.data);

    console.log('\n测试 3: 登录');
    result = await makeRequest('/api/auth/login', 'POST', {
      email: 'admin@jobjub.com',
      password: 'admin123'
    });
    console.log('状态:', result.status);
    console.log('响应:', result.data);

    process.exit(0);
  } catch (error) {
    console.error('错误:', error.message);
    process.exit(1);
  }
}

test();
