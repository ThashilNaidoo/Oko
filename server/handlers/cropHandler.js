exports.getCrops = (req, res) => {
  try{
    const crops = [{name: 'maize'}, {name: 'carrot'}, {name: 'carrot'}, {name: 'carrot'}, {name: 'carrot'}];
    console.log("crops");
    res.status(200).json(crops);
  } catch(error) {
    res.status(500).json({mesage: error.message});
  }
}