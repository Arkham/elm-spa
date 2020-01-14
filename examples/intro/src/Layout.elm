module Layout exposing (view)

import Html exposing (Html)
import Html.Attributes as Attr
import Routes exposing (Route)
import Types


view : Types.LayoutContext msg -> Html msg
view { page } =
    Html.div [ Attr.class "layout" ]
        [ Html.p []
            (List.map viewLink
                [ ( "Homepage", Routes.Top )
                , ( "Docs", Routes.Docs )
                , ( "Guide", Routes.Guide )
                ]
            )
        , page
        ]


viewLink : ( String, Route ) -> Html msg
viewLink ( label, route ) =
    Html.a
        [ Attr.href (Routes.toPath route)
        ]
        [ Html.text label ]
