-- 创建数据库
CREATE DATABASE IF NOT EXISTS jobshub;
USE jobshub;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 国家表
CREATE TABLE IF NOT EXISTS countries (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(10) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 职位表
CREATE TABLE IF NOT EXISTS jobs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  requirements TEXT NOT NULL,
  company_name VARCHAR(255) NOT NULL,
  company_logo VARCHAR(500),
  location VARCHAR(255) NOT NULL,
  salary VARCHAR(100) NOT NULL,
  age_range VARCHAR(50),
  gender_requirement VARCHAR(20) DEFAULT 'all',
  weight INT DEFAULT 50,
  country_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE SET NULL,
  INDEX idx_country (country_id),
  INDEX idx_weight (weight)
);

-- 插入示例国家数据
INSERT INTO countries (name, code) VALUES
('中国', 'CN'),
('美国', 'US'),
('日本', 'JP'),
('新加坡', 'SG'),
('加拿大', 'CA');

-- 插入示例职位数据
INSERT INTO jobs (title, description, requirements, company_name, company_logo, location, salary, age_range, gender_requirement, weight, country_id) VALUES
('高级 Flutter 开发工程师', '我们正在寻找一位经验丰富的 Flutter 开发工程师...', '5年以上 Flutter 开发经验，熟悉 Dart 语言...', 'TechCorp', 'https://example.com/logo.png', '北京', '30k-50k', '25-40', 'all', 90, 1),
('全栈工程师', '负责前后端开发，参与产品设计...', '3年以上全栈开发经验，熟悉 Node.js 和 React...', 'StartupXYZ', 'https://example.com/logo2.png', '上海', '25k-40k', '23-35', 'all', 80, 1),
('UI/UX 设计师', '设计移动应用和网页界面...', '3年以上 UI/UX 设计经验，熟悉 Figma...', 'DesignStudio', 'https://example.com/logo3.png', '深圳', '20k-35k', '22-38', 'all', 70, 1);
