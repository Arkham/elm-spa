module Spa.Path exposing
    ( Path
    , static, dynamic
    )

{-|


## Modify transitions at different routes!

If you're using the [CLI companion tool](https://github.com/ryannhg/elm-spa/tree/master/cli),
these are **automatically generated**.

(So feel free to ignore these docs!)

If you're doing things by hand, this documentation might be helpful!

The goal of the `Path` module is to tell elm-spa when to override certain
transitions. This is what allows layouts to persist UI between transitions.

@docs Path

@docs static, dynamic

-}

import Internals.Path as Internals


{-| a `List` of path segments that you use with `Spa.Transition`

    import Spa.Path exposing (static)

    transitions : Spa.Transitions (Element msg)
    transitions =
        { layout = Transition.none
        , page = Transition.none
        , pages =
            [ -- applies fade to pages matching `/guide/*`
              { path = [ static "guide" ]
              , transition = Transition.fade 300
              }
            ]
        }

-}
type alias Path =
    List Internals.Piece


{-| A static segment of a path.

    import Spa.Path exposing (static)

    [ static "docs" ]
    -- matches /docs/*

    [ static "docs", static "intro" ]
    -- matches /docs/intro/*

-}
static : String -> Internals.Piece
static =
    Internals.static


{-| A dynamic segment of a path.

    import Spa.Path exposing (dynamic)

    [ static "docs", dynamic ]
    -- matches /docs/welcome/*
    -- matches /docs/hello/*
    -- matches /docs/hooray/*

    [ static "docs", dynamic, static "intro" ]
    -- matches /docs/welcome/intro/*
    -- matches /docs/hello/intro/*
    -- matches /docs/hooray/intro/*

-}
dynamic : Internals.Piece
dynamic =
    Internals.dynamic
