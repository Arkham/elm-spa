module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes as Attr exposing (class, href)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route



-- INIT


type alias Flags =
    ()


type alias Model =
    {}


init : Flags -> Nav.Key -> ( Model, Cmd Msg )
init _ _ =
    ( {}
    , Cmd.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view :
    { page : Document msg
    , shared : Model
    , toMsg : Msg -> msg
    }
    -> Document msg
view { page, shared, toMsg } =
    { title = page.title
    , body =
        [ header []
            [ a [ href (Route.toString Route.Top) ] [ text "Home" ]
            , a [ href (Route.toString Route.NotFound) ] [ text "Not found" ]
            ]
        , div [] page.body
        , footer [] [ text "built with elm-spa" ]
        ]
    }
