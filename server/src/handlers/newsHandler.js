const { newsAPI } = require('../config/config')

const capitalizeFirstCharacter = (text) => {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

const getNews = async (req, res) => {
  try{
    const location = req.query['location'];
    console.log(location);

    const url = `https://newsapi.org/v2/everything?` +
      `q=farming AND ${location}&` +
      `from=2024-06-22&` +
      `sortBy=relevancy&` +
      `pageSize=10&` +
      `apiKey=${newsAPI}`;

    const response = await fetch(url);
    const data = await response.json();

    //console.log(data);

    // if(!response.ok) {
    //   throw new Error(response.body);
    // }

    res.status(200).json(data);
  } catch(error) {
    res.status(500).json({mesage: error.message});
  }
}

module.exports = {
  getNews,
}