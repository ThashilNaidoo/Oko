const { MongoClient } = require('mongodb');
const { mongoURI, dbConfig, geminiAPI, geminiPrompt, secretKey } = require('../config/config');
const agenda = require('../jobs/agenda');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const jwt = require('jsonwebtoken');

const signup = async (req, res) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try
  {  
    await client.connect();

    const name = req.body.name;
    const email = req.body.email;
    const location = req.body.location;
    const timezone = req.body.timezone;
    const farmName = req.body.farmName;

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if(!emailRegex.test(email))
    {
      res.status(400).send('Email is not valid');
    }

    const userCollection = client.db('oko-db').collection('Users');

    const generativeGemini = new GoogleGenerativeAI(geminiAPI);
    const generativeModel = generativeGemini.getGenerativeModel(
      {
        model: 'gemini-1.5-flash',
        systemInstruction: geminiPrompt,
      }
    ); 

    const generativeChat = generativeModel.startChat();
    const generativeResult = await generativeChat.sendMessage(`Create a list of the 5 most common farming pests in ${location}. For each pest, give a detailed description of what it looks like.

      Return as JSON with the following structure:
      {
        "pests": [
          {
            "name": string,
            "description": string
          },
          {
            "name": string,
            "description": string
          }
        ]
      }

      If the location is not a valid location, return the following JSON:
      {
        "errorReason": string
      }

      Do not greet the user.
    `);

    let generativeText = generativeResult.response.text();
    generativeText = generativeText.substring(generativeText.indexOf('{'), generativeText.indexOf('}', generativeText.indexOf(']')) + 1);
    generativeText = JSON.parse(generativeText);
    console.log(generativeText);

    if(generativeText.errorReason)
    {
      return res.status(400).send('Not a valid location');
    }

    const pests = generativeText.pests.map(pest => ({...pest, name: pest.name.toLowerCase(), danger: 0}));

    const user = {
      name: name,
      email: email,
      location: location,
      timezone: timezone,
      farmName: farmName,
      pests: pests,
    }

    await userCollection.insertOne(user);

    agenda.schedule('in 10 seconds', 'generate pest images', { pests: pests });

    const tokenData = {email: email};
    const token = jwt.sign(tokenData, secretKey, {expiresIn:'24h'});

    res.status(200).json({ token: token });
  }
  catch(error)
  {
    res.status(500).json({mesage: error.message});
  }
  finally
  {
    await client.close();
  }
}

const login = async (req, res) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try
  {  
    await client.connect();

    const email = req.body.email;

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if(!emailRegex.test(email))
    {
      res.status(400).send('Email is not valid');
    }

    const userCollection = client.db('oko-db').collection('Users');

    const query = { email: email };

    const user = await userCollection.findOne(query);

    if(!user)
    {
      return res.status(404).send('User not found');
    }

    const tokenData = {email: email};
    const token = jwt.sign(tokenData, secretKey, {expiresIn:'24h'});

    res.status(200).json({ token: token });
  }
  catch(error)
  {
    res.status(500).json({mesage: error.message});
  }
  finally
  {
    await client.close();
  }
}

module.exports = {
  signup,
  login
}