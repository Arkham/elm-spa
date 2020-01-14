module Main exposing (main)

import Global
import Pages
import Routes
import Spa
import Spa.Transition


main : Spa.Program Global.Flags Global.Model Global.Msg Pages.Model Pages.Msg
main =
    Spa.create
        { transitions =
            { layout = Spa.Transition.none
            , page = Spa.Transition.fade 300
            , pages = []
            }
        , routing =
            { routes = Routes.routes
            , toPath = Routes.toPath
            , notFound = Routes.NotFound
            , afterNavigate = Nothing
            }
        , global =
            { init = Global.init
            , update = Global.update
            , subscriptions = Global.subscriptions
            }
        , page = Pages.page
        }
