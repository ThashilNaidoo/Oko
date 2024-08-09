const { weatherAPI, geminiAPI, geminiPrompt, mongoURI, dbConfig } = require('../config/config');
const { clear, cloudy } = require('../constants/weatherConditions');
const { capitalizeFirstCharacter } = require('../common/capitalizeFirstCharacter');
const { shouldUpdate } = require('../common/shouldUpdate');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const { MongoClient } = require('mongodb');
const moment = require('moment-timezone');

const getWeather = async (req, res) => {
  const client = new MongoClient(mongoURI, dbConfig);

  try{ 
    await client.connect();

    const name = req.query.name;

    const userCollection = client.db('oko-db').collection('Users');
    const query = { name: name };

    const user = await userCollection.findOne(query);

    if(!user) {
      return res.status(404).send('User not found');
    }

    // Update the last time the weather was fetched
    const { update, nowUTC } = shouldUpdate(user.weather.updatedAt, user.timezone);
    
    // Update weather info in mongodb
    if(update) {
      const url = `https://api.weatherapi.com/v1/forecast.json?q=${user.location}&days=7&key=${weatherAPI}`;
      
      let response = await fetch(url);
      const data = await response.json();
      
      const current = data.current;
      const forecast = data.forecast.forecastday;
      const hour = forecast[0].hour;
      
      const sevenDay = forecast.map(item => [
        item.day.maxtemp_c,
        item.day.mintemp_c
      ]);
      
      const temperature = hour.map((item) => 
        item.temp_c
      );

      // Map condition received to custom condition for the client
      let condition;
      if(clear.includes(current.condition.text.toLowerCase())) {
        condition = 'clear';
      } else if(cloudy.includes(current.condition.text.toLowerCase())) {
        condition = 'cloudy';
      } else {
        condition = 'overcast';
      }

      // Get descriptions from Gemini
      const gemini = new GoogleGenerativeAI(geminiAPI);
      const model = gemini.getGenerativeModel({ model: 'gemini-1.5-flash', systemInstruction: geminiPrompt });

      // Condition
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

      const weather = {
        currTemp: current.temp_c,
        maxTemp: forecast[0].day.maxtemp_c,
        minTemp: forecast[0].day.mintemp_c,
        condition: capitalizeFirstCharacter(condition),
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
        humidityDescription: generativeText.humidity,
        updatedAt: nowUTC
      }

      const update = { $set: { "weather": weather } };
      await userCollection.updateOne(query, update);

      console.log(`Updated full weather for ${name}`);

      res.status(200).json({...weather, location: user.location});
    }
    else {
      const nowLocal = moment.tz(user.timezone);

      const weather = user.weather;
      weather.currTemp = weather.temperature[nowLocal.hour()];

      const update = { $set: { "weather": weather } };
      await userCollection.updateOne(query, update);

      console.log(`Updated weather for ${name}`);

      res.status(200).json({...weather, location: user.location});
    }
  } catch(error) {
    res.status(500).json({message: error.message});
  } finally {
    await client.close();
  }
}

module.exports = {
  getWeather,
}