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
module Generated.Pages exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Generated.Route as Route exposing (Route)
import Global
import Page exposing (Bundle, Document)
{{pagesImports}}



-- TYPES


{{pagesModels}}


{{pagesMsgs}}



-- PAGES


type alias Upgraded flags model msg =
    { init : flags -> Global.Model -> ( Model, Cmd Msg, Cmd Global.Msg )
    , update : msg -> model -> Global.Model -> ( Model, Cmd Msg, Cmd Global.Msg )
    , bundle : model -> Global.Model -> Bundle Msg
    }



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


view : Model -> Global.Model -> Document Msg
view model =
    bundle model >> .view


subscriptions : Model -> Global.Model -> Sub Msg
subscriptions model =
    bundle model >> .subscriptions

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
                    ++ ".Flags "
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
        , annotation = [ "Route", "Global.Model", "( Model, Cmd Msg, Cmd Global.Msg )" ]
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
        , annotation = [ "Msg", "Model", "Global.Model", "( Model, Cmd Msg, Cmd Global.Msg )" ]
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
                                    cases ++ [ ( "_", "always ( bigModel, Cmd.none, Cmd.none )" ) ]
                           )
                }
        }


pagesBundle : List Path -> String
pagesBundle paths =
    Utils.function
        { name = "bundle"
        , annotation = [ "Model", "Global.Model", "Bundle Msg" ]
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
