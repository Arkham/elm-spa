module Pages.Guide.Topic_String exposing (Model, Msg, Params, page)

import Api.Data exposing (Data)
import Api.Markdown
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Markdown
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


type alias Params =
    { topic : String
    }


type alias Model =
    { title : String
    , route : Route
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
init { rawUrl, params } =
    ( { route = Route.fromUrl rawUrl |> Maybe.withDefault Route.NotFound
      , title = params.topic
      , content = Api.Data.Loading
      }
    , Api.Markdown.get
        { file = "guide/" ++ params.topic ++ ".md"
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
    { title = prettifySlug model.title ++ " | guide | elm-spa"
    , body =
        [ Api.Data.view
            (Markdown.toHtml [ class "markdown readable column spacing-small" ])
            model.content
        ]
    }


prettifySlug : String -> String
prettifySlug slug =
    slug
        |> String.replace "-" " "
        |> String.replace "elm spa" "elm-spa"
