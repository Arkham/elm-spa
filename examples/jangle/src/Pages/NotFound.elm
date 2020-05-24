module Pages.NotFound exposing (Model, Msg, Params, page)

import Api.Token exposing (Token)
import Browser.Navigation as Nav
import Global
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events as Events
import Ports
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


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
    }


init : Token -> Global.Model -> Url Params -> ( ProtectedModel, Cmd Msg )
init token global _ =
    ( ProtectedModel
        global.key
        token
        False
    , Cmd.none
    )


load : Global.Model -> ProtectedModel -> ProtectedModel
load _ model =
    model


type alias Msg =
    Never


update : Msg -> ProtectedModel -> ( ProtectedModel, Cmd Msg )
update msg model =
    ( model, Cmd.none )


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
        [ div [ class "column fill center" ]
            [ div [ class "column bg--white padding-medium shadow spacing-small max-width--20 rounded-tiny fill-x center-x" ]
                [ h1 [ class "font-h1 text-center" ] [ text "Page not Found" ]
                , div [ class "row" ]
                    [ a [ class "button", href (Route.toString Route.Top) ] [ text "Back to projects" ]
                    ]
                ]
            ]
        ]
    }
