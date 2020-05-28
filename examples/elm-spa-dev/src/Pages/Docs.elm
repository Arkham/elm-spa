module Pages.Docs exposing (Model, Msg, Params, page)

import Components.Sidebar as Sidebar
import Html exposing (..)
import Html.Attributes exposing (class)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


type alias Params =
    ()


type alias Model =
    { route : Route
    }


type Msg
    = NoOp


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Url Params -> ( Model, Cmd Msg )
init { rawUrl } =
    ( { route = Route.fromUrl rawUrl |> Maybe.withDefault Route.NotFound
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "docs | elm-spa"
    , body =
        [ div [ class "flex column spacing-medium" ]
            [ h1 [ class "font-h2" ] [ text "docs" ]
            , div [ class "content readable" ] [ text "TODO: Markdown docs" ]
            ]
        ]
    }
