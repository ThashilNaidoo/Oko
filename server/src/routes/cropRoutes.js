const express = require('express');
const router = express.Router();
const cropHandler = require('../handlers/cropHandler');

router.get('/', cropHandler.getCrops);
router.get('/:name', cropHandler.getCropDetails);
router.post('/:name', cropHandler.addCrop);
router.delete('/:name', cropHandler.removeCrop);

module.exports = router;
