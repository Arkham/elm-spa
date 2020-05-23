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
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route


type alias Flags =
    { githubClientId : String
    }


type alias Model =
    { key : Nav.Key
    , githubClientId : String
    }


init : Flags -> Nav.Key -> Model
init flags key =
    Model
        key
        flags.githubClientId


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
    page
