module Pages.Guide exposing (Model, Msg, page)

import Html exposing (Html)
import Spa.Page
import Types


type alias Model =
    ()


type alias Msg =
    Never


page : Types.Page () Model Msg model msg appMsg
page =
    Spa.Page.static
        { title = always title
        , view = always view
        }


title : String
title =
    "guide | elm-spa intro"


view : Html Msg
view =
    Html.h1 [] [ Html.text "Guide." ]
