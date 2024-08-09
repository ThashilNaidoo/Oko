const moment = require('moment-timezone');

const shouldUpdate = (updatedAt, timezone) => {
  const lastUpdatedLocal = updatedAt ? moment.tz(updatedAt, timezone) : null;
  const nowLocal = moment.tz(timezone);
  const nowUTC = nowLocal.clone().utc().format();
  const startOfTodayLocal = nowLocal.clone().startOf('day');

  const shouldUpdate = !lastUpdatedLocal || lastUpdatedLocal.isBefore(startOfTodayLocal);

  return {
    update: shouldUpdate,
    nowUTC: nowUTC,
  }
}

module.exports = {
  shouldUpdate,
}