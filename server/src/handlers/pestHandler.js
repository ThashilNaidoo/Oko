const { MongoClient } = require('mongodb');
const { mongoURI, dbConfig, geminiAPI, geminiPrompt } = require('../config/config');
const { capitalizeFirstCharacter } = require('../common/capitalizeFirstCharacter');
const { shouldUpdate } = require('../common/shouldUpdate');
const { GoogleGenerativeAI } = require('@google/generative-ai');

const getPests = async (req, res) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try
  {  
    await client.connect();

    const query = { name: req.query['name'] };

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null)
    {
      return res.status(404).send('User not found');
    }

    const pests = user.pests.map(pest => ({...pest, name: capitalizeFirstCharacter(pest.name)}));
    res.status(200).json(pests);
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

const getPestDetails = async(req, res) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try
  {
    await client.connect();

    let query = { name: req.query.name };

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null)
    {
      return res.status(404).send('User not found');
    }

    const pest = user.pests.find(pest => pest.name === req.params.pest.toLowerCase());
    const crops = user.crops.map(crop => crop.name);

    if(!pest)
    {
      return res.status(404).send('Pest not found');
    }

    // Update the last time the pest was fetched
    const { update, nowUTC } = shouldUpdate(pest.updatedAt, user.timezone);

    if(update)
    {   
      const generativeGemini = new GoogleGenerativeAI(geminiAPI);
      const generativeModel = generativeGemini.getGenerativeModel(
        {
          model: 'gemini-1.5-flash',
          systemInstruction: geminiPrompt,
        }
      ); 

      const generativeChat = generativeModel.startChat();
      const generativeResult = await generativeChat.sendMessage(`Current temperature: ${user.weather.currTemp}, condition: ${user.weather.condition}, wind speed: ${user.weather.windSpeed}, precipitation: ${user.weather.precipitation}, humidity: ${user.weather.humidity}
        Estimate the danger of ${pest.name} for growing ${crops} in ${user.location}. Use the weather conditions as well. Just the value from 1 to 5.
        Using all the information provided, summarize the impact that the pest will have on the crops. Make reference to specific crops and/or weather conditions. 4 sentences. The last sentence should be a tip for managing the pest.

        Return as JSON with the following structure:
        {
          "danger": number,
          "description": string
        }
        
        Do not greet the user.`
      );

      let generativeText = generativeResult.response.text();
      generativeText = generativeText.substring(generativeText.indexOf('{'), generativeText.indexOf('}') + 1);
      generativeText = JSON.parse(generativeText);
      console.log(generativeText);

      const updatedPest =
      {
        name: capitalizeFirstCharacter(pest.name),
        danger: generativeText.danger,
        description: generativeText.description,
        updatedAt: nowUTC,
      }

      const update =
      {
        $set:
        {
          'pests.$[pest].name': pest.name,
          'pests.$[pest].danger': generativeText.danger,
          'pests.$[pest].description': generativeText.description,
          'pests.$[pest].updatedAt': nowUTC,
        }        
      }

      const options =
      {
        arrayFilters: [{ 'pest.name': pest.name }]
      };

      await userCollection.updateOne(query, update, options);

      res.status(200).json(updatedPest);
    }
    else
    {
      const updatedPest =
      {
        ...pest,
        name: capitalizeFirstCharacter(pest.name)
      }
      res.status(200).json(updatedPest);
    }
  }
  catch(error)
  {
    res.status(500).json({message: error.message});
  }
  finally
  {
    await client.close();
  }
}

module.exports = {
  getPests,
  getPestDetails,
}