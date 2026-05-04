const express = require('express');
const countryController = require('../controllers/countryController');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.get('/', countryController.getCountries);
router.get('/:id', countryController.getCountryById);
router.post('/', authMiddleware, countryController.createCountry);
router.put('/:id', authMiddleware, countryController.updateCountry);
router.delete('/:id', authMiddleware, countryController.deleteCountry);

module.exports = router;
