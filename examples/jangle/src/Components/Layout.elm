module Components.Layout exposing (view)

import Api.User exposing (User)
import Html exposing (Html, a, aside, button, div, header, img, main_, span, text)
import Html.Attributes as Attr exposing (alt, class, href, src)
import Html.Events as Events
import Spa.Generated.Route as Route


view :
    { model : { model | user : User }
    , page : List (Html msg)
    , onSignOutClicked : msg
    }
    -> List (Html msg)
view options =
    [ viewMobile options
    , viewDesktop options
    ]


type alias Options model msg =
    { model : { model | user : User }
    , onSignOutClicked : msg
    , page : List (Html msg)
    }


viewMobile : Options model msg -> Html msg
viewMobile { onSignOutClicked, model, page } =
    div [ class "visible-mobile column fill" ]
        [ viewMobileNavbar onSignOutClicked model
        , main_ [ class "flex" ] page
        ]


viewDesktop : Options model msg -> Html msg
viewDesktop { onSignOutClicked, model, page } =
    div [ class "hidden-mobile fill relative" ]
        [ div [ class "relative bg--shell row fill-y align-top" ]
            [ div [ class "fixed z-2 width--sidebar align-top align-left fill-y bg--orange color--white" ] [ viewSidebar onSignOutClicked model ]
            , main_ [ class "offset--sidebar column flex" ] page
            ]
        ]


viewSidebar : msg -> { model | user : User } -> Html msg
viewSidebar onSignOutClicked model =
    aside [ class "column fill-y padding-medium spread center-x" ]
        [ a [ class "font-h3", href (Route.toString Route.Projects) ] [ text "Jangle" ]
        , div [ class "column center-x spacing-tiny" ]
            [ viewUser onSignOutClicked model.user
            ]
        ]


viewMobileNavbar : msg -> { model | user : User } -> Html msg
viewMobileNavbar onSignOutClicked model =
    header [ class "row padding-small relative z-2 bg--orange color--white spread center-y" ]
        [ a [ class "font-h3", href (Route.toString Route.Projects) ] [ text "Jangle" ]
        , div [ class "column center-x spacing-tiny" ]
            [ viewUser onSignOutClicked model.user
            ]
        ]


viewUser : msg -> User -> Html msg
viewUser onSignOutClicked user =
    button [ Events.onClick onSignOutClicked, class "button button--white font--small" ]
        [ div [ class "row spacing-tiny center-y" ]
            [ div [ class "row rounded-circle bg-orange size--avatar" ]
                [ img [ src user.avatarUrl, alt user.name ] [] ]
            , span [ class "ellipsis" ] [ text "Sign out" ]
            ]
        ]
