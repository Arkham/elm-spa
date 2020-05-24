module Pages.Projects exposing (Model, Msg, Params, page)

import Api.Data exposing (Data)
import Api.Token exposing (Token)
import Api.User as User exposing (User)
import Browser.Navigation as Nav
import Global
import Html exposing (..)
import Html.Attributes exposing (alt, class, href, src)
import Html.Events as Events
import Ports
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Utils.Maybe


type alias Params =
    ()


type alias Model =
    Maybe ProtectedModel


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


type alias ProtectedModel =
    { key : Nav.Key
    , token : Token
    , signOutRequested : Bool
    , user : Maybe User
    }


init : Token -> Global.Model -> Url Params -> ( ProtectedModel, Cmd Msg )
init token global _ =
    ( ProtectedModel
        global.key
        token
        False
        Nothing
    , User.current
        { token = token
        , toMsg = GotUser
        }
    )


load : Global.Model -> ProtectedModel -> ProtectedModel
load _ model =
    model


type Msg
    = GotUser (Data User)
    | ClickedSignOut


update : Msg -> ProtectedModel -> ( ProtectedModel, Cmd Msg )
update msg model =
    case msg of
        GotUser user ->
            ( { model | user = Api.Data.toMaybe user }
            , Cmd.none
            )

        ClickedSignOut ->
            ( { model | signOutRequested = True }
            , Cmd.batch
                [ Ports.clearToken ()
                , Nav.pushUrl model.key (Route.toString Route.SignIn)
                ]
            )


save : ProtectedModel -> Global.Model -> Global.Model
save model global =
    { global
        | token =
            if model.signOutRequested then
                Nothing

            else
                Just model.token
    }


subscriptions : ProtectedModel -> Sub Msg
subscriptions model =
    Sub.none


view : ProtectedModel -> Document Msg
view model =
    { title = "Jangle"
    , body =
        [ div [ class "visible-mobile column fill" ]
            [ header [ class "row padding-small relative bg--orange color--white" ]
                [ button [ class "button button--white" ] [ text "Menu" ]
                , h3 [ class "absolute center" ] [ a [ class "font-h3", href (Route.toString Route.Projects) ] [ text "Jangle" ] ]
                ]
            , main_ [ class "flex" ] [ viewContent model ]
            ]
        , div [ class "hidden-mobile fill relative" ]
            [ div [ class "absolute width--half align-left align-top align-bottom bg--orange" ] []
            , div [ class "relative bg--shell row fill-y container align-top" ]
                [ aside [ class "width--sidebar bg--orange color--white column fill-y padding-medium spread center-x" ]
                    [ a [ class "font-h3", href (Route.toString Route.Projects) ] [ text "Jangle" ]
                    , button [ Events.onClick ClickedSignOut, class "button button--white" ] [ text "Sign out" ]
                    ]
                , main_ [ class "flex" ] [ viewContent model ]
                ]
            ]
        ]
    }


viewContent : { model | user : Maybe User } -> Html msg
viewContent model =
    div [ class "column padding-medium" ]
        [ div [ class "row spacing-tiny wrap spread center-y" ]
            [ h1 [ class "font-h3" ] [ text "Projects" ]
            , Utils.Maybe.view model.user <|
                \user ->
                    div [ class "row spacing-tiny center-y" ]
                        [ div [ class "row rounded-circle bg-orange size--avatar" ]
                            [ img [ src user.avatarUrl, alt user.name ] []
                            ]
                        , span [] [ text user.name ]
                        ]
            ]
        ]
