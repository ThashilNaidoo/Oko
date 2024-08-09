const express = require('express');
const router = express.Router();
const updateHandler = require('../handlers/updateHandler');

router.get('/', updateHandler.update);

module.exports = router;
