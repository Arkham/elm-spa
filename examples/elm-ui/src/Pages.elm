module Pages exposing
    ( Model
    , Msg
    , page
    )

import Layout
import Pages.Docs
import Pages.Guide
import Pages.NotFound
import Pages.Top
import Routes exposing (Route)
import Spa.Page
import Types


type Model
    = TopModel Pages.Top.Model
    | DocsModel Pages.Docs.Model
    | GuideModel Pages.Guide.Model
    | NotFoundModel Pages.NotFound.Model


type Msg
    = TopMsg Pages.Top.Msg
    | DocsMsg Pages.Docs.Msg
    | GuideMsg Pages.Guide.Msg
    | NotFoundMsg Pages.NotFound.Msg


page : Types.Page Route Model Msg model msg appMsg
page =
    Spa.Page.layout
        { path = []
        , view = Layout.view
        , recipe =
            { init = init
            , update = update
            , bundle = bundle
            }
        }


type alias Recipes appMsg =
    { top : Types.Recipe () Pages.Top.Model Pages.Top.Msg Model Msg appMsg
    , docs : Types.Recipe () Pages.Docs.Model Pages.Docs.Msg Model Msg appMsg
    , guide : Types.Recipe () Pages.Guide.Model Pages.Guide.Msg Model Msg appMsg
    , notFound : Types.Recipe () Pages.NotFound.Model Pages.NotFound.Msg Model Msg appMsg
    }


recipes : Recipes appMsg
recipes =
    { top =
        Spa.Page.recipe
            { toModel = TopModel
            , toMsg = TopMsg
            , page = Pages.Top.page
            }
    , docs =
        Spa.Page.recipe
            { toModel = DocsModel
            , toMsg = DocsMsg
            , page = Pages.Docs.page
            }
    , guide =
        Spa.Page.recipe
            { toModel = GuideModel
            , toMsg = GuideMsg
            , page = Pages.Guide.page
            }
    , notFound =
        Spa.Page.recipe
            { toModel = NotFoundModel
            , toMsg = NotFoundMsg
            , page = Pages.NotFound.page
            }
    }


init : Route -> Types.Init Model Msg
init route =
    case route of
        Routes.Top ->
            recipes.top.init ()

        Routes.Docs ->
            recipes.docs.init ()

        Routes.Guide ->
            recipes.guide.init ()

        Routes.NotFound ->
            recipes.notFound.init ()


update : Msg -> Model -> Types.Update Model Msg
update msg_ model_ =
    case ( msg_, model_ ) of
        ( TopMsg msg, TopModel model ) ->
            recipes.top.update msg model

        ( DocsMsg msg, DocsModel model ) ->
            recipes.docs.update msg model

        ( GuideMsg msg, GuideModel model ) ->
            recipes.guide.update msg model

        ( NotFoundMsg msg, NotFoundModel model ) ->
            recipes.notFound.update msg model

        _ ->
            Spa.Page.keep model_


bundle : Model -> Types.Bundle Msg msg
bundle model_ =
    case model_ of
        TopModel model ->
            recipes.top.bundle model

        DocsModel model ->
            recipes.docs.bundle model

        GuideModel model ->
            recipes.guide.bundle model

        NotFoundModel model ->
            recipes.notFound.bundle model
