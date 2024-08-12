const express = require('express');
const router = express.Router();
const updateHandler = require('../handlers/updateHandler');
const authenticateToken = require('../middleware/authMiddleware');

router.get('/', authenticateToken, updateHandler.update);

module.exports = router;
