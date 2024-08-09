const express = require('express');
const router = express.Router();
const pestHandler = require('../handlers/pestHandler');

router.get('/', pestHandler.getPests);
router.get('/:pest', pestHandler.getPestDetails);

module.exports = router;
