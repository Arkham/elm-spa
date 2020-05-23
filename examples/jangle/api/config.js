const isProduction = process.env.NODE_ENV === 'production'
const isLocalDevelopment = !isProduction

// Fetch local dev secrets
let env = {}

if (isLocalDevelopment) {
  try {
    env = require('./.env.js')
  } catch (_) {
    console.warn('\nPlease create an `./api/.env.js` file to work with Github API.')
  }
}

// Split config into two
const configs = {
  production: {
    clientId: process.env.CLIENT_ID,
    clientSecret : process.env.CLIENT_SECRET
  },
  dev: {
    clientId: '20c33fe428b932816bb2',
    clientSecret: env.clientSecret
  }
}

module.exports = (isProduction)
  ? configs.production
  : configs.dev