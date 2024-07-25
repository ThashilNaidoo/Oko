const express = require('express');
const router = express.Router();
const weatherHandler = require('../handlers/weatherHandler');

router.get('/', weatherHandler.getWeather);

module.exports = router;
