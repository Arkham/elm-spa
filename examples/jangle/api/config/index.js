// let secrets = {}
// try { secrets = require('./secrets.js') } catch (_) {}
module.exports = {
  clientId: process.env.CLIENT_ID || secrets.clientId,
  clientSecret : process.env.CLIENT_SECRET || secrets.clientSecret
}
