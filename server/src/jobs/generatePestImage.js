const { generateImage } = require('../common/generateImage');

module.exports = (agenda) =>
{
  agenda.define('generate pest images', async (job, done) =>
  {
    const { pests } = job.attrs.data;
    
    for (const pest of pests) 
    {
      console.log(`Generating pest image of ${pest.name}`);
      const prompt = `ultra realistic ${pest.description} in field, scary, high-grade, clean, vibrant, bright colors, saturated`;
      await generateImage(prompt, `${pest.name}_landscape`, 1365, 768);
      await generateImage(prompt, `${pest.name}_portrait`, 1024, 1024);
    }

    done();
  });
}