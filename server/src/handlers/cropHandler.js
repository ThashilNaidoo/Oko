const client = require('../config/dbClient');

const capitalizeFirstCharacter = (text) => {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

const getCrops = async (req, res) => {
  try{
    const query = { name: req.query['name'] };

    await client.connect();

    const userCollection = client.db('oko-db').collection('Users');

    const user = await userCollection.findOne(query);

    if(user === null) {
      res.status(404).send('User not found');
    } else {
      const crops = user.crops.map(crop => ({name: capitalizeFirstCharacter(crop)}));
      res.status(200).json(crops);
    }
  } catch(error) {
    res.status(500).json({mesage: error.message});
  } finally {
    await client.close();
  }
}

const addCrop = async (req, res) => {
  try {
    const name = req.body.name;
    const newCrops = req.body.crops;

    console.log(name);
    console.log(newCrops);

    await client.connect();

    const userCollection = client.db('oko-db').collection('Users');

    const query = { name: name };

    const user = await userCollection.findOne(query);

    if(!user) {
      return res.status(404).send('User not found');
    }

    const existingCrops = user.crops ? user.crops.map(crop => crop.toLowerCase()) : [];
    let cropsToAdd = newCrops
      .map(crop => crop.toLowerCase())
      .filter(crop => !existingCrops.includes(crop.toLowerCase()));

    if(cropsToAdd.length === 0) {
      return res.status(400).send('No new crops to add');
    }

    const update = { $push: { crops: { $each: cropsToAdd } } };
    const result = await userCollection.updateOne(query, update);
    
    if (result.modifiedCount > 0) {
      res.send('Crops added successfully');
    } else {
      res.status(400).send('Failed to add crops');
    }
  } catch(error) {
    res.status(500).json({mesage: error.message});
  } finally {
    await client.close();
  }
}

const removeCrop = async (req, res) => {
  try {
    const name = req.body.name;
    const removedCrops = req.body.crops.map(crop => crop.toLowerCase());

    await client.connect();

    const userCollection = client.db('oko-db').collection('Users');

    const query = { name: name };
    const update = { $pull: { crops: { $in: removedCrops } } };

    const result = await userCollection.updateOne(query, update);
    console.log(result);
    
    if (result.modifiedCount > 0 && result.matchedCount > 0) {
      res.send('Crops removed successfully');
    } else if(result.matchedCount <= 0) {
      res.status(404).send('User not found');
    } else if(result.modifiedCount <= 0) {
      res.status(404).send('Crop not found');
    }
  } catch(error) {
    res.status(500).json({mesage: error.message});
  } finally {
    await client.close();
  }
}

module.exports = {
  getCrops,
  addCrop,
  removeCrop,
}