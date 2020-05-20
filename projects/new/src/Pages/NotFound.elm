module Pages.NotFound exposing (Model, Msg, Params, page)

import Html exposing (h1, text)
import Html.Attributes exposing (class)
import Spa.Document as Document exposing (Document)
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
        [ h1 [ class "font-h2" ] [ text "Page not found" ]
        ]
    }
