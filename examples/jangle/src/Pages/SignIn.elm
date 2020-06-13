module Pages.SignIn exposing (Model, Msg, Params, page)

import Api.Data exposing (Data(..))
import Api.Token exposing (Token)
import Api.User exposing (User)
import Browser.Navigation as Nav
import Dict
import Global
import Html exposing (..)
import Html.Attributes exposing (class, disabled, href)
import Http
import Json.Decode as D
import Ports
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
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
    , token : Data Token
    , user : Data User
    , key : Nav.Key
    }


init : Global.Model -> Url Params -> ( Model, Cmd Msg )
init global { query } =
    case Api.Data.toMaybe global.user of
        Just user ->
            ( Model global.githubClientId Loading (Success user) global.key
            , Nav.pushUrl global.key (Route.toString Route.Projects)
            )

        Nothing ->
            case Dict.get "code" query of
                Just code ->
                    ( { githubClientId = global.githubClientId
                      , token = Loading
                      , user = NotAsked
                      , key = global.key
                      }
                    , requestAuthToken code
                    )

                Nothing ->
                    ( { githubClientId = global.githubClientId
                      , token = NotAsked
                      , user = NotAsked
                      , key = global.key
                      }
                    , Cmd.none
                    )


requestAuthToken : String -> Cmd Msg
requestAuthToken code =
    Http.get
        { url = "/api/github-auth?code=" ++ code
        , expect = Http.expectJson GotAuthToken D.string
        }


load : Global.Model -> Model -> ( Model, Cmd Msg )
load global model =
    ( model, Cmd.none )



-- UPDATE


type Msg
    = GotAuthToken (Result Http.Error String)
    | GotUser (Data User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotAuthToken (Ok token) ->
            ( { model | token = Success (Api.Token.fromString token) }
            , Cmd.batch
                [ Ports.storeToken token
                , Api.User.current
                    { token = Api.Token.fromString token
                    , toMsg = GotUser
                    }
                ]
            )

        GotAuthToken (Err _) ->
            ( { model | token = Failure "Failed to sign in." }
            , Cmd.none
            )

        GotUser user ->
            ( { model | user = user }
            , Nav.pushUrl model.key (Route.toString Route.Projects)
            )


save : Model -> Global.Model -> Global.Model
save model global =
    { global | user = model.user }


subscriptions : Model -> Sub Msg
subscriptions _ =
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
                    case model.token of
                        NotAsked ->
                            [ a [ class "button", href ("https://github.com/login/oauth/authorize?client_id=" ++ model.githubClientId) ]
                                [ text "Sign in with GitHub" ]
                            ]

                        Loading ->
                            [ button [ class "button button--white", disabled True ] [ text "Signing in..." ] ]

                        Success _ ->
                            [ button [ class "button button--white", disabled True ] [ text "Success!" ] ]

                        Failure reason ->
                            [ div [ class "column center-x" ]
                                [ text reason
                                , a [ class "link", href ("https://github.com/login/oauth/authorize?client_id=" ++ model.githubClientId) ]
                                    [ text "Try again?" ]
                                ]
                            ]
                ]
            ]
        ]
    }
