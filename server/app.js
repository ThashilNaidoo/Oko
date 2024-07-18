const express = require('express');
const app = express();
const cropRoutes = require('./routes/cropRoutes');
const errorHandler = require('./middleware/errorHandler');
const config = require('./config/config');

app.use(express.json());

app.use('/crops', cropRoutes);

app.use(errorHandler);

module.exports = app;
