const { generateImage } = require('../common/generateImage');

module.exports = (agenda) =>
{
  agenda.define('generate crop images', async (job, done) =>
  {
    const { crop } = job.attrs.data;
  
    console.log(`Generating crop image of ${crop.name}`);
    const prompt = `ultra realistic ${crop.name} in field, high-grade, clean, vibrant, bright colors, saturated`;
    await generateImage(prompt, `${crop.name}`, 1024, 1024);

    done();
  });
}