module Pages.Users.Slug.Posts.Slug exposing (Model, Msg, Params, page)

import Application
import Html exposing (..)


type alias Model =
    { user : String
    , post : Int
    }


type Msg
    = Msg


type alias Params =
    { user : String
    , post : Int
    }


page : Application.Page Params Model Msg a b
page =
    Application.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : Params -> ( Model, Cmd Msg )
init params =
    ( params, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    h1 [] [ text ("Post " ++ String.fromInt model.post ++ " for user: " ++ model.user) ]
