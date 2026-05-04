const pool = require('../config/database');

class Country {
  static async getAll() {
    const [rows] = await pool.query('SELECT * FROM countries ORDER BY name ASC');
    return rows;
  }

  static async getById(id) {
    const [rows] = await pool.query('SELECT * FROM countries WHERE id = ?', [id]);
    return rows[0];
  }

  static async create(countryData) {
    const { name, code } = countryData;
    const [result] = await pool.query(
      'INSERT INTO countries (name, code) VALUES (?, ?)',
      [name, code]
    );
    return result.insertId;
  }

  static async update(id, countryData) {
    const { name, code } = countryData;
    const [result] = await pool.query(
      'UPDATE countries SET name = ?, code = ? WHERE id = ?',
      [name, code, id]
    );
    return result.affectedRows > 0;
  }

  static async delete(id) {
    const [result] = await pool.query('DELETE FROM countries WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

module.exports = Country;
