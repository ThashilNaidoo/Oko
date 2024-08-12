const express = require('express');
const router = express.Router();
const pestHandler = require('../handlers/pestHandler');
const authenticateToken = require('../middleware/authMiddleware');

router.get('/', authenticateToken, pestHandler.getPests);
router.get('/featured', authenticateToken, pestHandler.getFeaturedPest);
router.get('/:pest', authenticateToken, pestHandler.getPestDetails);

module.exports = router;
