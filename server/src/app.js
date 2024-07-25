const express = require('express');
const app = express();
const cropRoutes = require('./routes/cropRoutes');
const newsRoutes = require('./routes/newsRoutes');
const weatherRoutes = require('./routes/weatherRoutes');
const errorHandler = require('./middleware/errorHandler');
const config = require('./config/config');

app.use(express.json());

app.use('/crops', cropRoutes);
app.use('/news', newsRoutes);
app.use('/weather', weatherRoutes);

app.use(errorHandler);

module.exports = app;
