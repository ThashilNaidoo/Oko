const express = require('express');
const router = express.Router();
const cropHandler = require('../handlers/cropHandler');
const authenticateToken = require('../middleware/authMiddleware');

router.get('/', authenticateToken, cropHandler.getCrops);
router.get('/:crop', authenticateToken, cropHandler.getCropDetails);
router.post('/:crop', authenticateToken, cropHandler.addCrop);
router.delete('/:crop', authenticateToken, cropHandler.removeCrop);

module.exports = router;
