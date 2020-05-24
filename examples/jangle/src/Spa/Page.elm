module Spa.Page exposing
    ( Page
    , static, sandbox, element, full
    , protectedFull
    , Upgraded, Bundle, upgrade
    )

{-|

@docs Page
@docs static, sandbox, element, full
@docs protectedFull
@docs Upgraded, Bundle, upgrade

-}

import Api.Token exposing (Token)
import Browser.Navigation as Nav
import Global
import Spa.Document as Document exposing (Document)
import Spa.Generated.Route as Route
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
full =
    identity



-- PROTECTED, redirect to sign in if not signed in


protectedFull :
    { init : Token -> Global.Model -> Url params -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Document msg
    , subscriptions : model -> Sub msg
    , save : model -> Global.Model -> Global.Model
    , load : Global.Model -> model -> model
    }
    -> Page params (Maybe model) msg
protectedFull =
    protected >> full


protected :
    { init : Token -> Global.Model -> Url params -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Document msg
    , subscriptions : model -> Sub msg
    , save : model -> Global.Model -> Global.Model
    , load : Global.Model -> model -> model
    }
    -> Page params (Maybe model) msg
protected page =
    let
        init : Global.Model -> Url params -> ( Maybe model, Cmd msg )
        init global url =
            case global.token of
                Just token ->
                    page.init token global url |> Tuple.mapFirst Just

                Nothing ->
                    ( Nothing
                    , Nav.pushUrl global.key (Route.toString Route.SignIn)
                    )

        protect : (model -> value) -> value -> Maybe model -> value
        protect fromModel fallback maybeModel =
            maybeModel
                |> Maybe.map fromModel
                |> Maybe.withDefault fallback
    in
    { init = init
    , update = \msg model_ -> protect (\model -> page.update msg model |> Tuple.mapFirst Just) ( Nothing, Cmd.none ) model_
    , view = protect page.view { title = "", body = [] }
    , subscriptions = protect page.subscriptions Sub.none
    , save = \model_ global -> protect (\model -> page.save model global) global model_
    , load = \global model_ -> protect (\model -> page.load global model |> Just) Nothing model_
    }



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
    , load : Global.Model -> model
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
