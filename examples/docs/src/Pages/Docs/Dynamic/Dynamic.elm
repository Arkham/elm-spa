module Pages.Docs.Dynamic.Dynamic exposing (Model, Msg, page)

import Element exposing (..)
import Generated.Docs.Dynamic.Params as Params
import Http
import Spa.Page
import Ui
import Utils.Markdown as Markdown exposing (Markdown)
import Utils.Spa exposing (Page)
import Utils.WebData as WebData exposing (WebData)


page : Page Params.Dynamic Model Msg model msg appMsg
page =
    Spa.Page.element
        { title = \{ model } -> String.join " | " [ viewTitle model, "docs", "elm-spa" ]
        , init = always init
        , update = always update
        , subscriptions = always subscriptions
        , view = always view
        }



-- INIT


type alias Model =
    { section : String
    , slug : String
    , markdown : WebData (Markdown Markdown.Frontmatter)
    }


init : Params.Dynamic -> ( Model, Cmd Msg )
init { param1, param2 } =
    ( { section = param1
      , slug = param2
      , markdown = WebData.Loading
      }
    , Http.get
        { url = "/" ++ String.join "/" [ "content", "docs", param1, param2 ++ ".md" ]
        , expect = WebData.expectMarkdown Loaded
        }
    )



-- UPDATE


type Msg
    = Loaded (WebData (Markdown Markdown.Frontmatter))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded data ->
            ( { model | markdown = data }
            , Cmd.none
            )



-- SUSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Element Msg
view model =
    Ui.webDataMarkdownArticle
        { fallbackTitle = viewTitle model
        , markdown = model.markdown
        }


viewTitle : Model -> String
viewTitle model =
    model.section ++ " " ++ model.slug
