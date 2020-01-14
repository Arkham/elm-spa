module Routes exposing (Route(..), routes, toPath)

import Url.Parser as Parser exposing (Parser)


type Route
    = Top
    | Docs
    | Guide
    | NotFound


routes : List (Parser (Route -> Route) Route)
routes =
    [ Parser.map Top Parser.top
    , Parser.map Docs (Parser.s "docs")
    , Parser.map Guide (Parser.s "guide")
    ]


toPath : Route -> String
toPath route =
    case route of
        Top ->
            "/"

        Docs ->
            "/docs"

        Guide ->
            "/guide"

        NotFound ->
            "/not-found"
