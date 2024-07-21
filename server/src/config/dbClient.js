
const { MongoClient, ServerApiVersion } = require('mongodb');
const { mongoURI } = require('./config');

const client = new MongoClient(mongoURI, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

module.exports = client;
