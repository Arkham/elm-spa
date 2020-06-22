# Project Structure

Here's what your folder should look like:

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
├─ Global.elm
└─ Ports.elm
public/
├─ index.html
├─ main.js
└─ style.css
```

#### high level overview

File | Description
:-- | :--
`elm.json` | Defines all of our Elm project dependencies.
`package.json` | Has `build`, `dev`, and `test` scripts so anyone with [NodeJS](https://nodejs.org) installed can easily run our project.
`src/` | Where our frontend Elm application lives
`public/` | A static directory for serving HTML, JS, CSS, images, and more!

#### a look into `src`

File | Description
:-- | :--
`Pages/Top.elm` | The homepage for our single page application.
`Pages/NotFound.elm` | The page to show if we're at an invalid route.
`Spa/Document.elm` | The kind of thing each page's `view` returns (changing this allows support for [elm-ui](https://github.com/mdgriffith/elm-ui) or [elm-css](https://github.com/rtfeldman/elm-css))
`Spa/Page.elm` | Defines the four page types (`static`, `sandbox`, `element`, and `full`)
`Spa/Url.elm` | Defines a type that holds route parameters, query parameters (automatically passed into the `init` function of `element` and `full` pages)
`Main.elm` | The entrypoint to the app, that wires everything together.
`Global.elm` | The place to define layouts and shared data between pages.
`Ports.elm` | The place to communicate with any JavaScript you need.

#### a look into `public`

File | Description
:-- | :--
`index.html` | The HTML loaded by the server.
`main.js` | The JS that starts our Elm single page application.
`style.css` | A place to add in some CSS styles.
