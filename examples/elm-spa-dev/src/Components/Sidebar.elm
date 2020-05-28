module Components.Sidebar exposing (view)

{-|

@docs Options, view

-}

import Html exposing (..)
import Html.Attributes exposing (class, disabled, href)
import Spa.Generated.Route as Route exposing (Route)


type alias Section =
    { title : String
    , links : List Link
    }


type alias Link =
    { label : String
    , route : Route
    }


view : Route -> Html msg
view currentRoute =
    let
        viewSection : Section -> Html msg
        viewSection section =
            Html.section [ class "column spacing-small align-left sticky" ]
                [ h3 [ class "font-h4" ] [ text section.title ]
                , div [ class "column spacing-tiny align-left pl-tiny" ]
                    (List.map viewLink section.links)
                ]

        viewLink : Link -> Html msg
        viewLink link =
            if link.route == currentRoute then
                span [ class "", disabled True ] [ text link.label ]

            else
                a [ class "link", href (Route.toString link.route) ]
                    [ text link.label ]
    in
    aside [ class "hidden-mobile width--sidebar column spacing-small align-left" ]
        (List.map viewSection sections)


sections : List Section
sections =
    let
        docs : String -> Route
        docs topic =
            Route.Docs__Topic_String { topic = topic }

        guide : String -> Route
        guide topic =
            Route.Docs__Topic_String { topic = topic }
    in
    [ { title = "docs"
      , links =
            [ { label = "init", route = docs "elm-spa-init" }
            , { label = "add", route = docs "elm-spa-add" }
            , { label = "build", route = docs "elm-spa-build" }
            ]
      }
    , { title = "guide"
      , links =
            [ { label = "installation", route = guide "installation" }
            , { label = "creating a project", route = guide "init" }
            , { label = "adding pages", route = guide "add" }
            ]
      }
    ]
