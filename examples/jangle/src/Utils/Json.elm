module Utils.Json exposing (withDefault)

import Json.Decode as D exposing (Decoder)


withDefault : value -> Decoder value -> Decoder value
withDefault fallback decoder =
    D.oneOf
        [ decoder
        , D.succeed fallback
        ]
