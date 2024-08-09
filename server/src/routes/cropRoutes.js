const express = require('express');
const router = express.Router();
const cropHandler = require('../handlers/cropHandler');

router.get('/', cropHandler.getCrops);
router.get('/:crop', cropHandler.getCropDetails);
router.post('/:crop', cropHandler.addCrop);
router.delete('/:crop', cropHandler.removeCrop);

module.exports = router;
