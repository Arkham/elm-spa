module Pages.Top exposing (Model, Msg, Params, page, view)

import Html exposing (..)
import Html.Attributes exposing (class)
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
    { title = "Homepage"
    , body =
        [ h1 [ class "font-h2" ] [ text "Homepage" ]
        ]
    }
