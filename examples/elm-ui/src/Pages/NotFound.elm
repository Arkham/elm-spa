module Pages.NotFound exposing (Model, Msg, page)

import Element exposing (..)
import Spa.Page
import Types
import Ui


type alias Model =
    ()


type alias Msg =
    Never


page : Types.Page () Model Msg model msg appMsg
page =
    Spa.Page.static
        { title = always title
        , view = always (Ui.toHtml view)
        }


title : String
title =
    "not-found | elm-spa elm-ui"


view : Element Msg
view =
    Ui.h1 "Not found."
