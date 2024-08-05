const { weatherAPI, geminiAPI, geminiPrompt, mongoURI, dbConfig } = require('../config/config');
const { clear, cloudy } = require('../constants/weatherConditions');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const { MongoClient } = require('mongodb');

const capitalizeFirstCharacter = (text) => {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

const getWeather = async (req, res) => {
  const client = new MongoClient(mongoURI, dbConfig);

  try{ 
    await client.connect();

    const name = req.query['name'];
    const currentTimestamp = req.query['date'];
    const timezone = req.query['timezone'];

    const userCollection = client.db('oko-db').collection('Users');
    const query = { name: name };

    const user = await userCollection.findOne(query);

    if(!user) {
      return res.status(404).send('User not found');
    }

    // Update the last time the weather was fetched
    const startDate = new Date(Number(currentTimestamp));
    startDate.setHours(0, 0, 0, 0);
    const startOfDay = startDate.getTime();
    const endOfDay =  startOfDay + 86399000;
    
    // Update weather info in mongodb
    if(!(user.weather.updatedAt >= startOfDay && user.weather.updatedAt <= endOfDay)) {
      const location = req.query['location'];
      const url = `https://api.weatherapi.com/v1/forecast.json?q=${location}&days=7&key=${weatherAPI}`;
      
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
    
      const currentTime = new Date(Number(currentTimestamp)).getTime();

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
      let result = await model.generateContent(`Current temperature: ${current.temp_c}, condition: ${condition}, wind speed: ${current.wind_kph}, precipitation: ${forecast[0].day.totalprecip_mm}, humidity: ${forecast[0].day.avghumidity}
        Describe the weather conditions in 1 sentence no more than 10 words.
        Describe the wind in relation to farming. 2 sentences. Make reference to spraying pesticides or anything else a farmer would want to know.
        Describe the rain in relation to farming. 2 sentences. Make reference to irrigation or anything else a farmer would want to know.
        Describe the humidity in relation to farming. 2 sentences. Make reference to pests in the ${location} area or anything else a farmer would want to know.
        All 4 of these should be seperated by new line characters.`);
      response = await result.response;
      const geminiResponse = await response.text();
      const descriptionResponse = geminiResponse.split('\n');

      console.log(geminiResponse);
      console.log(descriptionResponse);

      const weather = {
        currTemp: current.temp_c,
        maxTemp: forecast[0].day.maxtemp_c,
        minTemp: forecast[0].day.mintemp_c,
        condition: capitalizeFirstCharacter(condition),
        conditionDescription: descriptionResponse[0],
        sevenDay: sevenDay,
        temperature: temperature,
        windSpeed: current.wind_kph,
        windDirection: current.wind_dir,
        windDescription: descriptionResponse[2],
        precipitation: forecast[0].day.totalprecip_mm,
        chanceOfRain: forecast[0].day.daily_chance_of_rain,
        precipitationDescription: descriptionResponse[4],
        humidity: forecast[0].day.avghumidity,
        feelsLike: current.feelslike_c,
        humidityDescription: descriptionResponse[6],
        updatedAt: currentTime
      }

      const update = { $set: { "weather": weather } };
      await userCollection.updateOne(query, update);

      console.log(`Updated full weather for ${name}`);

      res.status(200).json(weather);
    }
    else {
      const currentTime = new Date(Number(currentTimestamp));
      const hour = currentTime.getUTCHours() + Number(timezone);
      
      const query = { name: name };
      const user = await userCollection.findOne(query);

      const weather = user.weather;
      weather.currTemp = weather.temperature[hour];

      const update = { $set: { "weather": weather } };
      await userCollection.updateOne(query, update);

      console.log(`Updated weather for ${name}`);

      res.status(200).json(weather);
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

// const weather = {
//   "currTemp": 14.7,
//   "maxTemp": 19.4,
//   "minTemp": 10.4,
//   "condition": "Overcast",
//   "conditionSentence": "Describe condition using Gemini",
//   "sevenDay": [
//     [
//       19.4,
//       10.4
//     ],
//     [
//       18,
//       9.6
//     ],
//     [
//       18.1,
//       10.8
//     ],
//     [
//       19.5,
//       11.8
//     ],
//     [
//       17.1,
//       8.1
//     ],
//     [
//       14.8,
//       4.1
//     ],
//     [
//       17,
//       8.3
//     ]
//   ],
//   "temperature": [
//     15.8,
//     15.2,
//     14.5,
//     13.6,
//     13.1,
//     11.8,
//     11,
//     10.4,
//     11.3,
//     12.8,
//     14.7,
//     16.5,
//     17.7,
//     18.6,
//     19.2,
//     19.4,
//     19,
//     18.2,
//     16.6,
//     15.5,
//     14.5,
//     14.1,
//     13.8,
//     13.3
//   ],
//   "windSpeed": 11.2,
//   "windDirection": "SW",
//   "precipitation": 0,
//   "chanceOfRain": 0,
//   "humidity": 16,
//   "feelsLike": 14.2
// }