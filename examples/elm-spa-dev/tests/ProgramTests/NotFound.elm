module ProgramTests.NotFound exposing (all)

import Pages.NotFound as Page
import ProgramTest exposing (ProgramTest, expectViewHas)
import ProgramTests.Utils.Spa
import Test exposing (..)
import Test.Html.Selector exposing (text)


start : ProgramTest Page.Model Page.Msg (Cmd Page.Msg)
start =
    ProgramTests.Utils.Spa.createStaticPage
        { view = Page.view
        }


all : Test
all =
    describe "Pages.NotFound"
        [ test "should say page not found" <|
            \() ->
                start
                    |> expectViewHas [ text "Page not found" ]
        ]
