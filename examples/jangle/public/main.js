// Initial data to pass in to Elm (linked with `Global.Flags`)
// https://guide.elm-lang.org/interop/flags.html
const isLocalDevelopment = window.location.hostname === 'localhost'

const flags = {
  production: { githubClientId: '2a8238fe92e1e04c9af2' },
  dev: { githubClientId: '20c33fe428b932816bb2' }
}


// Start our Elm application
var app = Elm.Main.init({
  flags: isLocalDevelopment
    ? flags.dev
    : flags.production
})

// Ports would go here: https://guide.elm-lang.org/interop/ports.html