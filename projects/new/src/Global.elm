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
import Html exposing (a, div, footer, header, text)
import Html.Attributes exposing (class, href)
import Ports
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route


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
    }
    -> Document msg
view { page, global, toMsg } =
    { title = page.title
    , body =
        [ div [ class "column container padding-small spacing-small fill-y" ]
            [ header [ class "row spacing-small spread" ]
                [ a [ class "link", href (Route.toString Route.Top) ] [ text "Home" ]
                , a [ class "link", href (Route.toString Route.NotFound) ] [ text "Nowhere" ]
                ]
            , Html.main_ [ class "flex" ] page.body
            , footer [ class "footer" ] [ text "Built with elm-spa" ]
            ]
        ]
    }
