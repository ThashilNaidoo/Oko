const express = require('express');
const router = express.Router();
const cropHandler = require('../handlers/cropHandler');

router.get('/', cropHandler.getCrops);

module.exports = router;
