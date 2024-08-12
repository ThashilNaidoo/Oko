const express = require('express');
const router = express.Router();
const weatherHandler = require('../handlers/weatherHandler');
const authenticateToken = require('../middleware/authMiddleware');

router.get('/', authenticateToken, weatherHandler.getWeather);

module.exports = router;
