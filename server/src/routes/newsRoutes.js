const express = require('express');
const router = express.Router();
const newsHandler = require('../handlers/newsHandler');

router.get('/', newsHandler.getNews);

module.exports = router;
