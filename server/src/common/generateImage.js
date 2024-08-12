const fs = require('fs');
const path = require('path');

const generateImage = async (prompt, name, width, height) => {
  const imagePath = path.join(__dirname, '..', 'public', 'images', `${name}.png`);
  if(!fs.existsSync(imagePath))
  {
    const url = `http://127.0.0.1:7860/sdapi/v1/txt2img`;
    const body = {
      'prompt': prompt,
      'steps': 20,
      'width': width,
      'height': height,
      'sampler_name': 'DPM++ 2M',
      'scheduler': 'Karras',
      'cfg_scale': 5,
      'override_settings': {
        'sd_model_checkpoint': 'sdXL_v10VAEFix'
      }
    }
      
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(body)
    });

    const data = await response.json();
    const base64Image = data.images[0];

    const imageBuffer = Buffer.from(base64Image, 'base64');

    fs.writeFile(imagePath, imageBuffer, (err) => {
      if(err)
      {
        console.log('Error saving the image:', err);
      }
      else
      {
        console.log(`Image saved to ${imagePath}`);
      }
    });
  }
}

module.exports = {
  generateImage
}