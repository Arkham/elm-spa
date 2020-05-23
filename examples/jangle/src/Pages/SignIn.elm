module Pages.SignIn exposing (Model, Msg, Params, page)

import Dict
import Global
import Html exposing (..)
import Html.Attributes exposing (class, disabled, href)
import Http
import Json.Decode as D
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


type alias Params =
    ()


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



-- INIT


type alias Model =
    { githubClientId : String
    , code : Maybe String
    , token : Maybe (Result Http.Error String)
    }


init : Global.Model -> Url Params -> ( Model, Cmd Msg )
init global { query } =
    case Dict.get "code" query of
        Just code ->
            ( { githubClientId = global.githubClientId
              , code = Just code
              , token = Nothing
              }
            , requestAuthToken code
            )

        Nothing ->
            ( { githubClientId = global.githubClientId
              , code = Nothing
              , token = Nothing
              }
            , Cmd.none
            )


requestAuthToken : String -> Cmd Msg
requestAuthToken code =
    Http.get
        { url = "/api/auth?code=" ++ code
        , expect = Http.expectJson GotAuthToken D.string
        }


load : Global.Model -> Model -> Model
load global model =
    model



-- UPDATE


type Msg
    = GotAuthToken (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotAuthToken result ->
            ( { model | token = Just result }, Cmd.none )


save : Model -> Global.Model -> Global.Model
save model global =
    global


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Sign In | Jangle"
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
                            [ button [ class "button", disabled True ]
                                [ case model.token of
                                    Nothing ->
                                        text "Signing you in..."

                                    Just (Ok _) ->
                                        text "Sign in successful!"

                                    Just (Err _) ->
                                        text "Sign in failed."
                                ]
                            ]

                        Nothing ->
                            [ a [ class "button", href ("https://github.com/login/oauth/authorize?client_id=" ++ model.githubClientId) ]
                                [ text "Sign in with GitHub" ]
                            ]
                ]
            ]
        ]
    }
