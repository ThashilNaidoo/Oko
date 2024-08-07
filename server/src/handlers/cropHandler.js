const { MongoClient } = require('mongodb');
const { mongoURI, dbConfig, geminiAPI, geminiPrompt } = require('../config/config');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const moment = require('moment-timezone');

const capitalizeFirstCharacter = (text) => {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

const getCrops = async (req, res) => {
  const client = new MongoClient(mongoURI, dbConfig);

  try{  
    await client.connect();

    const query = { name: req.query['name'] };

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null) {
      return res.status(404).send('User not found');
    }

    const crops = user.crops.map(crop => ({...crop, name: capitalizeFirstCharacter(crop.name)}));
    res.status(200).json(crops);
  } catch(error) {
    res.status(500).json({mesage: error.message});
  } finally {
    await client.close();
  }
}

const getCropDetails = async(req, res) => {
  const client = new MongoClient(mongoURI, dbConfig);

  try {
    await client.connect();

    let query = { name: req.query.name };

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null) {
      return res.status(404).send('User not found');
    }

    const crop = user.crops.find(crop => crop.name === req.params.name.toLowerCase());

    if(!crop) {
      return res.status(404).send('Crop not found');
    }

    // Update the last time the crop was fetched
    const lastUpdatedLocal = crop.updatedAt ? moment.tz(crop.updatedAt, user.timezone) : null;
    const nowLocal = moment.tz(user.timezone);
    const nowUTC = nowLocal.clone().utc().format();
    const startOfTodayLocal = nowLocal.clone().startOf('day');

    if(!lastUpdatedLocal || lastUpdatedLocal.isBefore(startOfTodayLocal)) {   
      const generativeGemini = new GoogleGenerativeAI(geminiAPI);
      const generativeModel = generativeGemini.getGenerativeModel({
          model: 'gemini-1.5-flash',
          systemInstruction: geminiPrompt,
        }
      ); 

      const generativeChat = generativeModel.startChat();
      const generativeResult = await generativeChat.sendMessage(`Current temperature: ${user.weather.currTemp}, condition: ${user.weather.condition}, wind speed: ${user.weather.windSpeed}, precipitation: ${user.weather.precipitation}, humidity: ${user.weather.humidity}
        Estimate the yield of growing ${crop.name} in ${user.location} based on the weather conditions provided and general conditions of that area. Just the value from 0 to 100.
        Estimate the weather suitability of growing ${crop.name} in ${user.location} based on the weather conditions provided and general conditions of that area. Just the value from 0 to 100.
        Estimate the sustainability of growing ${crop.name} in ${user.location} based on the weather conditions provided and general conditions of that area. More work would result in a lower sustainability. Just the value from 0 to 100.
        Using all the information provided, summarize in growing of the crop in 4 sentences. The last sentence should be a tip.

        Return as JSON with the following structure:
        {
          "yield": number,
          "weatherSuitability": number,
          "sustainability": number,
          "description": string
        }
        
        Do not greet the user.`);

      let generativeText = generativeResult.response.text();
      generativeText = generativeText.substring(generativeText.indexOf('{'), generativeText.indexOf('}') + 1);
      generativeText = JSON.parse(generativeText);
      console.log(generativeText);

      const updatedCrop = {
        name: capitalizeFirstCharacter(crop.name),
        description: generativeText.description,
        yield: generativeText.yield,
        weatherSuitability: generativeText.weatherSuitability,
        sustainability: generativeText.sustainability,
        updatedAt: nowUTC,
      }

      const update = {
        $set: {
          'crops.$[crop].name': crop.name,
          'crops.$[crop].description': generativeText.description,
          'crops.$[crop].yield': generativeText.yield,
          'crops.$[crop].weatherSuitability': generativeText.weatherSuitability,
          'crops.$[crop].sustainability': generativeText.sustainability,
          'crops.$[crop].updatedAt': nowUTC,
        }        
      }

      const options = {
        arrayFilters: [{ 'crop.name': crop.name }]
      };

      await userCollection.updateOne(query, update, options);

      res.status(200).json(updatedCrop);
    } else {
      const updatedCrop = {
        ...crop,
        name: capitalizeFirstCharacter(crop.name)
      }
      res.status(200).json(updatedCrop);
    }
  } catch(error) {
    res.status(500).json({message: error.message});
  } finally {
    await client.close();
  }
}

const addCrop = async (req, res) => {
  const client = new MongoClient(mongoURI, dbConfig);

  try {
    const name = req.body.name;
    const newCrop = req.params.name;

    await client.connect();

    const userCollection = client.db('oko-db').collection('Users');

    const query = { name: name };

    const user = await userCollection.findOne(query);

    if(!user) {
      return res.status(404).send('User not found');
    }

    const existingCrops = user.crops ? user.crops.map(crop => crop.name.toLowerCase()) : [];

    let cropToAdd;
    if(!existingCrops.includes(newCrop.toLowerCase())) {
      cropToAdd = {
        name: newCrop
      }
    }

    if(!cropToAdd) {
      return res.status(400).send('No new crops to add');
    }

    const update = { $push: { crops: cropToAdd } };
    const result = await userCollection.updateOne(query, update);
    
    if (result.modifiedCount > 0) {
      res.send(`${newCrop} added successfully`);
    } else {
      res.status(400).send(`Failed to add ${newCrop}`);
    }
  } catch(error) {
    res.status(500).json({mesage: error.message});
  } finally {
    await client.close();
  }
}

const removeCrop = async (req, res) => {
  const client = new MongoClient(mongoURI, dbConfig);

  try {
    const name = req.body.name;
    const removedCrops = req.params.crops.map(crop => crop.toLowerCase());

    await client.connect();

    const userCollection = client.db('oko-db').collection('Users');

    const query = { name: name };
    const update = { $pull: { crops: { name: { $in: removedCrops } } } };

    const result = await userCollection.updateOne(query, update);
    
    if (result.modifiedCount > 0 && result.matchedCount > 0) {
      res.send(`${newCrop} removed successfully`);
    } else if(result.matchedCount <= 0) {
      res.status(404).send('User not found');
    } else if(result.modifiedCount <= 0) {
      res.status(404).send(`${newCrop} not found`);
    }
  } catch(error) {
    res.status(500).json({mesage: error.message});
  } finally {
    await client.close();
  }
}

module.exports = {
  getCrops,
  getCropDetails,
  addCrop,
  removeCrop,
}