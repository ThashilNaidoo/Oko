const { mongoURI, dbConfig } = require('../config/config');
const { MongoClient } = require('mongodb');
const { capitalizeFirstCharacter } = require('../common/capitalizeFirstCharacter');
const moment = require('moment-timezone');

const getWeather = async (req, res) =>
{
  const client = new MongoClient(mongoURI, dbConfig);

  try
  { 
    await client.connect();

    const name = req.query.name;

    const userCollection = client.db('oko-db').collection('Users');
    const query = { name: name };

    const user = await userCollection.findOne(query);

    if(!user)
    {
      return res.status(404).send('User not found');
    }

    const nowLocal = moment.tz(user.timezone);

    const weather = user.weather;
    if(weather.currTemp !== weather.temperature[nowLocal.hour()])
    {
      weather.currTemp = weather.temperature[nowLocal.hour()];
  
      const update = { $set: { "weather": weather } };
      await userCollection.updateOne(query, update);
    }

    res.status(200).json({...weather, condition: capitalizeFirstCharacter(weather.condition), location: user.location});
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

module.exports =
{
  getWeather,
}