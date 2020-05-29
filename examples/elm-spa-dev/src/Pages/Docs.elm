module Pages.Docs exposing (Model, Msg, Params, page)

import Api.Data exposing (Data)
import Api.Markdown
import Components.Sidebar as Sidebar
import Html exposing (..)
import Html.Attributes exposing (class)
import Markdown
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


type alias Params =
    ()


type alias Model =
    { route : Route
    , content : Data String
    }


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


init : Url Params -> ( Model, Cmd Msg )
init { rawUrl } =
    ( { route = Route.fromUrl rawUrl |> Maybe.withDefault Route.NotFound
      , content = Api.Data.Loading
      }
    , Api.Markdown.get
        { file = "docs.md"
        , onResponse = GotMarkdown
        }
    )


type Msg
    = GotMarkdown (Data String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMarkdown content ->
            ( { model | content = content }
            , Cmd.none
            )


view : Model -> Document Msg
view model =
    { title = "docs | elm-spa"
    , body =
        [ Api.Data.view
            (Markdown.toHtml [ class "markdown readable column spacing-small" ])
            model.content
        ]
    }
