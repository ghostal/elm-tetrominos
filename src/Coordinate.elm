module Coordinate exposing (Coordinate, chooseLowestThenLeftmostCoordinate, toPoint)

import Canvas exposing (Point)


type alias Coordinate =
    ( Int, Int )


chooseLowestThenLeftmostCoordinate : Coordinate -> Coordinate -> Coordinate
chooseLowestThenLeftmostCoordinate a b =
    case compare (Tuple.second a) (Tuple.second b) of
        LT ->
            a

        GT ->
            b

        EQ ->
            case compare (Tuple.first a) (Tuple.first b) of
                LT ->
                    a

                GT ->
                    b

                EQ ->
                    -- TODO: This is a hack - this should never be reached
                    a


toPoint : Coordinate -> Point
toPoint coordinate =
    ( toFloat (Tuple.first coordinate)
    , toFloat (Tuple.second coordinate)
    )
