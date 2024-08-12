const { MongoClient } = require('mongodb');
const { mongoURI, dbConfig } = require('../config/config');
const { capitalizeFirstCharacter } = require('../common/capitalizeFirstCharacter');

const getPests = async (req, res) =>
{
  const email = req.user.email;

  const client = new MongoClient(mongoURI, dbConfig);

  try
  {  
    await client.connect();

    const query = { email: email };

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

const getFeaturedPest = async(req, res) =>
{
  const email = req.user.email;

  const client = new MongoClient(mongoURI, dbConfig);

  try
  {  
    await client.connect();

    const query = { email: email };

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null)
    {
      return res.status(404).send('User not found');
    }

    const pest = user.pests.reduce((max, pest) => pest.danger > max.danger ? pest : max);
    pest.name = capitalizeFirstCharacter(pest.name);
    pest.description = pest.description.substring(0, pest.description.indexOf('.') + 1);
    res.status(200).json(pest);
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
  const email = req.user.email;

  const client = new MongoClient(mongoURI, dbConfig);

  try
  {
    await client.connect();

    let query = { email: email };

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null)
    {
      return res.status(404).send('User not found');
    }

    const pest = user.pests.find(pest => pest.name === req.params.pest.toLowerCase());

    if(!pest)
    {
      return res.status(404).send('Pest not found');
    }

    const pestResult =
    {
      ...pest,
      name: capitalizeFirstCharacter(pest.name)
    }
    res.status(200).json(pestResult);
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
  getPests,
  getFeaturedPest,
  getPestDetails,
}