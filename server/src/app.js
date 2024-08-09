const express = require('express');
const app = express();
const cropRoutes = require('./routes/cropRoutes');
const newsRoutes = require('./routes/newsRoutes');
const weatherRoutes = require('./routes/weatherRoutes');
const pestRoutes = require('./routes/pestRoutes');
const updateRoutes = require('./routes/updateRoutes');
const errorHandler = require('./middleware/errorHandler');
const config = require('./config/config');

app.use(express.json());

app.use('/crops', cropRoutes);
app.use('/news', newsRoutes);
app.use('/weather', weatherRoutes);
app.use('/pests', pestRoutes);
app.use('/update', updateRoutes);

app.use(errorHandler);

module.exports = app;
