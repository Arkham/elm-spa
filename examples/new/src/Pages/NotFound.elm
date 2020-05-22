module Pages.NotFound exposing (Model, Msg, Params, page, view)

import Html exposing (..)
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
    { title = "404"
    , body =
        [ text "Page not found"
        ]
    }
