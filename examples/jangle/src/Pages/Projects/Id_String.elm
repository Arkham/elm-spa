module Pages.Projects.Id_String exposing (Model, Msg, Params, page)

import Api.User exposing (User)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


type alias Params =
    { id : String }


type alias Model =
    Page.Protected Params { user : User, url : Url Params }


type alias Msg =
    ()


page : Page Params Model Msg
page =
    Page.protectedStatic
        { view = view
        }


view : User -> Url Params -> Document Msg
view user { params } =
    let
        repoUrl : String
        repoUrl =
            "https://www.github.com/" ++ user.login ++ "/" ++ params.id
    in
    { title = params.id ++ " | Jangle"
    , body =
        [ div [ class "column overflow-hidden" ]
            [ div [ class "row wrap padding-medium spacing-small center-y bg--shell" ]
                [ h1 [ class "font-h3" ] [ text params.id ]
                , a [ class "font-h3 hoverable", href repoUrl ] [ span [ class "fab fa-github-square" ] [] ]
                ]
            ]
        ]
    }
