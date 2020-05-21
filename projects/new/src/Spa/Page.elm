module Spa.Page exposing
    ( Page
    , static, sandbox, element, full
    , Upgraded, upgrade
    )

{-|

@docs Page
@docs static, sandbox, element, full
@docs Upgraded, upgrade

-}

import Global
import Spa.Document as Document exposing (Document)
import Spa.Url exposing (Url)
import Url


type alias Page params model msg =
    { init : Global.Model -> Url params -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Document msg
    , subscriptions : model -> Sub msg
    , save : model -> Global.Model -> Global.Model
    , load : Global.Model -> model -> model
    }


static :
    { view : Document msg
    }
    -> Page params () msg
static page =
    { init = \_ _ -> ( (), Cmd.none )
    , update = \_ _ -> ( (), Cmd.none )
    , view = \_ -> page.view
    , subscriptions = \_ -> Sub.none
    , save = always identity
    , load = always identity
    }


sandbox :
    { init : model
    , update : msg -> model -> model
    , view : model -> Document msg
    }
    -> Page params model msg
sandbox page =
    { init = \_ _ -> ( page.init, Cmd.none )
    , update = \msg model -> ( page.update msg model, Cmd.none )
    , view = page.view
    , subscriptions = \_ -> Sub.none
    , save = always identity
    , load = always identity
    }


element :
    { init : Url params -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Document msg
    , subscriptions : model -> Sub msg
    }
    -> Page params model msg
element page =
    { init = \_ params -> page.init params
    , update = \msg model -> page.update msg model
    , view = page.view
    , subscriptions = page.subscriptions
    , save = always identity
    , load = always identity
    }


full :
    { init : Global.Model -> Url params -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Document msg
    , subscriptions : model -> Sub msg
    , save : model -> Global.Model -> Global.Model
    , load : Global.Model -> model -> model
    }
    -> Page params model msg
full page =
    page



-- UPGRADING


type alias Bundle model msg =
    { view : Document msg
    , subscriptions : Sub msg
    , save : Global.Model -> Global.Model
    , load : Global.Model -> model
    }


type alias Upgraded pageParams pageModel pageMsg model msg =
    { init : pageParams -> Global.Model -> Url.Url -> ( model, Cmd msg )
    , update : pageMsg -> pageModel -> ( model, Cmd msg )
    , bundle : pageModel -> Bundle model msg
    }


upgrade :
    (pageModel -> model)
    -> (pageMsg -> msg)
    -> Page pageParams pageModel pageMsg
    -> Upgraded pageParams pageModel pageMsg model msg
upgrade toModel toMsg page =
    { init = \params global url -> page.init global (Spa.Url.create params url) |> Tuple.mapBoth toModel (Cmd.map toMsg)
    , update = \msg model -> page.update msg model |> Tuple.mapBoth toModel (Cmd.map toMsg)
    , bundle =
        \model ->
            { view = page.view model |> Document.map toMsg
            , subscriptions = page.subscriptions model |> Sub.map toMsg
            , save = page.save model
            , load = \global -> toModel (page.load global model)
            }
    }
