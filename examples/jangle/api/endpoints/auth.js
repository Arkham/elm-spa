const axios = require('axios')
const secrets = require('secrets')

exports.handler = function (event, _context, callback) {
  const isLocalDevelopment = event.headers.host === 'localhost:8000'

  const config = isLocalDevelopment
    ? { clientId: '20c33fe428b932816bb2', clientSecret: secrets.clientSecret }
    : { clientId: process.env.CLIENT_ID, clientSecret : process.env.CLIENT_SECRET }

  const code = event.queryStringParameters.code

  const sendToken = response => {
    if (response.data && typeof response.data.access_token === 'string') {
      callback(null, {
        statusCode: 200,
        body: JSON.stringify(response.data.access_token)
      })
    } else {
      callback(null, {
        statusCode: 400,
        body: JSON.stringify(null)
      })
    }
  }

  const sendGithubError = reason => {
    callback(null, {
      statusCode: 400,
      body: typeof reason.message === 'string'
        ? reason.message
        : 'Something went wrong...'
    })
  }

  if (code) {
    axios.post(
      'https://github.com/login/oauth/access_token',
      {
        client_id: config.clientId,
        client_secret: config.clientSecret,
        code: code
      },
      { headers: { 'Accept': 'application/json' }
    })
      .then(sendToken)
      .catch(sendGithubError)
  } else {
    callback(null, {
      statusCode: 400,
      body: "Please provide code as a query parameter."
    })
  }
}