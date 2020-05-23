const env = require('./.env.js')

module.exports = ({ isLocalDevelopment = false } = {}) => {
  if (isLocalDevelopment) {
    return {
      clientId: '20c33fe428b932816bb2',
      clientSecret: env.clientSecret
    }
  } else {
    return {
      clientId: process.env.CLIENT_ID,
      clientSecret : process.env.CLIENT_SECRET
    }
  }
}
