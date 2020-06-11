module Api.Project exposing (Project, get)

import Api.Data exposing (Data)
import Api.Github
import Api.Token exposing (Token)
import Iso8601
import Json.Decode as D exposing (Decoder)
import Time
import Utils.Json


type alias Project =
    { name : String
    , url : String
    , description : String
    , updatedAt : Time.Posix
    }


get : { token : Token, toMsg : Data (List Project) -> msg } -> Cmd msg
get options =
    Api.Github.get
        { token = options.token
        , decoder = D.at [ "data", "viewer", "repositories", "nodes" ] (D.list decoder)
        , toMsg = options.toMsg
        , query = """
            query { 
                viewer {
                    repositories(first: 100, affiliations: [OWNER], orderBy: { field: UPDATED_AT, direction: DESC }) {
                        nodes {
                            name,
                            description
                            url,
                            updatedAt
                        }
                    }
                }
            }
        """
        }


decoder : Decoder Project
decoder =
    D.map4 Project
        (D.field "name" D.string)
        (D.field "url" D.string)
        (D.field "description" D.string |> Utils.Json.withDefault "")
        (D.field "updatedAt" Iso8601.decoder)
