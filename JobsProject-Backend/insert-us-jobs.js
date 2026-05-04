const http = require('http');

const API_BASE = 'http://localhost:3000/api';

// 真实的美国职位名称
const jobTitles = [
  'Software Engineer', 'Senior Software Engineer', 'Full Stack Developer', 'Frontend Developer',
  'Backend Developer', 'DevOps Engineer', 'Data Scientist', 'Machine Learning Engineer',
  'Product Manager', 'UX Designer', 'UI Designer', 'Business Analyst',
  'Project Manager', 'Scrum Master', 'QA Engineer', 'Test Automation Engineer',
  'Cloud Architect', 'Solutions Architect', 'Systems Administrator', 'Network Engineer',
  'Database Administrator', 'Security Engineer', 'Cybersecurity Analyst', 'IT Support Specialist',
  'Sales Engineer', 'Technical Writer', 'Solutions Consultant', 'Business Intelligence Analyst',
  'Data Engineer', 'Analytics Engineer', 'Mobile Developer', 'iOS Developer',
  'Android Developer', 'Game Developer', 'Graphics Programmer', 'Embedded Systems Engineer',
  'Firmware Engineer', 'Hardware Engineer', 'Electrical Engineer', 'Mechanical Engineer',
  'Civil Engineer', 'Architect', 'Construction Manager', 'Site Manager',
  'Marketing Manager', 'Content Manager', 'Social Media Manager', 'SEO Specialist',
  'HR Manager', 'Recruiter', 'Finance Manager', 'Accountant'
];

// 真实的美国公司名称
const companies = [
  'Google', 'Microsoft', 'Apple', 'Amazon', 'Meta', 'Tesla', 'Netflix', 'Uber',
  'Airbnb', 'Spotify', 'Slack', 'Zoom', 'Stripe', 'Shopify', 'Twilio', 'Datadog',
  'Figma', 'Notion', 'Discord', 'Roblox', 'Snapchat', 'Pinterest', 'Dropbox', 'Box',
  'Salesforce', 'Oracle', 'IBM', 'Intel', 'Nvidia', 'AMD', 'Qualcomm', 'Broadcom',
  'Cisco', 'Juniper', 'Arista', 'Palo Alto Networks', 'CrowdStrike', 'Okta', 'Twilio',
  'Atlassian', 'JetBrains', 'GitHub', 'GitLab', 'HashiCorp', 'Terraform', 'Kubernetes',
  'Docker', 'Red Hat', 'Canonical', 'SUSE', 'CentOS', 'Ubuntu', 'Debian', 'Fedora'
];

// 职位描述关键词
const descriptionKeywords = [
  '我们正在寻找一位有才华的', '加入我们的团队，帮助', '我们需要一位经验丰富的',
  '如果你对', '我们的公司致力于', '在这个角色中，你将', '你将负责',
  '我们提供一个充满挑战的环境', '这是一个独特的机会', '我们正在构建'
];

// 需求关键词
const requirementKeywords = [
  '5年以上相关经验', '3年以上工作经验', '精通相关技术栈', '良好的沟通能力',
  '团队合作精神', '解决问题的能力', '学习新技术的热情', '英文流利',
  '有相关项目经验', '了解敏捷开发', '有领导团队经验', '有创业经验'
];

// 美国城市和州
const usLocations = [
  { city: 'San Francisco', state: 'CA' },
  { city: 'Los Angeles', state: 'CA' },
  { city: 'San Jose', state: 'CA' },
  { city: 'San Diego', state: 'CA' },
  { city: 'Seattle', state: 'WA' },
  { city: 'Portland', state: 'OR' },
  { city: 'Denver', state: 'CO' },
  { city: 'Austin', state: 'TX' },
  { city: 'Dallas', state: 'TX' },
  { city: 'Houston', state: 'TX' },
  { city: 'Chicago', state: 'IL' },
  { city: 'New York', state: 'NY' },
  { city: 'Boston', state: 'MA' },
  { city: 'Philadelphia', state: 'PA' },
  { city: 'Washington', state: 'DC' },
  { city: 'Atlanta', state: 'GA' },
  { city: 'Miami', state: 'FL' },
  { city: 'Phoenix', state: 'AZ' },
  { city: 'Las Vegas', state: 'NV' },
  { city: 'Minneapolis', state: 'MN' }
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
          resolve(JSON.parse(body));
        } catch (e) {
          resolve(body);
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

  if (res.token) {
    adminToken = res.token;
    console.log('✅ 登录成功\n');
    return true;
  } else {
    console.log('❌ 登录失败');
    return false;
  }
}

// 生成随机美国职位
function generateUSJob(index) {
  const title = jobTitles[Math.floor(Math.random() * jobTitles.length)];
  const company = companies[Math.floor(Math.random() * companies.length)];
  const location = usLocations[Math.floor(Math.random() * usLocations.length)];
  const description = descriptionKeywords[Math.floor(Math.random() * descriptionKeywords.length)] +
    title + '来加入我们的' + company + '团队。';
  const requirements = requirementKeywords[Math.floor(Math.random() * requirementKeywords.length)] +
    '，' + requirementKeywords[Math.floor(Math.random() * requirementKeywords.length)];
  const minSalary = 50 + Math.floor(Math.random() * 150);
  const maxSalary = minSalary + 20 + Math.floor(Math.random() * 50);

  return {
    title: `${title} - ${company}`,
    description: description,
    requirements: requirements,
    company_name: company,
    location: `${location.city}, ${location.state}`,
    salary: `$${minSalary}k-$${maxSalary}k`,
    age_range: '25-45',
    gender_requirement: 'all',
    weight: 70 + Math.floor(Math.random() * 30),
    country_id: 2 // 美国
  };
}

// 主函数
async function main() {
  if (!await login()) {
    console.log('登录失败，请检查后端是否运行');
    return;
  }

  console.log('🚀 开始插入美国职位数据...\n');
  let count = 0;
  let failed = 0;

  for (let i = 1; i <= 50; i++) {
    const job = generateUSJob(i);

    try {
      const result = await makeRequest('POST', '/jobs', job, adminToken);
      count++;

      if (count % 10 === 0) {
        process.stdout.write(`\r✅ 已插入 ${count} 个职位`);
      }
    } catch (e) {
      failed++;
      console.error(`\n❌ 插入职位 ${i} 失败: ${e.message}`);
    }
  }

  console.log(`\n\n✅ 美国职位插入完成！`);
  console.log(`   成功: ${count} 个`);
  console.log(`   失败: ${failed} 个`);
}

main();
