module Internals.Transition exposing
    ( Transition
    , duration, view
    , optOut, none, fade
    , Visibility
    , visible, invisible
    , custom
    )

{-|

@docs Transition
@docs duration, view, chooseFrom
@docs optOut, none, fade

@docs Visibility
@docs visible, invisible

-}

import Html exposing (Html)
import Html.Attributes as Attr


type Visibility
    = Invisible
    | Visible


visible : Visibility
visible =
    Visible


invisible : Visibility
invisible =
    Invisible


type Transition msg
    = OptOut
    | None
    | Transition (Options msg)


type alias Options msg =
    { duration : Int
    , invisible : View msg
    , visible : View msg
    }


type alias View msg =
    Html msg -> Html msg


duration : Transition msg -> Int
duration transition =
    case transition of
        OptOut ->
            0

        None ->
            0

        Transition t ->
            t.duration


view :
    Transition msg
    -> Visibility
    -> Html msg
    -> Html msg
view transition visibility page =
    case transition of
        OptOut ->
            page

        None ->
            page

        Transition t ->
            case visibility of
                Visible ->
                    t.visible page

                Invisible ->
                    t.invisible page



-- TRANSITIONS


optOut : Transition msg
optOut =
    OptOut


none : Transition msg
none =
    None


fade : Int -> Transition msg
fade duration_ =
    let
        withOpacity : Int -> View msg
        withOpacity opacity page =
            Html.div
                [ Attr.style "opacity" (String.fromInt opacity)
                , Attr.style "transition" <|
                    String.concat
                        [ "opacity "
                        , String.fromInt duration_
                        , "ms ease-in-out"
                        ]
                ]
                [ page ]
    in
    Transition
        { duration = duration_
        , invisible = withOpacity 0
        , visible = withOpacity 1
        }


custom :
    { duration : Int
    , invisible : View msg
    , visible : View msg
    }
    -> Transition msg
custom =
    Transition
