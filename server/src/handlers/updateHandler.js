const { MongoClient } = require('mongodb');
const { mongoURI, dbConfig, geminiAPI, geminiPrompt, weatherAPI } = require('../config/config');
const { clear, cloudy } = require('../constants/weatherConditions');
const { shouldUpdate } = require('../common/shouldUpdate');
const { GoogleGenerativeAI } = require('@google/generative-ai');

const updateWeather = async (name) =>
  {
  const client = new MongoClient(mongoURI, dbConfig);

  try
  { 
    await client.connect();

    const userCollection = client.db('oko-db').collection('Users');
    const query = { name: name };

    const user = await userCollection.findOne(query);

    if(!user)
    {
      return res.status(404).send('User not found');
    }

    const { update, nowUTC } = shouldUpdate(user.updatedAt, user.timezone);
    
    if(update)
    {
      const url = `https://api.weatherapi.com/v1/forecast.json?q=${user.location}&days=7&key=${weatherAPI}`;
      
      let response = await fetch(url);
      const data = await response.json();
      
      const current = data.current;
      const forecast = data.forecast.forecastday;
      const hour = forecast[0].hour;
      
      const sevenDay = forecast.map(item =>
        [
          item.day.maxtemp_c,
          item.day.mintemp_c
        ]
      );
      
      const temperature = hour.map((item) => 
        item.temp_c
      );

      // Map condition received to custom condition for the client
      let condition;
      if(clear.includes(current.condition.text.toLowerCase()))
      {
        condition = 'clear';
      }
      else if(cloudy.includes(current.condition.text.toLowerCase()))
      {
        condition = 'cloudy';
      }
      else
      {
        condition = 'overcast';
      }

      // Get descriptions from Gemini
      const gemini = new GoogleGenerativeAI(geminiAPI);
      const model = gemini.getGenerativeModel({ model: 'gemini-1.5-flash', systemInstruction: geminiPrompt });

      const result = await model.generateContent(`Current temperature: ${current.temp_c}, condition: ${condition}, wind speed: ${current.wind_kph}, precipitation: ${forecast[0].day.totalprecip_mm}, humidity: ${forecast[0].day.avghumidity}
        Describe the weather conditions in 1 sentence no more than 10 words.
        Describe the wind in relation to farming. 2 sentences. Make reference to spraying pesticides or anything else a farmer would want to know.
        Describe the rain in relation to farming. 2 sentences. Make reference to irrigation or anything else a farmer would want to know.
        Describe the humidity in relation to farming. 2 sentences. Make reference to pests in the ${user.location} area or anything else a farmer would want to know.
        
        Return as JSON with the following structure:
        {
          "condition": string,
          "wind": string,
          "rain": string,
          "humidity": string
        }
        
        Do not greet the user.
      `);

      let generativeText = result.response.text();
      generativeText = generativeText.substring(generativeText.indexOf('{'), generativeText.indexOf('}') + 1);
      generativeText = JSON.parse(generativeText);
      console.log(generativeText);

      const weather =
      {
        currTemp: current.temp_c,
        maxTemp: forecast[0].day.maxtemp_c,
        minTemp: forecast[0].day.mintemp_c,
        condition: condition,
        conditionDescription: generativeText.condition,
        sevenDay: sevenDay,
        temperature: temperature,
        windSpeed: current.wind_kph,
        windDirection: current.wind_dir,
        windDescription: generativeText.wind,
        precipitation: forecast[0].day.totalprecip_mm,
        chanceOfRain: forecast[0].day.daily_chance_of_rain,
        precipitationDescription: generativeText.rain,
        humidity: forecast[0].day.avghumidity,
        feelsLike: current.feelslike_c,
        humidityDescription: generativeText.humidity
      }

      const update = { $set: { "weather": weather } };
      await userCollection.updateOne(query, update);

      console.log(`Updated weather for ${name}`);
    }

    return true;
  }
  catch (error)
  {
    console.log(error);
    return false;
  }
  finally
  {
    await client.close();
  }
}

const updateCrops = async (name) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try {
    await client.connect();

    let query = { name: name };

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null)
    {
      return res.status(404).send('User not found');
    }

    const cropNames = user.crops.map(crop => crop.name);

    const { update, nowUTC } = shouldUpdate(user.updatedAt, user.timezone);

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
      const generativeResult = await generativeChat.sendMessage(`Current temperature: ${user.weather.currTemp}, condition: ${user.weather.condition}, wind speed: ${user.weather.windSpeed}, precipitation: ${user.weather.precipitation}, humidity: ${user.weather.humidity}.
        For each of the crops in ${cropNames}, do the following:
        
        Estimate the yield of growing the crop in ${user.location} based on the weather conditions provided and general conditions of that area. Just the value from 0 to 100.
        Estimate the weather suitability of growing the crop in ${user.location} based on the weather conditions provided and general conditions of that area. Just the value from 0 to 100.
        Estimate the sustainability of growing the crop in ${user.location} based on the weather conditions provided and general conditions of that area. More work would result in a lower sustainability. Just the value from 0 to 100.
        Using all the information provided, summarize in growing of the crop in 4 sentences. The last sentence should be a tip.

        Return as JSON with the following structure:
        {
          "crops": [
            {
              "yield": number,
              "weatherSuitability": number,
              "sustainability": number,
              "description": string
            },
            {
              "yield": number,
              "weatherSuitability": number,
              "sustainability": number,
              "description": string
            }
          ]
        }
        
        Do not greet the user.
      `);

      let generativeText = generativeResult.response.text();
      generativeText = generativeText.substring(generativeText.indexOf('{'), generativeText.indexOf('}', generativeText.indexOf(']')) + 1);
      generativeText = JSON.parse(generativeText);
      console.log(generativeText);

      let updatedCrops = [];

      for(let i = 0; i < cropNames.length; i++)
      {
        updatedCrops.push({
          name: cropNames[i],
          description: generativeText.crops[i].description,
          yield: generativeText.crops[i].yield,
          weatherSuitability: generativeText.crops[i].weatherSuitability,
          sustainability: generativeText.crops[i].sustainability
        });
      }

      const update =
      {
        $set:
        {
          'crops': updatedCrops
        }        
      }

      await userCollection.updateOne(query, update);
      console.log(`Updated crops for ${name}`);
    }

    return true;
  }
  catch(error)
  {
    console.log(error);
    return false;
  }
  finally
  {
    await client.close();
  }
}

const updatePests = async (name) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try
  {
    await client.connect();

    let query = { name: name };

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null)
    {
      return res.status(404).send('User not found');
    }

    const cropNames = user.crops.map(crop => crop.name);
    const pestNames = user.pests.map(pest => pest.name);

    const { update, nowUTC } = shouldUpdate(user.updatedAt, user.timezone);

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
      const generativeResult = await generativeChat.sendMessage(`Current temperature: ${user.weather.currTemp}, condition: ${user.weather.condition}, wind speed: ${user.weather.windSpeed}, precipitation: ${user.weather.precipitation}, humidity: ${user.weather.humidity}.
        For each of the pests in ${pestNames}, do the following:
        
        Estimate the danger of the pest for growing the crops in ${cropNames} in ${user.location}. Use the weather conditions as well. Just the value from 1 to 5.
        Using all the information provided, summarize the impact that the pest will have on the crops. Make reference to specific crops and/or weather conditions. 4 sentences. The last sentence should be a tip for managing the pest.

        Return as JSON with the following structure:
        {
          "pests": [
            {
              "danger": number,
              "description": string
            },
            {
              "danger": number,
              "description": string
            }
          ]
        }        
        
        Do not greet the user.
      `);

      let generativeText = generativeResult.response.text();
      generativeText = generativeText.substring(generativeText.indexOf('{'), generativeText.indexOf('}', generativeText.indexOf(']')) + 1);
      generativeText = JSON.parse(generativeText);
      console.log(generativeText);

      let updatedPests = [];

      for(let i = 0; i < pestNames.length; i++)
      {
        updatedPests.push({
          name: pestNames[i],
          danger: generativeText.pests[i].danger,
          description: generativeText.pests[i].description
        });
      }

      const update =
      {
        $set:
        {
          'pests': updatedPests,
          'updatedAt': nowUTC
        }        
      }

      await userCollection.updateOne(query, update);
      console.log(`Updated pests for ${name}`);
    }

    return true;
  }
  catch(error)
  {
    console.log(error);
    return false;
  }
  finally
  {
    await client.close();
  }
}

const update = async (req, res) =>
{
  const name = req.query.name;
  const weather = await updateWeather(name);
  const crops = await updateCrops(name);
  const pests = await updatePests(name);

  if(weather && crops && pests)
  {
    res.status(200).json({weather: weather, crops: crops, pests: pests});
  }
  else
  {
    res.status(500).json({weather: weather, crops: crops, pests: pests});
  }
}

module.exports =
{
  update,
}