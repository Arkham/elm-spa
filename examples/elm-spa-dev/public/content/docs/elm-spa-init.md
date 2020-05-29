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
├─ Global.elm
└─ Ports.elm
public/
├─ index.html
├─ main.js
└─ style.css
```