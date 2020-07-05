module Generators.Pages exposing
    ( generate
    , pagesBundle
    , pagesCustomType
    , pagesImports
    , pagesInit
    , pagesUpdate
    , pagesUpgradedTypes
    , pagesUpgradedValues
    )

import Path exposing (Path)
import Utils.Generate as Utils


generate : List Path -> String
generate paths =
    String.trim """
module Spa.Generated.Pages exposing
    ( Model
    , Msg
    , init
    , load
    , save
    , subscriptions
    , update
    , view
    )

import Browser.Navigation exposing (Key)
{{pagesImports}}
import Shared
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page as Page
import Url exposing (Url)


-- TYPES


{{pagesModels}}


{{pagesMsgs}}



-- PAGES


type alias Upgraded params model msg =
    Page.Upgraded params model msg Model Msg


type alias Bundle =
    Page.Bundle Model Msg



pages :
{{pagesUpgradedTypes}}
pages =
{{pagesUpgradedValues}}



-- INIT


{{pagesInit}}



-- UPDATE


{{pagesUpdate}}



-- BUNDLE - (view + subscriptions)


{{pagesBundle}}


view : Model -> Document Msg
view =
    bundle >> .view


subscriptions : Model -> Sub Msg
subscriptions =
    bundle >> .subscriptions


save : Model -> Shared.Model -> Shared.Model
save =
    bundle >> .save


load : Model -> Shared.Model -> ( Model, Cmd Msg )
load =
    bundle >> .load

"""
        |> String.replace "{{pagesImports}}" (pagesImports paths)
        |> String.replace "{{pagesModels}}" (pagesModels paths)
        |> String.replace "{{pagesMsgs}}" (pagesMsgs paths)
        |> String.replace "{{pagesUpgradedTypes}}" (pagesUpgradedTypes paths)
        |> String.replace "{{pagesUpgradedValues}}" (pagesUpgradedValues paths)
        |> String.replace "{{pagesInit}}" (pagesInit paths)
        |> String.replace "{{pagesUpdate}}" (pagesUpdate paths)
        |> String.replace "{{pagesBundle}}" (pagesBundle paths)


pagesImports : List Path -> String
pagesImports paths =
    paths
        |> List.map Path.toModulePath
        |> List.map ((++) "import Pages.")
        |> String.join "\n"


pagesModels : List Path -> String
pagesModels =
    pagesCustomType "Model"


pagesMsgs : List Path -> String
pagesMsgs =
    pagesCustomType "Msg"


pagesCustomType : String -> List Path -> String
pagesCustomType name paths =
    Utils.customType
        { name = name
        , variants =
            List.map
                (\path ->
                    Path.toTypeName path
                        ++ "__"
                        ++ name
                        ++ " Pages."
                        ++ Path.toModulePath path
                        ++ "."
                        ++ name
                )
                paths
        }


pagesUpgradedTypes : List Path -> String
pagesUpgradedTypes paths =
    paths
        |> List.map
            (\path ->
                let
                    name =
                        "Pages." ++ Path.toModulePath path
                in
                ( Path.toVariableName path
                , "Upgraded "
                    ++ name
                    ++ ".Params "
                    ++ name
                    ++ ".Model "
                    ++ name
                    ++ ".Msg"
                )
            )
        |> Utils.recordType
        |> Utils.indent 1


pagesUpgradedValues : List Path -> String
pagesUpgradedValues paths =
    paths
        |> List.map
            (\path ->
                ( Path.toVariableName path
                , "Pages."
                    ++ Path.toModulePath path
                    ++ ".page |> Page.upgrade "
                    ++ Path.toTypeName path
                    ++ "__Model "
                    ++ Path.toTypeName path
                    ++ "__Msg"
                )
            )
        |> Utils.recordValue
        |> Utils.indent 1


pagesInit : List Path -> String
pagesInit paths =
    Utils.function
        { name = "init"
        , annotation = [ "Route", "Shared.Model", "Key", "Url", "( Model, Cmd Msg )" ]
        , inputs = [ "route" ]
        , body =
            Utils.caseExpression
                { variable = "route"
                , cases =
                    paths
                        |> List.map
                            (\path ->
                                ( "Route."
                                    ++ Path.toTypeName path
                                    ++ (if Path.hasParams path then
                                            " params"

                                        else
                                            ""
                                       )
                                , "pages."
                                    ++ Path.toVariableName path
                                    ++ ".init"
                                    ++ (if Path.hasParams path then
                                            " params"

                                        else
                                            " ()"
                                       )
                                )
                            )
                }
        }


pagesUpdate : List Path -> String
pagesUpdate paths =
    Utils.function
        { name = "update"
        , annotation = [ "Msg", "Model", "( Model, Cmd Msg )" ]
        , inputs = [ "bigMsg bigModel" ]
        , body =
            Utils.caseExpression
                { variable = "( bigMsg, bigModel )"
                , cases =
                    paths
                        |> List.map
                            (\path ->
                                let
                                    typeName =
                                        Path.toTypeName path
                                in
                                ( "( "
                                    ++ typeName
                                    ++ "__Msg msg, "
                                    ++ typeName
                                    ++ "__Model model )"
                                , "pages." ++ Path.toVariableName path ++ ".update msg model"
                                )
                            )
                        |> (\cases ->
                                if List.length paths == 1 then
                                    cases

                                else
                                    cases ++ [ ( "_", "( bigModel, Cmd.none )" ) ]
                           )
                }
        }


pagesBundle : List Path -> String
pagesBundle paths =
    Utils.function
        { name = "bundle"
        , annotation = [ "Model", "Bundle" ]
        , inputs = [ "bigModel" ]
        , body =
            Utils.caseExpression
                { variable = "bigModel"
                , cases =
                    paths
                        |> List.map
                            (\path ->
                                let
                                    typeName =
                                        Path.toTypeName path
                                in
                                ( typeName ++ "__Model model"
                                , "pages." ++ Path.toVariableName path ++ ".bundle model"
                                )
                            )
                }
        }
