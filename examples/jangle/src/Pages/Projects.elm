module Pages.Projects exposing (Model, Msg, Params, page)

import Api.Data exposing (Data)
import Api.Project exposing (Project)
import Api.User as User exposing (User)
import Browser.Navigation as Nav
import Global
import Html exposing (..)
import Html.Attributes as Attr exposing (class, href)
import Html.Events as Events
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Utils.Time


type alias Params =
    ()


type alias Model =
    Maybe ProtectedModel


page : Page Params Model Msg
page =
    Page.protectedFull
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = always identity
        , load = always identity
        }


type alias ProtectedModel =
    { key : Nav.Key
    , user : User
    , signOutRequested : Bool
    , query : String
    , projects : Data (List Project)
    }


init : User -> Global.Model -> Url Params -> ( ProtectedModel, Cmd Msg )
init user global _ =
    ( ProtectedModel
        global.key
        user
        False
        ""
        Api.Data.Loading
    , Api.Project.get
        { token = user.token
        , toMsg = GotProjects
        }
    )


type Msg
    = GotProjects (Data (List Project))
    | UpdatedSearchInput String
    | SubmittedSearch
    | ClickedRow Project


update : Msg -> ProtectedModel -> ( ProtectedModel, Cmd Msg )
update msg model =
    case msg of
        GotProjects projects ->
            ( { model | projects = projects }
            , Cmd.none
            )

        UpdatedSearchInput query ->
            ( { model | query = query }
            , Cmd.none
            )

        SubmittedSearch ->
            ( { model | query = "" }
            , Cmd.none
            )

        ClickedRow _ ->
            ( model, Cmd.none )


subscriptions : ProtectedModel -> Sub Msg
subscriptions _ =
    Sub.none


view : ProtectedModel -> Document Msg
view model =
    { title = "Jangle"
    , body =
        [ div [ class "column" ]
            [ div [ class "row padding-medium spacing-tiny spread center-y bg--shell" ]
                [ h1 [ class "font-h3" ] [ text "Projects" ]
                , viewSearchbar
                    { value = model.query
                    , placeholder = "Find a project..."
                    , onInput = UpdatedSearchInput
                    , onSubmit = SubmittedSearch
                    }
                ]
            , div [ class "column spacing-medium" ]
                [ Api.Data.view model.projects
                    { notAsked = text ""
                    , loading = span [ class "px-medium color--faint" ] [ text "Loading projects..." ]
                    , failure = \reason -> span [ class "error px-medium" ] [ text reason ]
                    , success = viewProjects
                    }
                ]
            ]
        ]
    }


viewProjects : List Project -> Html Msg
viewProjects projects =
    viewTable
        { columns =
            [ { header = th [ class "pl-medium" ] [ text "Name" ]
              , viewItem = \item -> td [ class "ellipsis pl-medium" ] [ text item.name ]
              }
            , { header = th [] [ text "Description" ]
              , viewItem = \item -> td [ class "py-small color--faint" ] [ text item.description ]
              }
            , { header = th [] [ text "Last Update" ]
              , viewItem = \item -> td [] [ text (Utils.Time.format item.updatedAt) ]
              }
            ]
        , items = projects
        , viewRow = \item -> a [ class "tr ", href (Route.toString <| Route.Projects__Id_String { id = item.name }) ]
        }


viewTable :
    { columns : List { header : Html msg, viewItem : item -> Html msg }
    , items : List item
    , viewRow : item -> List (Html msg) -> Html msg
    }
    -> Html msg
viewTable options =
    table [ class "borderless" ]
        [ thead [] [ tr [] <| List.map .header options.columns ]
        , tbody [] <|
            List.map
                (\item -> options.viewRow item (List.map (\column -> column.viewItem item) options.columns))
                options.items
        ]


viewSearchbar :
    { value : String
    , placeholder : String
    , onInput : String -> msg
    , onSubmit : msg
    }
    -> Html msg
viewSearchbar options =
    Html.form [ Events.onSubmit options.onSubmit, class "row stretch text--small" ]
        [ input
            [ class "max-width--10 rounded-none"
            , Attr.placeholder options.placeholder
            , Attr.value options.value
            , Events.onInput options.onInput
            ]
            [ text "Search bar" ]
        , button [ class "button rounded-none" ] [ text "search" ]
        ]
