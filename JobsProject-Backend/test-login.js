const http = require('http');

const postData = JSON.stringify({
  email: 'admin@jobjub.com',
  password: 'admin123'
});

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/api/auth/login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(postData)
  }
};

const req = http.request(options, (res) => {
  let data = '';

  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    console.log('状态码:', res.statusCode);
    console.log('响应:', data);
    process.exit(0);
  });
});

req.on('error', (error) => {
  console.error('请求错误:', error);
  process.exit(1);
});

req.write(postData);
req.end();
