module Pages.Top exposing (Model, Msg, Params, page, view)

import Html exposing (..)
import Html.Attributes exposing (alt, class, src)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }


type alias Params =
    ()


type alias Model =
    ()


type alias Msg =
    Never


view : Document Msg
view =
    { title = "elm-spa"
    , body =
        [ hero
        ]
    }


hero : Html msg
hero =
    div [ class "column spacing-tiny py-large center-x text-center" ]
        [ img [ alt "elm-spa logo", class "size--120", src "/images/logo.svg" ] []
        , h1 [ class "font-h1" ] [ text "elm-spa" ]
        , p [ class "font-h4 color--faint" ] [ text "single page apps made easy." ]
        ]
