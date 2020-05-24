module Api.User exposing (User, current)

import Api.Data exposing (Data)
import Api.Github
import Api.Token exposing (Token)
import Json.Decode as D exposing (Decoder)


type alias User =
    { login : String
    , avatarUrl : String
    , name : String
    }


current : { token : Token, toMsg : Data User -> msg } -> Cmd msg
current options =
    Api.Github.get
        { token = options.token
        , decoder = D.at [ "data", "viewer" ] decoder
        , toMsg = options.toMsg
        , query = """
            query {
                viewer {
                    login
                    avatarUrl
                    name
                }
            }
        """
        }


decoder : Decoder User
decoder =
    D.map3 User
        (D.field "login" D.string)
        (D.field "avatarUrl" D.string)
        (D.oneOf
            [ D.field "name" D.string
            , D.field "login" D.string
            ]
        )
