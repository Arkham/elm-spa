port module Main exposing (main)

import Item exposing (Item)
import Json.Decode as D exposing (Decoder)
import Templates.Pages
import Templates.Route


port toJs : List NewFile -> Cmd msg


type alias NewFile =
    { filepathSegments : List String
    , contents : String
    }



-- PROGRAM


main : Program D.Value () msg
main =
    Platform.worker
        { init = \json -> ( (), toJs <| parse json )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


parse : D.Value -> List NewFile
parse =
    D.decodeValue decoder >> Result.withDefault []



-- DECODER


decoder : Decoder (List NewFile)
decoder =
    D.list Item.decoder
        |> D.map (toFileInfo [])
        |> D.map fromData


type alias FileInfo =
    { path : List String
    , items : List Item
    }


toFileInfo : List String -> List Item -> List FileInfo
toFileInfo path items =
    List.foldl
        (\folder infos ->
            infos ++ toFileInfo (path ++ [ folder.name ]) folder.children
        )
        [ { path = path, items = items }
        ]
        (Item.folders items)


fromData : List FileInfo -> List NewFile
fromData fileInfos =
    List.concat
        [ List.map routeFile fileInfos
        , List.map pageFile fileInfos
        ]


routeFile : FileInfo -> NewFile
routeFile { path, items } =
    { filepathSegments = segments "Pages" path
    , contents = Templates.Pages.contents items path
    }


pageFile : FileInfo -> NewFile
pageFile { path, items } =
    { filepathSegments = segments "Route" path
    , contents = Templates.Route.contents items path
    }


segments : String -> List String -> List String
segments prefix path =
    "Generated"
        :: (if List.isEmpty path then
                [ prefix ++ ".elm" ]

            else
                prefix :: appendToLast ".elm" path
           )


appendToLast : String -> List String -> List String
appendToLast str list =
    let
        lastIndex =
            List.length list - 1
    in
    List.indexedMap
        (\i value ->
            if i == lastIndex then
                value ++ str

            else
                value
        )
        list
