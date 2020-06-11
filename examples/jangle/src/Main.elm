module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Global exposing (Flags)
import Spa.Document as Document exposing (Document)
import Spa.Generated.Pages as Pages
import Spa.Generated.Route as Route exposing (Route)
import Url exposing (Url)
import Utils.Cmd


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view >> Document.toBrowserDocument
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


fromUrl : Url -> Route
fromUrl =
    Route.fromUrl >> Maybe.withDefault Route.NotFound



-- INIT


type alias Model =
    { url : Url
    , key : Nav.Key
    , isTransitioning : Bool
    , global : Global.Model
    , page : Pages.Model
    }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( global, globalCmd ) =
            Global.init flags key

        route =
            fromUrl url

        ( page, pageCmd ) =
            Pages.init route global url
    in
    ( Model url key False global page
    , Cmd.batch
        [ Cmd.map Pages pageCmd
        , Cmd.map Global globalCmd
        ]
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | FadeInPage Url
    | Global Global.Msg
    | Pages Pages.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked (Browser.Internal url) ->
            ( model
            , Nav.pushUrl model.key (Url.toString url)
            )

        LinkClicked (Browser.External href) ->
            ( model
            , Nav.load href
            )

        UrlChanged url ->
            if url == model.url then
                ( model, Cmd.none )

            else if url.path == model.url.path then
                ( model, Utils.Cmd.delay 0 (FadeInPage url) )

            else
                ( { model | isTransitioning = True }
                , Utils.Cmd.delay 300 (FadeInPage url)
                )

        FadeInPage url ->
            let
                route =
                    fromUrl url

                ( page, cmd ) =
                    Pages.init route model.global url

                global =
                    Pages.save page model.global
            in
            ( { model | url = url, page = page, global = global, isTransitioning = False }
            , Cmd.map Pages cmd
            )

        Global globalMsg ->
            let
                ( global, cmd ) =
                    Global.update globalMsg model.global

                page =
                    Pages.load model.page global
            in
            ( { model | page = page, global = global }
            , Cmd.map Global cmd
            )

        Pages pageMsg ->
            let
                ( page, cmd ) =
                    Pages.update pageMsg model.page

                global =
                    Pages.save page model.global
            in
            ( { model | page = page, global = global }
            , Cmd.map Pages cmd
            )


view : Model -> Document Msg
view model =
    Global.view
        { page = Pages.view model.page |> Document.map Pages
        , global = model.global
        , toMsg = Global
        , isTransitioning = model.isTransitioning
        , route = fromUrl model.url
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Pages.subscriptions model.page
        |> Sub.map Pages
