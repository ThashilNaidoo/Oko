require('dotenv').config();

module.exports = {
  port: process.env.PORT,
  mongoURI: process.env.MONGO_URI,
  newsAPI: process.env.NEWS_API_KEY,
  weatherAPI: process.env.WEATHER_API_KEY
};
