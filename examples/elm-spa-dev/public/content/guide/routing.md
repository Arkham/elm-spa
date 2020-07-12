# Routing

With __elm-spa__, your folder structure determines the routes for your application.

## Static Routes

You can create a static route like `/contact` or `/not-found` by creating an elm file in `src/Pages`:

File | URL
:-- | :--
`People.elm` | `/people`
`About/Careers.elm` | `/about/careers`
`OurTeam.elm` | `/our-team`

__Capitalization matters!__ Notice how `OurTeam` became `our-team`? Capital letters within file names are translated to dashes in URLs.

## Top Level Routes

Routes like the homepage use the reserved `Top` keyword to indicate that a page should not be a static route.

File | URL
:-- | :--
`Top.elm` | `/`
`Example/Top.elm` | `/example`
`Top/Top.elm` | `/top`

__Handling Edgecases:__ You may have noticed that `Example.elm` and `Example/Top.elm` would both route to `/example`. In the case of conflicts like these, the Top.elm file will never be reached- delete it!

## Dynamic Routes

Sometimes it's nice to have one page that works for slightly different URLs. __elm-spa__ uses this convention in file names to indicate a dynamic route:

##### `Authors/Name_String.elm`

URL | Params
:-- | :--
`/authors/ryan` | `{ name = "ryan" }`
`/authors/alexa` | `{ name = "alexa" }`

##### `Posts/Id_Int.elm`

URL | Params
:-- | :--
`/posts/123` | `{ id = 123 }`
`/posts/456` | `{ id = 456 }`

You can access these dynamic parameters from the `Url Params` value passed into each page type!

__Supported Parameters__: Only `String` and `Int` dynamic parameters are supported.

### Nested Dynamic Routes

You can also nest your dynamic routes. Here's an example:


##### `Users/User_String/Posts/Post_Id.elm`

URL | Params
:-- | :--
`/users/ryan/posts/123` | `{ user = "ryan"`<br/>`, id = 123`<br/>`}`
`/users/alexa/posts/456` | `{ user = "alexa"`<br/>`, id = 456`<br/>`}`

## URL Params

As we'll see in the next section, every page will get access to `Url Params`– these allow you access a few things:

```elm
type alias Url params =
  { params : params
  , query : Dict String String
  , key : Browser.Navigation.Key
  , rawUrl : Url.Url
  }
```

#### params

These are based on the current route. See the "Params" examples above!

#### query

Query parameters for the URL. If the URL was `?name=ryan`, then `Dict.get "name" url.query == "ryan"`

#### key

Used for programmatic navigation with functions in [elm/browser](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#pushUrl)

#### rawUrl

The original URL in case you need any other information.

---

Let's take a closer look at [Pages](/guide/pages)!