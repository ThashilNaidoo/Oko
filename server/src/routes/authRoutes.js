const express = require('express');
const router = express.Router();
const authHandler = require('../handlers/authHandler');

router.post('/login', authHandler.login);
router.post('/signup', authHandler.signup);

module.exports = router;
