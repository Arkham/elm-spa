module Add.Full exposing (create)

import Path exposing (Path)


create : Path -> String
create path =
    """
module Pages.{{name}} exposing (Params, Model, Msg, page)

import Global
import Html
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)

type alias Params =
    {{params}}


type alias Model =
    {}


type Msg
    = NoOp


page : Page Params Model Msg
page =
    Page.full
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Global.Model -> Url Params -> ( Model, Cmd Msg )
init global { params } =
    ( {}, Cmd.none, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update global msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions global model =
    Sub.none


view : Model -> Document Msg
view global model =
    { title = "{{name}}"
    , body = [ Html.text "{{name}}" ]
    }
"""
        |> String.replace "{{name}}" (Path.toModulePath path)
        |> String.replace "{{params}}" (Path.toParams path)
        |> String.trim
