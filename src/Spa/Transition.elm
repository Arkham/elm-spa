module Spa.Transition exposing
    ( Transition
    , none, fade
    , custom
    )

{-|


## Create transitions from page to page!

A huge benefit to doing client-side rendering is the ability to
seamlessly navigate from one page to another!

This package is designed to make creating page transitions a breeze!

@docs Transition


## Use one of these transitions

@docs none, fade


## Or create your own

@docs custom

-}

import Html exposing (Html)
import Internals.Transition


{-| Describes how to move from one page to another.

    transition : Transition msg
    transition =
        Transition.none

-}
type alias Transition msg =
    Internals.Transition.Transition msg



-- TRANSITIONS


{-| Don't transition from one page to another.

    transitions : Transitions msg
    transitions =
        { layout = Transition.none -- page loads instantly
        , page = Transition.fade 300
        , pages = []
        }

-}
none : Transition msg
none =
    Internals.Transition.none


{-| Fade one page out and another one in.

Animation duration is represented in **milliseconds**

    transitions : Spa.Types.Transitions msg
    transitions =
        { layout = Transition.none
        , page = Transition.fade 300 -- 300 milliseconds
        , pages = []
        }

-}
fade : Int -> Transition msg
fade =
    Internals.Transition.fade


{-| Create your own custom transition!

Just provide three things:

  - `duration` – how long (in milliseconds) the transition should last.

  - `invisible` – what the page looks like when out of view.

  - `visible` – what the page looks like when in view.

```
import Html
import Html.Attributes as Attr

batmanNewspaper : Int -> Transition msg
batmanNewspaper duration =
    let
        transition : Html.Attribute msg
        transition =
            Attr.style "transition"
                ("all " ++ String.fromInt duration ++ "ms")

        invisible : Html msg -> Html msg
        invisible page =
            Html.div
                [ Attr.style "opacity" "0"
                , Attr.style "transform" "rotate(1800deg), scale(0)"
                , transition
                ]
                [ page ]

        visible : Html msg -> Html msg
        visible page =
            Html.div
                [ Attr.style "opacity" "1"
                , Attr.style "transform" "none"
                , transition
                ]
                [ page ]
    in
    Transition.custom
        { duration = duration
        , invisible = invisible
        , visible =
        }

--
-- using it later on
--
transitions : Spa.Types.Transitions msg
transitions =
    { layout = batmanNewspaper 500 -- 🦇
    , page = Transition.none
    , pages = []
    }
```

-}
custom :
    { duration : Int
    , invisible : Html msg -> Html msg
    , visible : Html msg -> Html msg
    }
    -> Transition msg
custom =
    Internals.Transition.custom
