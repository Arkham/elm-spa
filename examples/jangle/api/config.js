module.exports = ({ isLocalDevelopment = false } = {}) => {
  if (isLocalDevelopment) {
    // attempt to get local dev secrets
    let env = {}
    try { env = require('./.env.js') } catch (_) {
      console.warn('\nPlease check ./api/README.md to work with the Github API.\n')
    }
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
