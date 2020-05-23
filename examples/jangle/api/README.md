# API

## Actually logging in to Github

I needed to use GitHub's OAuth API to work with GitHub, so I have an auth endpoint here. The API requires a client secret– which should __NOT__ be in source control!

For that reason, please create a file in this directory called `.env.js` like this:

```js
module.exports = {
  clientSecret: 'YOUR_CLIENT_SECRET_HERE'
}
```

You can get your own Client ID and Client Secret, when you create an OAuth application here: https://github.com/settings/developers

### Jangle uses two OAuth applications:

1. One for production, with the `Authorization Callback URL` set to `https://jangle.rhg.dev/sign-in`

2. For development, with the `Authorization Callback URL` set to `http://localhost:8000/sign-in`


### one last thing!

The Client ID is _not_ a secret, but those are hardcoded in __two__ places:

1. `public/main.js` – for use in the frontend Elm app
2. `api/config.js` - for use in backend Netlify functions

It would be ideal to have it in one place, but the build process is simpler if I just write these docs instead.