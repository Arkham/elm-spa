module Pages.Top exposing (Model, Msg, Params, page)

import Api.Data
import Browser.Navigation as Nav
import Global
import Html exposing (..)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


type alias Params =
    ()


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
        , save = save
        , load = load
        }


init : Global.Model -> Url Params -> ( Model, Cmd Msg )
init global _ =
    case Api.Data.toMaybe global.user of
        Just _ ->
            ( {}, Nav.pushUrl global.key (Route.toString Route.Projects) )

        Nothing ->
            ( {}, Nav.pushUrl global.key (Route.toString Route.SignIn) )


load : Global.Model -> Model -> Model
load global model =
    model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


save : Model -> Global.Model -> Global.Model
save model global =
    global


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Top"
    , body = []
    }
