const fs = require('fs');
const content = fs.readFileSync('src/server.js', 'utf8');

// Find all app.get routes
const routes = content.match(/app\.get\('([^']+)'/g);
console.log('Found routes:');
routes.forEach(r => console.log(r));
