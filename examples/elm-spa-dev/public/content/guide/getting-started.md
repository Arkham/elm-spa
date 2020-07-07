# Getting Started

Getting started with elm-spa is easy! Make sure you have the latest stable version of [NodeJS](https://nodejs.org/en/) installed on your system. At the time of writing, I'm using node version `12.18.1`.

```terminal
npx elm-spa init our-elm-spa
```

## Project Structure

This one-time command will create a new project in a folder called `our-elm-spa`. 

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
├─ Shared.elm
└─ Ports.elm
public/
├─ index.html
├─ main.js
└─ style.css
```

### The project folder

There are four interesting files in the project folder:

File | Description
:-- | :--
`elm.json` | Defines all of our Elm project dependencies.
`package.json` | Has `build`, `dev`, and `test` scripts so anyone with [NodeJS](https://nodejs.org) installed can easily run our project.
`src/` | Where our frontend Elm application lives.
`tests/` | Where our Elm tests live.
`public/` | A static directory for serving HTML, JS, CSS, images, and more!

### The `src` Folder

The `src` folder will contain all your Elm code:

File | Description
:-- | :--
`Pages/Top.elm` | The homepage for our single page application.
`Pages/NotFound.elm` | The page to show if we're at an invalid route.
`Spa/Document.elm` | The kind of thing each page's `view` returns (changing this allows support for [elm-ui](https://github.com/mdgriffith/elm-ui) or [elm-css](https://github.com/rtfeldman/elm-css))
`Spa/Page.elm` | Defines the four page types (`static`, `sandbox`, `element`, and `application`)
`Spa/Url.elm` | Defines a type that holds route parameters, query parameters (automatically passed into the `init` function of `element` and `application` pages)
`Main.elm` | The entrypoint to the app, that wires everything together.
`Shared.elm` | The place to define layouts and shared data between pages.
`Ports.elm` | The place to communicate with any JavaScript you need.

### The `public` folder

The public folder is served statically. Use this as a place to serve images, CSS, JS, and other static content.

A file like `public/images/example.png` will be available under `/images/example.png`. __Include the starting slash!__ If it's missing, only top-level pages will load it correctly- leading to a confusing time.

File | Description
:-- | :--
`index.html` | The HTML loaded by the server.
`main.js` | The JS that starts our Elm single page application.
`style.css` | A place to add in some CSS styles.
