const { agendaURI } = require('../config/config');
const Agenda = require("agenda");

const agenda = new Agenda({ db: { address: agendaURI, collection: 'Queue' } });

let jobTypes = ['generatePestImage', 'generateCropImage'];

jobTypes.forEach( type => {
  require('./'+ type)(agenda);
})

if(jobTypes.length) {
  console.log(agenda);
  agenda.on('ready', async () => {
    await agenda.start()
  });
}

module.exports = agenda;
