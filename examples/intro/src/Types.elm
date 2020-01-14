module Types exposing
    ( Bundle
    , Init
    , LayoutContext
    , Page
    , Recipe
    , Update
    )

import Global
import Routes exposing (Route)
import Spa.Types


type alias Page pageParams pageModel pageMsg layoutModel layoutMsg msg =
    Spa.Types.Page Route pageParams pageModel pageMsg layoutModel layoutMsg Global.Model Global.Msg msg


type alias Recipe params model msg layoutModel layoutMsg appMsg =
    Spa.Types.Recipe Route params model msg layoutModel layoutMsg Global.Model Global.Msg appMsg


type alias LayoutContext msg =
    Spa.Types.LayoutContext Route msg Global.Model Global.Msg


type alias Init model msg =
    Spa.Types.Init Route model msg Global.Model Global.Msg


type alias Update model msg =
    Spa.Types.Update Route model msg Global.Model Global.Msg


type alias Bundle msg appMsg =
    Spa.Types.Bundle Route msg Global.Model Global.Msg appMsg
