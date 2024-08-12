require('dotenv').config();
const { ServerApiVersion } = require('mongodb');

module.exports = {
  port: process.env.PORT,
  mongoURI: process.env.MONGO_URI,
  agendaURI: process.env.AGENDA_URI,
  newsAPI: process.env.NEWS_API_KEY,
  weatherAPI: process.env.WEATHER_API_KEY,
  geminiAPI: process.env.GEMINI_KEY,
  geminiPrompt: process.env.GEMINI_PROMPT,
  dbConfig: {
    serverApi: {
      version: ServerApiVersion.v1,
      strict: true,
      deprecationErrors: true,
    }
  },
  secretKey: process.env.SECRET_KEY
};
