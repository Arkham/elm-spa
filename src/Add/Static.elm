module Add.Static exposing (create)

import Path exposing (Path)


create : Path -> String
create path =
    """
module Pages.{{name}} exposing (Params, Model, Msg, page)

import Html exposing (..)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)


type alias Params =
    {{params}}


type alias Model =
    ()


type alias Msg =
    Never


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }


view : Document Msg
view =
    { title = "{{name}}"
    , body = [ text "{{name}}" ]
    }
"""
        |> String.replace "{{name}}" (Path.toModulePath path)
        |> String.replace "{{params}}" (Path.toParams path)
        |> String.trim
