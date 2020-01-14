module Layout exposing (view)

import Element exposing (..)
import Element.Font as Font
import Html exposing (Html)
import Routes exposing (Route)
import Types
import Ui


view : Types.LayoutContext msg -> Html msg
view { page } =
    Ui.toLayout <|
        column
            [ width (fill |> maximum 720)
            , paddingXY 16 32
            , spacing 24
            , centerX
            ]
            [ row [ spacing 12 ] <|
                List.map viewLink
                    [ ( "Homepage", Routes.Top )
                    , ( "Docs", Routes.Docs )
                    , ( "Guide", Routes.Guide )
                    ]
            , Ui.fromHtml page
            ]


viewLink : ( String, Route ) -> Element msg
viewLink ( label, route ) =
    link
        [ Font.color (rgb255 0 0 205)
        , Font.underline
        ]
        { url = Routes.toPath route
        , label = text label
        }
