module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Shared exposing (Flags)
import Spa.Document as Document exposing (Document)
import Spa.Generated.Pages as Pages
import Spa.Generated.Route as Route exposing (Route)
import Url exposing (Url)


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
    , shared : Shared.Model
    , page : Pages.Model
    }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        route =
            fromUrl url

        ( shared, sharedCmd ) =
            Shared.init flags key

        ( page, pageCmd ) =
            Pages.init route shared key url
    in
    ( Model url key shared page
    , Cmd.batch
        [ Cmd.map Shared sharedCmd
        , Cmd.map Pages pageCmd
        ]
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Shared Shared.Msg
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
            let
                route =
                    fromUrl url

                ( page, cmd ) =
                    Pages.init route model.shared model.key url

                shared =
                    Pages.save page model.shared
            in
            ( { model | url = url, page = page, shared = shared }
            , Cmd.map Pages cmd
            )

        Shared sharedMsg ->
            let
                ( shared, sharedCmd ) =
                    Shared.update sharedMsg model.shared

                ( page, pageCmd ) =
                    Pages.load model.page shared
            in
            ( { model | page = page, shared = shared }
            , Cmd.batch
                [ Cmd.map Shared sharedCmd
                , Cmd.map Pages pageCmd
                ]
            )

        Pages pageMsg ->
            let
                ( page, cmd ) =
                    Pages.update pageMsg model.page

                shared =
                    Pages.save page model.shared
            in
            ( { model | page = page, shared = shared }
            , Cmd.map Pages cmd
            )


view : Model -> Document Msg
view model =
    Shared.view
        { page = Pages.view model.page |> Document.map Pages
        , shared = model.shared
        , toMsg = Shared
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Pages.subscriptions model.page
        |> Sub.map Pages
