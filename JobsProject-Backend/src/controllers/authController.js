const User = require('../models/User');

exports.register = async (req, res) => {
  try {
    const { email, password, name } = req.body;

    if (!email || !password || !name) {
      return res.status(400).json({ error: '缺少必要字段' });
    }

    const userId = await User.register({ email, password, name });
    res.status(201).json({ message: '注册成功', userId });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: '缺少邮箱或密码' });
    }

    const user = await User.login(email, password);
    res.json(user);
  } catch (error) {
    res.status(401).json({ error: error.message });
  }
};

exports.getProfile = async (req, res) => {
  try {
    const user = await User.getById(req.userId);
    if (!user) {
      return res.status(404).json({ error: '用户不存在' });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const { name, email } = req.body;
    const success = await User.update(req.userId, { name, email });

    if (!success) {
      return res.status(404).json({ error: '用户不存在' });
    }

    res.json({ message: '更新成功' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
