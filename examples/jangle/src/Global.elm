module Global exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Api.Token exposing (Token)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route


type alias Flags =
    { githubClientId : String
    , token : Maybe String
    }


type alias Model =
    { key : Nav.Key
    , githubClientId : String
    , token : Maybe Token
    }


init : Flags -> Nav.Key -> Model
init flags key =
    Model
        key
        flags.githubClientId
        (flags.token |> Maybe.map Api.Token.fromString)


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
subscriptions _ =
    Sub.none


view :
    { page : Document msg
    , global : Model
    , toMsg : Msg -> msg
    , isTransitioning : Bool
    }
    -> Document msg
view { page, isTransitioning } =
    { title = page.title
    , body =
        [ div
            [ class "column fill page"
            , classList [ ( "page--invisible", isTransitioning ) ]
            ]
            page.body
        ]
    }
