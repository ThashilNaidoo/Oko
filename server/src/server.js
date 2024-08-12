const app = require('./app');
const { port, geminiAPI, geminiPrompt } = require('./config/config');
const http = require('http');
const WebSocket = require('ws');
const { GoogleGenerativeAI } = require('@google/generative-ai');

const server = http.createServer(app);

const wss = new WebSocket.Server({ server });

wss.on('connection', async (ws, req) => {
  console.log('New client connected');
  
  const gemini = new GoogleGenerativeAI(geminiAPI);
  const model = gemini.getGenerativeModel({ model: 'gemini-1.5-flash', systemInstruction: geminiPrompt });

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
