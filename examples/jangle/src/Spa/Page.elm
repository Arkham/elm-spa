module Spa.Page exposing
    ( Page
    , static, sandbox, element, full
    , Upgraded, Bundle, upgrade
    )

{-|

@docs Page
@docs static, sandbox, element, full
@docs Upgraded, Bundle, upgrade

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
    , load : Global.Model -> model -> ( model, Cmd msg )
    }


static :
    { view : Url params -> Document msg
    }
    -> Page params (Url params) msg
static page =
    { init = \_ url -> ( url, Cmd.none )
    , update = \_ model -> ( model, Cmd.none )
    , view = page.view
    , subscriptions = \_ -> Sub.none
    , save = always identity
    , load = always (identity >> ignoreEffect)
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
    , load = always (identity >> ignoreEffect)
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
    , load = always (identity >> ignoreEffect)
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
    { init = page.init
    , update = page.update
    , view = page.view
    , subscriptions = page.subscriptions
    , save = page.save
    , load = \global model -> page.load global model |> ignoreEffect
    }


ignoreEffect : model -> ( model, Cmd msg )
ignoreEffect model =
    ( model, Cmd.none )



-- UPGRADING


type alias Upgraded pageParams pageModel pageMsg model msg =
    { init : pageParams -> Global.Model -> Url.Url -> ( model, Cmd msg )
    , update : pageMsg -> pageModel -> ( model, Cmd msg )
    , bundle : pageModel -> Bundle model msg
    }


type alias Bundle model msg =
    { view : Document msg
    , subscriptions : Sub msg
    , save : Global.Model -> Global.Model
    , load : Global.Model -> ( model, Cmd msg )
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
            , load = \global -> page.load global model |> Tuple.mapBoth toModel (Cmd.map toMsg)
            }
    }
