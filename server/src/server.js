const app = require('./app');
const { port } = require('./config/config');
const http = require('http');
const WebSocket = require('ws');
const { sendMessage } = require('./handlers/chatHandler');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const { geminiAPI } = require('./config/config');

const server = http.createServer(app);

const wss = new WebSocket.Server({ server });

wss.on('connection', async (ws) => {
  console.log('New client connected');
  const okoPrompt = `
    You are a personal farming assistant named OKO. When a user greets you, you should introduce yourself.
    Imagine that the user has already greeted you once.
    Users will ask questions about farming and you must provide answers.
    Remind users that you are a farming assistant when they ask questions not related to farming, farming conditions, weather, or pests. 
    The user base is primarily farmers from African countries.`;
  
  const gemini = new GoogleGenerativeAI(geminiAPI);
  const model = gemini.getGenerativeModel({ model: 'gemini-1.5-flash', systemInstruction: okoPrompt });

  const chat = model.startChat({
    history: [],
    generationConfig: {
      maxOutputTokens: 500
    }
  });

  ws.on('message', async (message) => {
    const result = await chat.sendMessage(String(message));
    const response = await result.response;
    const okoResponse = await response.text();

    ws.send(okoResponse);
  });
});

server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
