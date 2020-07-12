# Installation

You can install `elm-spa` via [npm](https://nodejs.org/):

```terminal
npm install -g elm-spa
```

Now, you can run the `elm-spa` CLI from the terminal!

## Hello, CLI

If you're ever stuck- run `elm-spa help`, the CLI comes with __built-in documentation__!

```terminal
elm-spa help

  elm-spa – version 5.0.0

  elm-spa init – create a new project
  elm-spa add – add a new page
  elm-spa build – generate routes and pages automatically
  
  elm-spa <command> help – get detailed help for a command
  elm-spa -v – print version number
```

## elm-spa init

The `init` command scaffolds a new __elm-spa__ project. 

```terminal
elm-spa init help

  elm-spa init <directory>

  Create a new elm-spa app in the <directory>
  folder specified.

  examples:
  elm-spa init .
  elm-spa init my-app
```

You can use the `--template` flag to create a new app with `elm-ui`, `html`, or `elm-css`.

Each project works and behaves the same way, but the `elm.json` the `Spa.Document` module are updated to use the UI package of your choice.

## elm-spa add

You can add more pages to an existing __elm-spa__ project with the elm-spa add command. There are four templates available that create a single file in `src/Pages`:

Choose the __simplest__ page for the job!

1. `static` - a simple static page
1. `sandbox` - a page that manages state
1. `element` - a page that can send `Cmd` and receive `Sub`
1. `application` - a page with access to the `Shared` state


```terminal
elm-spa add help

  elm-spa add <static|sandbox|element|application> <name>

  Create a page of type <static|sandbox|element|application>
  with the module name <name>.

  examples:
  elm-spa add static Top
  elm-spa add sandbox Posts.Top
  elm-spa add element Posts.Id_Int
  elm-spa add application Authors.Name_String.Posts.Id_Int
```

Running the `elm-spa add` command will overwrite the contents of the existing file, so don't use it for upgrading an existing page.

## elm-spa build

This command does all the automatic code generation for you. If you follow the naming conventions outlined in the next section, this is where elm-spa saves you time!

```terminal
elm-spa build help

  elm-spa build [dir]

  Create "Generated.Route" and "Generated.Pages" modules for
  this project, based on the file names in "src/Pages"

  Here are more details on how that works:
  https://www.npmjs.com/package/elm-spa#naming-conventions

  examples:
  elm-spa build
  elm-spa build ../some/other-folder
  elm-spa build ./help
```

---

Next, let's talk about the [Routing](/guide/routing)!