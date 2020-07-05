# elm-spa init

This command creates a new elm-spa project.

```
elm-spa init our-project
```

We can replace `our-project` with anything we like.

### project structure

The `elm-spa init` command creates these files in our new folder:

```
elm.json
package.json
src/
├─ Api/
├─ Components/
├─ Pages/
|  ├─ Top.elm
|  └─ NotFound.elm
├─ Spa/
|  ├─ Document.elm
|  ├─ Page.elm
|  └─ Url.elm
├─ Utils/
├─ Main.elm
├─ Shared.elm
└─ Ports.elm
public/
├─ index.html
├─ main.js
└─ style.css
```

#### high level overview

File | Description
:-- | :--
`elm.json` | Defines all of our project dependencies.
`package.json` | Has `build`, `dev`, and `test` scripts so anyone with [NodeJS](https://nodejs.org) can work with our project.
`src/` | Where our frontend Elm application lives
`public/` | A static directory for serving HTML, JS, CSS, images, and more!

#### a look into `src`

File | Description
:-- | :--
`src/Pages/Top.elm` | The homepage for our single page application.
`src/Pages/NotFound.elm` | The page to display if users go to an invalid route.
`src/Spa/Document.elm` | The kind of thing each page's `view` returns (changing this allows support for [elm-ui](https://github.com/mdgriffith/elm-ui) or [elm-css](https://github.com/rtfeldman/elm-css))
`src/Spa/Page.elm` | Defines the four page types (`static`, `sandbox`, `element`, and `application`)
`src/Spa/Url.elm` | Defines a type that holds route parameters, query parameters (automatically passed into the `init` function of `element` and `application` pages)
`src/Main.elm` | The entrypoint to the app, that wires everything together.
`src/Shared.elm` | The place to define layouts and shared data between pages.
`src/Ports.elm` | The place to communicate with any JavaScript you need.

#### a look into `public`

File | Description
:-- | :--
`public/index.html` | The HTML loaded by the server.
`public/main.js` | The JS that starts our Elm single page application.
`public/style.css` | A place to add in some CSS styles.
