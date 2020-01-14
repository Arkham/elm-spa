module Global exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    )

import Routes exposing (Route)


type alias Flags =
    ()


type Model
    = Model


type Msg
    = Msg


type alias Context msg =
    { navigate : Route -> Cmd msg
    }


init : Context msg -> Flags -> ( Model, Cmd Msg, Cmd msg )
init _ _ =
    ( Model
    , Cmd.none
    , Cmd.none
    )


update : Context msg -> Msg -> Model -> ( Model, Cmd Msg, Cmd msg )
update _ msg model =
    case msg of
        Msg ->
            ( model, Cmd.none, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
