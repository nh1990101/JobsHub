const pool = require('../config/database');

class Job {
  static async getAll(filters = {}) {
    let query = 'SELECT * FROM jobs WHERE 1=1';
    const params = [];

    if (filters.country) {
      query += ' AND country_id = ?';
      params.push(filters.country);
    }

    if (filters.ageMin !== undefined && filters.ageMax !== undefined) {
      query += ' AND age_range LIKE ?';
      params.push(`${filters.ageMin}-%`);
    }

    if (filters.gender && filters.gender !== 'all') {
      query += ' AND gender_requirement = ?';
      params.push(filters.gender);
    }

    query += ' ORDER BY weight DESC LIMIT ? OFFSET ?';
    params.push(filters.limit || 20, filters.offset || 0);

    const [rows] = await pool.query(query, params);
    return rows;
  }

  static async getById(id) {
    const [rows] = await pool.query('SELECT * FROM jobs WHERE id = ?', [id]);
    return rows[0];
  }

  static async create(jobData) {
    const {
      title,
      description,
      requirements,
      companyName,
      companyLogo,
      location,
      salary,
      ageRange,
      genderRequirement,
      weight,
      countryId,
      whatsappPhone,
    } = jobData;

    const [result] = await pool.query(
      `INSERT INTO jobs
       (title, description, requirements, company_name, company_logo, location, salary, age_range, gender_requirement, weight, country_id, whatsapp_phone)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [title, description, requirements, companyName, companyLogo, location, salary, ageRange, genderRequirement, weight, countryId, whatsappPhone]
    );

    return result.insertId;
  }

  static async update(id, jobData) {
    const fields = [];
    const values = [];

    Object.entries(jobData).forEach(([key, value]) => {
      fields.push(`${key} = ?`);
      values.push(value);
    });

    values.push(id);

    const [result] = await pool.query(
      `UPDATE jobs SET ${fields.join(', ')} WHERE id = ?`,
      values
    );

    return result.affectedRows > 0;
  }

  static async delete(id) {
    const [result] = await pool.query('DELETE FROM jobs WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

module.exports = Job;
