const client = require('../config/dbClient');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const { geminiAPI } = require('../config/config');

const capitalizeFirstCharacter = (text) => {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

const gemini = new GoogleGenerativeAI(geminiAPI);

const sendMessage = async (message) => {
  const model = gemini.getGenerativeModel({ model: 'gemini-1.5-flash' });

  const chat = model.startChat({
    history: [],
    generationConfig: {
      maxOutputTokens: 500
    }
  });

  const result = await chat.sendMessage(message);
  const response = await result.response;
  const text = await response.text();

  return text;
}

module.exports = {
  sendMessage,
}