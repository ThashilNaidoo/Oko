const express = require('express');
const app = express();
const cropRoutes = require('./routes/cropRoutes');
const weatherRoutes = require('./routes/weatherRoutes');
const tipRoutes = require('./routes/tipRoutes');
const pestRoutes = require('./routes/pestRoutes');
const updateRoutes = require('./routes/updateRoutes');
const authRoutes = require('./routes/authRoutes');
const errorHandler = require('./middleware/errorHandler');
const path = require('path');

app.use(express.json());

app.use('/crops', cropRoutes);
app.use('/weather', weatherRoutes);
app.use('/tip', tipRoutes);
app.use('/pests', pestRoutes);
app.use('/update', updateRoutes);
app.use('/auth', authRoutes);

app.use('/public', express.static(path.join(__dirname, 'public')));

app.use(errorHandler);

module.exports = app;
