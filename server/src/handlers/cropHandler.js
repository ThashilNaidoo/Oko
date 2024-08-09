const { MongoClient } = require('mongodb');
const { mongoURI, dbConfig, geminiAPI, geminiPrompt } = require('../config/config');
const { capitalizeFirstCharacter } = require('../common/capitalizeFirstCharacter');
const { GoogleGenerativeAI } = require('@google/generative-ai');

const getCrops = async (req, res) =>
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

    const crops = user.crops.map(crop => ({...crop, name: capitalizeFirstCharacter(crop.name)}));
    res.status(200).json(crops);
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

const getCropDetails = async(req, res) =>
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

    const crop = user.crops.find(crop => crop.name === req.params.crop.toLowerCase());

    if(!crop)
    {
      return res.status(404).send('Crop not found');
    }

    const cropResult = {
      ...crop,
      name: capitalizeFirstCharacter(crop.name)
    }
    res.status(200).json(cropResult);
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

const addCrop = async (req, res) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try
  {
    const name = req.body.name;
    const newCrop = req.params.crop.toLowerCase();

    await client.connect();

    const userCollection = client.db('oko-db').collection('Users');

    const query = { name: name };

    const user = await userCollection.findOne(query);

    if(!user)
    {
      return res.status(404).send('User not found');
    }

    const existingCrops = user.crops ? user.crops.map(crop => crop.name.toLowerCase()) : [];

    let cropToAdd;
    if(!existingCrops.includes(newCrop.toLowerCase()))
    {
      const generativeGemini = new GoogleGenerativeAI(geminiAPI);
      const generativeModel = generativeGemini.getGenerativeModel(
        {
          model: 'gemini-1.5-flash',
          systemInstruction: geminiPrompt,
        }
      ); 

      const generativeChat = generativeModel.startChat();
      const generativeResult = await generativeChat.sendMessage(`Current temperature: ${user.weather.currTemp}, condition: ${user.weather.condition}, wind speed: ${user.weather.windSpeed}, precipitation: ${user.weather.precipitation}, humidity: ${user.weather.humidity}.
        For the crop ${newCrop}, do the following:
        
        Estimate the yield of growing the crop in ${user.location} based on the weather conditions provided and general conditions of that area. Just the value from 0 to 100.
        Estimate the weather suitability of growing the crop in ${user.location} based on the weather conditions provided and general conditions of that area. Just the value from 0 to 100.
        Estimate the sustainability of growing the crop in ${user.location} based on the weather conditions provided and general conditions of that area. More work would result in a lower sustainability. Just the value from 0 to 100.
        Using all the information provided, summarize in growing of the crop in 4 sentences. The last sentence should be a tip.

        Return as JSON with the following structure:
        {
          "yield": number,
          "weatherSuitability": number,
          "sustainability": number,
          "description": string
        }
        
        Do not greet the user.
      `);

      let generativeText = generativeResult.response.text();
      generativeText = generativeText.substring(generativeText.indexOf('{'), generativeText.indexOf('}') + 1);
      generativeText = JSON.parse(generativeText);
      console.log(generativeText);

      cropToAdd =
      {
        name: newCrop,
        description: generativeText.description,
        yield: generativeText.yield,
        weatherSuitability: generativeText.weatherSuitability,
        sustainability: generativeText.sustainability,
      }
    }

    if(!cropToAdd) {
      return res.status(400).send('No new crops to add');
    }

    const update = { $push: { crops: cropToAdd } };
    const result = await userCollection.updateOne(query, update);
    
    if (result.modifiedCount > 0)
    {
      res.send(`${newCrop} added successfully`);
    }
    else
    {
      res.status(400).send(`Failed to add ${newCrop}`);
    }
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

const removeCrop = async (req, res) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try
  {
    const name = req.body.name;
    const removedCrop = req.params.crop.toLowerCase();

    await client.connect();

    const userCollection = client.db('oko-db').collection('Users');

    const query = { name: name };
    const update = { $pull: { crops: { name: removedCrop } } };

    const result = await userCollection.updateOne(query, update);
    
    if (result.modifiedCount > 0 && result.matchedCount > 0)
    {
      res.send(`${newCrop} removed successfully`);
    }
    else if(result.matchedCount <= 0)
    {
      res.status(404).send('User not found');
    }
    else if(result.modifiedCount <= 0)
    {
      res.status(404).send(`${newCrop} not found`);
    }
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
  getCrops,
  getCropDetails,
  addCrop,
  removeCrop,
}