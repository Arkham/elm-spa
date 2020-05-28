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
view { page, isTransitioning, route, shouldShowSidebar } =
    { title = page.title
    , body =
        [ div
            [ class "column container px-small spacing-small fill-y"
            , style "transition" Spa.Transition.properties.layout
            , classList [ ( "invisible", isTransitioning.layout ) ]
            ]
            [ header [ class "py-medium row spacing-small spread" ]
                [ a [ class "font-h3 text-header hoverable", href "/" ]
                    [ text "elm-spa" ]
                , div [ class "row spacing-small text--bigger" ]
                    [ a [ class "link", href (Route.toString Route.Docs) ] [ text "docs" ]
                    , a [ class "link", href (Route.toString Route.NotFound) ] [ text "guide" ]
                    , a [ class "link", href (Route.toString Route.NotFound) ] [ text "examples" ]
                    ]
                ]
            , div [ class "flex row spacing-small align-top relative" ]
                [ main_
                    [ class "flex"
                    , style "transition" Spa.Transition.properties.page
                    , classList [ ( "invisible", isTransitioning.page ) ]
                    ]
                    page.body
                , if shouldShowSidebar then
                    div [ class "width--sidebar invisible" ] []

                  else
                    text ""
                , aside
                    [ class "absolute align-right align-top"
                    , style "transition" Spa.Transition.properties.page
                    , classList [ ( "invisible", not shouldShowSidebar ) ]
                    ]
                    [ Components.Sidebar.view route ]
                ]
            , footer [ class "footer py-medium text-center color--faint" ]
                [ text "[ built with elm-spa ]" ]
            ]
        ]
    }
