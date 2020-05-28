module Global exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Browser.Navigation as Nav
import Components.Sidebar
import Html exposing (..)
import Html.Attributes exposing (class, classList, href, style)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Transition


type alias Flags =
    ()


type alias Model =
    { key : Nav.Key
    }


init : Flags -> Nav.Key -> Model
init _ key =
    Model key


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view :
    { page : Document msg
    , global : Model
    , toMsg : Msg -> msg
    , isTransitioning : { layout : Bool, page : Bool }
    , shouldShowSidebar : Bool
    , route : Route
    }
    -> Document msg
view ({ page, isTransitioning } as options) =
    { title = page.title
    , body =
        [ div
            [ class "column container px-small spacing-small fill-y"
            , style "transition" Spa.Transition.properties.layout
            , classList [ ( "invisible", isTransitioning.layout ) ]
            ]
            [ viewNavbar
            , div [ class "flex row spacing-small align-top relative" ]
                [ viewPage options
                , viewSidebar options
                ]
            , viewFooter
            ]
        ]
    }


viewNavbar : Html msg
viewNavbar =
    header [ class "py-medium row spacing-small spread center-y" ]
        [ a [ class "font-h3 text-header hoverable", href "/" ]
            [ text "elm-spa" ]
        , div [ class "row spacing-small text--bigger" ]
            [ a [ class "link", href (Route.toString Route.Docs) ] [ text "docs" ]
            , a [ class "link", href (Route.toString Route.Guide) ] [ text "guide" ]
            , a [ class "link", href (Route.toString Route.NotFound) ] [ text "examples" ]
            ]
        ]


viewPage :
    { options
        | page : Document msg
        , isTransitioning : { layout : Bool, page : Bool }
    }
    -> Html msg
viewPage { page, isTransitioning } =
    main_
        [ class "flex"
        , style "transition" Spa.Transition.properties.page
        , classList [ ( "invisible", isTransitioning.page ) ]
        ]
        page.body


viewSidebar : { options | shouldShowSidebar : Bool, route : Route } -> Html msg
viewSidebar { shouldShowSidebar, route } =
    aside [ class "hidden-mobile" ]
        [ if shouldShowSidebar then
            div [ class "invisible" ] [ Components.Sidebar.view route ]

          else
            text ""
        , div
            [ class "absolute align-right align-top"
            , style "transition" Spa.Transition.properties.page
            , classList [ ( "invisible", not shouldShowSidebar ) ]
            ]
            [ Components.Sidebar.view route ]
        ]


viewFooter : Html msg
viewFooter =
    footer [ class "footer pt-large pb-medium text-center color--faint" ]
        [ text "[ Built with "
        , a [ class "text-underline hoverable", Html.Attributes.target "_blank", href "https://elm-lang.org" ] [ text "Elm" ]
        , text " ]"
        ]