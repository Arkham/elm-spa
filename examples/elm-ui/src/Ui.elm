module Ui exposing
    ( fromHtml
    , h1
    , toHtml
    , toLayout
    )

import Element exposing (..)
import Element.Font as Font
import Html exposing (Html)


styles : List (Attribute msg)
styles =
    [ Font.family
        [ Font.typeface "Roboto"
        , Font.typeface "Oxygen"
        , Font.sansSerif
        ]
    , Font.size 16
    ]


toHtml : Element msg -> Html msg
toHtml =
    Element.layoutWith
        { options = [ Element.noStaticStyleSheet ] }
        styles


toLayout : Element msg -> Html msg
toLayout =
    Element.layout styles


fromHtml : Html msg -> Element msg
fromHtml =
    Element.html >> el []



-- ui


h1 : String -> Element msg
h1 =
    el
        [ Font.size 32
        , Font.semiBold
        ]
        << text
