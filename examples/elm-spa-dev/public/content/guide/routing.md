# Routing

With __elm-spa__, your folder structure determines the routes for your application.

This section has several examples of how this works!

## Static Routes

You can create a static route like `/contact` or `/not-found` by creating an elm file in `src/Pages`:

File | URL
:-- | :--
`People.elm` | `/people`
`About/Careers.elm` | `/about/careers`
`OurTeam.elm` | `/our-team`

## Top Level Routes

Routes like the homepage use the reserved `Top` keyword to indicate that a page should not be a static route.

File | URL
:-- | :--
`Top.elm` | `/`
`Home/Top.elm` | `/home`
`Top/Top.elm` | `/top`

__Edgecase supported!__ If your app needs a static `/top` route, you can create a folder named `Top` with a `Top.elm` inside of it. (Check out that third example!)


## Dynamic Routes

Sometimes it's nice to have one page that works for slightly different URLs. __elm-spa__ uses this convention in file names to indicate a dynamic route:

File | URL Example | Params
:-- | :-- | :--
`Authors/Name_String.elm` | `/authors/ryan` | `{ name = "ryan" }`
  | `/authors/alexa` | `{ name = "alexa" }`
`Posts/Id_Int.elm` | `/posts/123` | `{ id = 123 }`
  | `/posts/456` | `{ id = 456 }`


__Supported Parameter Types__: Only `String` and `Int` dynamic parameters are available.

### Nested Dynamic Routes

You can also nest your dynamic routes. Here's an example:

```
Users/User_String/Posts/Post_Id.elm
```

URL Example | Params
:-- | :--
`/users/ryan/posts/123` | `{ user = "ryan", id = 123 }`
`/users/alexa/posts/456` | `{ user = "alexa", id = 456 }`