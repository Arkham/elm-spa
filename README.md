# elm-spa 

![Build](https://github.com/ryannhg/elm-spa-secrets/workflows/Build/badge.svg?branch=master)


## getting started

```
npm install -g elm-spa@latest
```

## available commands

- [elm-spa init](#elm-spa-init) – create a new project
- [elm-spa add](#elm-spa-add) – add a new page
- [elm-spa build](#elm-spa-build) – generate routes and pages


## elm-spa init

```
elm-spa init <directory>

  Create a new elm-spa app in the <directory>
  folder specified.

  examples:
  elm-spa init .
  elm-spa init my-app
```

## elm-spa add

```
elm-spa add <static|sandbox|element|full> <name>

  Create a new page of type <static|sandbox|element|full>
  with the module name <name>.

  examples:
  elm-spa add static Top
  elm-spa add sandbox Posts.Top
  elm-spa add element Posts.Id_Int
  elm-spa add full SignIn
```

## elm-spa build

```
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

## naming conventions

the `elm-spa build` command is pretty useful, because it
automatically generates `Routes.elm` and `Pages.elm` code for you,
based on the naming convention in `src/Pages/*.elm`

Here's an example project structure:

```
src/
└─ Pages/
   ├─ Top.elm
   ├─ About.elm
   ├─ Posts/
   |   ├─ Top.elm
   |   └─ Id_Int.elm
   └─ Authors/
       └─ Author_String/
           └─ Posts/
               └─ Post_Int.elm
```

When you run `elm-spa build` with these files in the `src/Pages` directory, __elm-spa__ can
automatically generate routes like these:

__Page__ | __Route__ | __Example__
:-- | :-- | :--
`Top.elm` | `/` | -
`About.elm` | `/about` | -
`Posts/Top.elm` | `/posts` | -
`Posts/Id_Int.elm` | `/posts/:id` | `/posts/123`
`Authors/Author_String/Posts/PostId_Int.elm` | `/authors/:author/posts/:postId` | `/authors/ryan/posts/123`

### top-level and dynamic routes

- `Top.elm` represents the top-level index in the folder.
- `User_Int.elm` defines a dynamic parameter named `user` that should be an `Int`.
- `User_Int` can also be a folder name, supporting nested dynamic routes.

### accessing url parameters

These dynamic parameters are available as `Params` for the given page.

Here are some specific examples from the routes above:

```elm
module Pages.About exposing (..)

type alias Params =
    ()
```

```elm
module Pages.Posts.Id_Int exposing (..)

type alias Params =
    { post : Int
    }
```

```elm
module Pages.Authors.Author_String.Posts.PostId_Int exposing (..)

type alias Params =
    { author : String
    , postId : Int
    }
```

These `Params` are __automatically__ passed into the `init` function, along with other information like the query parameters and original `Url` value.

