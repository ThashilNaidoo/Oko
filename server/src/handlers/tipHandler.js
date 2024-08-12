const { MongoClient } = require('mongodb');
const { mongoURI, dbConfig } = require('../config/config');

const getTip = async (req, res) =>
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

    const tip =
    {
      tip: user.tip
    }

    res.status(200).json(tip);
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
  getTip,
}