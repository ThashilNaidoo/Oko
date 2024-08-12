const express = require('express');
const router = express.Router();
const tipHandler = require('../handlers/tipHandler');
const authenticateToken = require('../middleware/authMiddleware');

router.get('/', authenticateToken, tipHandler.getTip);

module.exports = router;
