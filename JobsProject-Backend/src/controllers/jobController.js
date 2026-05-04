const Job = require('../models/Job');

exports.getJobs = async (req, res) => {
  try {
    const { country, ageMin, ageMax, gender, limit, offset } = req.query;

    const filters = {
      country,
      ageMin: ageMin ? parseInt(ageMin) : undefined,
      ageMax: ageMax ? parseInt(ageMax) : undefined,
      gender,
      limit: limit ? parseInt(limit) : 20,
      offset: offset ? parseInt(offset) : 0,
    };

    const jobs = await Job.getAll(filters);
    res.json(jobs);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getJobById = async (req, res) => {
  try {
    const { id } = req.params;
    const job = await Job.getById(id);

    if (!job) {
      return res.status(404).json({ error: '职位不存在' });
    }

    res.json(job);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.createJob = async (req, res) => {
  try {
    const jobData = req.body;
    const jobId = await Job.create(jobData);
    res.status(201).json({ message: '职位创建成功', jobId });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.updateJob = async (req, res) => {
  try {
    const { id } = req.params;
    const jobData = req.body;
    const success = await Job.update(id, jobData);

    if (!success) {
      return res.status(404).json({ error: '职位不存在' });
    }

    res.json({ message: '职位更新成功' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteJob = async (req, res) => {
  try {
    const { id } = req.params;
    const success = await Job.delete(id);

    if (!success) {
      return res.status(404).json({ error: '职位不存在' });
    }

    res.json({ message: '职位删除成功' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
