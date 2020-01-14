module Internals.Page exposing
    ( Bundle
    , Init
    , Layout
    , LayoutContext
    , Page(..)
    , PageContext
    , Recipe
    , Update
    , Upgrade
    , upgrade
    )

import Dict exposing (Dict)
import Html exposing (Html)
import Internals.Path exposing (Path)
import Internals.Transition as Transition exposing (Transition)


type alias PageContext route globalModel =
    { global : globalModel
    , route : route
    , queryParameters : Dict String String
    }


type Page route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg
    = Page (Page_ route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg)


type alias Page_ route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg =
    { toModel : pageModel -> layoutModel
    , toMsg : pageMsg -> layoutMsg
    }
    -> Recipe route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg


type alias Recipe route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg =
    { init : pageParams -> Init route layoutModel layoutMsg globalModel globalMsg
    , update : pageMsg -> pageModel -> Update route layoutModel layoutMsg globalModel globalMsg
    , bundle : pageModel -> Bundle route layoutMsg globalModel globalMsg msg
    }


type alias Upgrade route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg =
    { page : Page route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg
    , toModel : pageModel -> layoutModel
    , toMsg : pageMsg -> layoutMsg
    }


upgrade :
    Upgrade route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg
    -> Recipe route pageParams pageModel pageMsg layoutModel layoutMsg globalModel globalMsg msg
upgrade config =
    let
        (Page page) =
            config.page
    in
    page
        { toModel = config.toModel
        , toMsg = config.toMsg
        }


type alias Init route layoutModel layoutMsg globalModel globalMsg =
    PageContext route globalModel
    -> ( layoutModel, Cmd layoutMsg, Cmd globalMsg )


type alias Update route layoutModel layoutMsg globalModel globalMsg =
    PageContext route globalModel
    -> ( layoutModel, Cmd layoutMsg, Cmd globalMsg )


type alias Bundle route layoutMsg globalModel globalMsg msg =
    { fromGlobalMsg : globalMsg -> msg
    , fromPageMsg : layoutMsg -> msg
    , visibility : Transition.Visibility
    , path : Path
    , transitions :
        List
            { path : Path
            , transition : Transition msg
            }
    }
    -> PageContext route globalModel
    ->
        { title : String
        , view : Html msg
        , subscriptions : Sub msg
        }


type alias LayoutContext route msg globalModel globalMsg =
    { page : Html msg
    , route : route
    , global : globalModel
    , fromGlobalMsg : globalMsg -> msg
    }


type alias Layout route pageParams pageModel pageMsg globalModel globalMsg msg =
    { path : Path
    , view : LayoutContext route msg globalModel globalMsg -> Html msg
    , recipe : Recipe route pageParams pageModel pageMsg pageModel pageMsg globalModel globalMsg msg
    }
