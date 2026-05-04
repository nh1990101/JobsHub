const express = require('express');
const path = require('path');

const app = express();

// 静态文件路由
app.get('/admin.html', (req, res) => {
  const filePath = path.join(__dirname, 'admin.html');
  console.log('发送文件:', filePath);
  res.sendFile(filePath);
});

app.get('/test', (req, res) => {
  res.send('测试路由工作！');
});

const PORT = 3001;
app.listen(PORT, () => {
  console.log(`测试服务器运行在 http://localhost:${PORT}`);
  console.log(`访问: http://localhost:${PORT}/admin.html`);
  console.log(`测试: http://localhost:${PORT}/test`);
});
