const client = require('../config/dbClient');
const { weatherAPI } = require('../config/config');

const getWeather = async (req, res) => {
  try{  
    // const location = req.query['location'];

    // const url = `https://api.weatherapi.com/v1/forecast.json?q=${location}&days=7&key=${weatherAPI}`;

    // const response = await fetch(url);
    // const data = await response.json();

    // const current = data.current;
    // const forecast = data.forecast.forecastday;
    // const hour = forecastconst[0].hour;

    // const sevenDay = forecast.map(item => [
    //   item.day.maxtemp_c,
    //   item.day.mintemp_c
    // ]);

    // const temperature = hour.map((item) => 
    //   item.temp_c
    // );

    // const weather = {
    //   currTemp: current.temp_c,
    //   maxTemp: forecast[0].day.maxtemp_c,
    //   minTemp: forecast[0].day.mintemp_c,
    //   condition: current.condition.text,
    //   conditionSentence: "Describe condition using Gemini",
    //   sevenDay: sevenDay,
    //   temperature: temperature,
    //   windSpeed: current.wind_kph,
    //   windDirection: current.wind_dir,
    //   precipitation: forecast[0].day.totalprecip_mm,
    //   chanceOfRain: forecast[0].day.daily_chance_of_rain,
    //   humidity: forecast[0].day.avghumidity,
    //   feelsLike: current.feelslike_c
    // }

    const weather = {
      "currTemp": 14.7,
      "maxTemp": 19.4,
      "minTemp": 10.4,
      "condition": "Overcast",
      "conditionSentence": "Describe condition using Gemini",
      "sevenDay": [
        [
          19.4,
          10.4
        ],
        [
          18,
          9.6
        ],
        [
          18.1,
          10.8
        ],
        [
          19.5,
          11.8
        ],
        [
          17.1,
          8.1
        ],
        [
          14.8,
          4.1
        ],
        [
          17,
          8.3
        ]
      ],
      "temperature": [
        15.8,
        15.2,
        14.5,
        13.6,
        13.1,
        11.8,
        11,
        10.4,
        11.3,
        12.8,
        14.7,
        16.5,
        17.7,
        18.6,
        19.2,
        19.4,
        19,
        18.2,
        16.6,
        15.5,
        14.5,
        14.1,
        13.8,
        13.3
      ],
      "windSpeed": 11.2,
      "windDirection": "SW",
      "precipitation": 0,
      "chanceOfRain": 0,
      "humidity": 16,
      "feelsLike": 14.2
    }

    res.status(200).json(weather);
  } catch(error) {
    res.status(500).json({message: error.message});
  }
}

module.exports = {
  getWeather,
}