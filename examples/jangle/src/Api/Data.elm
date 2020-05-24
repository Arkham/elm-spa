module Api.Data exposing
    ( Data(..)
    , fromHttpResult
    , toMaybe
    )

import Http


type Data value
    = NotAsked
    | Loading
    | Success value
    | Failure String


toMaybe : Data value -> Maybe value
toMaybe data =
    case data of
        Success value ->
            Just value

        _ ->
            Nothing



{-
   BadUrl String
     | Timeout
     | NetworkError
     | BadStatus Int
     | BadBody String
-}


fromHttpResult : Result Http.Error value -> Data value
fromHttpResult result =
    case result of
        Ok value ->
            Success value

        Err (Http.BadUrl _) ->
            Failure "URL was invalid."

        Err Http.Timeout ->
            Failure "Request timed out."

        Err Http.NetworkError ->
            Failure "Couldn't connect to internet."

        Err (Http.BadStatus status) ->
            Failure ("Got status " ++ String.fromInt status)

        Err (Http.BadBody reason) ->
            Failure reason
