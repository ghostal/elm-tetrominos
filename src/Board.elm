module Board exposing (Board)

import Placement exposing (Placement)


type alias Board =
    { width : Int
    , height : Int
    , placements : List Placement
    }
