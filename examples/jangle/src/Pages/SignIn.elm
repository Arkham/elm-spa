module Pages.SignIn exposing (Model, Msg, Params, page)

import Dict exposing (Dict)
import Global
import Html exposing (..)
import Html.Attributes exposing (class, disabled, href)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


type alias Params =
    ()


type alias Model =
    { code : Maybe String
    }


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
init global { query } =
    ( { code = Dict.get "code" query
      }
    , Cmd.none
    )


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
    { title = "SignIn"
    , body =
        [ div [ class "column fill center" ]
            [ div [ class "column bg--white padding-medium shadow spacing-small max-width--20 rounded-tiny fill-x center-x" ]
                [ div [ class "column text-center spacing-tiny" ]
                    [ h1 [ class "font-h1 text-center" ] [ text "Jangle" ]
                    , h2 [ class "font-body" ] [ text "a cms for humans" ]
                    ]
                , div [ class "row" ] <|
                    case model.code of
                        Just code ->
                            [ button [ class "button", disabled True ] [ text "Signing you in..." ]
                            ]

                        Nothing ->
                            [ a [ class "button", href "https://github.com/login/oauth/authorize?client_id=20c33fe428b932816bb2" ]
                                [ text "Sign in with GitHub" ]
                            ]
                ]
            ]
        ]
    }
