module Pages.Dashboard exposing (Model, Msg, Params, page)

import Browser.Navigation as Nav
import Global
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events as Events
import Ports
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


type alias Params =
    ()


page : Page Params Model Msg
page =
    Page.protectedFull
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = save
        , load = load
        }


type alias Model =
    { key : Nav.Key
    , token : Maybe String
    }


init : Global.Model -> Url Params -> ( Model, Cmd Msg )
init global _ =
    ( { key = global.key, token = global.token }
    , Cmd.none
    )


load : Global.Model -> Model -> Model
load global model =
    model


type Msg
    = SignOut


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SignOut ->
            ( { model | token = Nothing }
            , Cmd.batch
                [ Ports.clearToken ()
                , Nav.pushUrl model.key (Route.toString Route.SignIn)
                ]
            )


save : Model -> Global.Model -> Global.Model
save model global =
    { global | token = model.token }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Jangle"
    , body =
        [ div [ class "column fill center" ]
            [ div [ class "column bg--white padding-medium shadow spacing-small max-width--20 rounded-tiny fill-x center-x" ]
                [ h1 [ class "font-h1 text-center" ] [ text "Dashboard" ]
                , div [ class "row" ] <|
                    [ button [ class "button", Events.onClick SignOut ] [ text "Sign out" ]
                    ]
                ]
            ]
        ]
    }
