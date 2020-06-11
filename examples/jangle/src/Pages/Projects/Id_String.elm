module Pages.Projects.Id_String exposing (Model, Msg, Params, page)

import Components.Layout
import Html exposing (..)
import Html.Attributes exposing (class)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


type alias Params =
    { id : String }


type alias Model =
    Url Params


type alias Msg =
    ()


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }


view : Url Params -> Document Msg
view { params } =
    { title = params.id ++ " | Jangle"
    , body =
        [ viewMainContent params
        ]

    -- Components.Layout.view
    --     { viewMainContent = viewMainContent params
    --     , model = { user = user }
    --     , onSignOutClicked = ()
    --     }
    }


viewMainContent model =
    div [ class "row padding-medium spacing-tiny spread center-y bg--shell" ]
        [ h1 [ class "font-h3" ] [ text model.id ]
        ]
