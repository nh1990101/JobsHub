const Country = require('../models/Country');

exports.getCountries = async (req, res) => {
  try {
    const countries = await Country.getAll();
    res.json(countries);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getCountryById = async (req, res) => {
  try {
    const { id } = req.params;
    const country = await Country.getById(id);

    if (!country) {
      return res.status(404).json({ error: '国家不存在' });
    }

    res.json(country);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.createCountry = async (req, res) => {
  try {
    const { name, code } = req.body;

    if (!name || !code) {
      return res.status(400).json({ error: '缺少必要字段' });
    }

    const countryId = await Country.create({ name, code });
    res.status(201).json({ message: '国家创建成功', countryId });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.updateCountry = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, code } = req.body;
    const success = await Country.update(id, { name, code });

    if (!success) {
      return res.status(404).json({ error: '国家不存在' });
    }

    res.json({ message: '国家更新成功' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteCountry = async (req, res) => {
  try {
    const { id } = req.params;
    const success = await Country.delete(id);

    if (!success) {
      return res.status(404).json({ error: '国家不存在' });
    }

    res.json({ message: '国家删除成功' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
