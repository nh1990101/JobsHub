const pool = require('../config/database');
const bcrypt = require('bcryptjs');
const { generateToken } = require('../utils/jwt');

class User {
  static async register(userData) {
    const { email, password, name } = userData;

    const [existing] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      throw new Error('邮箱已被注册');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const [result] = await pool.query(
      'INSERT INTO users (email, password, name) VALUES (?, ?, ?)',
      [email, hashedPassword, name]
    );

    return result.insertId;
  }

  static async login(email, password) {
    const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);

    if (rows.length === 0) {
      throw new Error('邮箱或密码错误');
    }

    const user = rows[0];
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      throw new Error('邮箱或密码错误');
    }

    const token = generateToken(user.id);
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      token,
    };
  }

  static async getById(id) {
    const [rows] = await pool.query('SELECT id, email, name, created_at FROM users WHERE id = ?', [id]);
    return rows[0];
  }

  static async update(id, userData) {
    const { name, email } = userData;
    const [result] = await pool.query(
      'UPDATE users SET name = ?, email = ? WHERE id = ?',
      [name, email, id]
    );
    return result.affectedRows > 0;
  }
}

module.exports = User;
