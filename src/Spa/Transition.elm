module Spa.Transition exposing
    ( Transition
    , none
    , custom
    , fade
    )

{-|


## Create transitions from page to page!

A huge benefit to doing client-side rendering is the ability to
seamlessly navigate from one page to another!

This package is designed to make creating page transitions a breeze!

@docs Transition


## Use one of these transitions

@docs none, fadeElmUi, fadeHtml


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

Can be used with `Html msg` or `Element msg` (or another view library)

    transitions : Transitions (Html msg)
    transitions =
        { layout = Transition.none -- page loads instantly
        , page = Transition.fadeHtml 300
        , pages = []
        }

    otherTransitions : Transitions (Element msg)
    otherTransitions =
        { layout = Transition.none -- page loads instantly
        , page = Transition.fadeElmUi 300
        , pages = []
        }

-}
none : Transition msg
none =
    Internals.Transition.none


{-| Fade one page out and another one in. (For use with `elm/html`)

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

  - `invisible` – what the page looks like when **invisible**.

  - `visible` – what the page looks like when **visible**.

```
batmanNewspaper : Int -> Transition (Element msg)
batmanNewspaper duration =
    Transition.custom
        { duration = duration
        , invisible =
            \page ->
                el
                    [ alpha 0
                    , width fill
                    , rotate (4 * pi)
                    , scale 0
                    , Styles.transition
                        { property = "all"
                        , duration = duration
                        }
                    ]
                    page
        , visible =
            \page ->
                el
                    [ alpha 1
                    , width fill
                    , Styles.transition
                        { property = "all"
                        , duration = duration
                        }
                    ]
                    page
        }

--
-- using it later on
--
transitions : Spa.Types.Transitions (Element msg)
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
