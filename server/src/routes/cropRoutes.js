const express = require('express');
const router = express.Router();
const cropHandler = require('../handlers/cropHandler');

router.get('/', cropHandler.getCrops);
router.post('/', cropHandler.addCrop);
router.delete('/', cropHandler.removeCrop);

module.exports = router;
