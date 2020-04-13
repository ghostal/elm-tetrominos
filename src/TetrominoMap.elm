module TetrominoMap exposing (TetrominoMap, buildRotationOptions, getSquares, translate)

import Coordinate exposing (Coordinate)


type alias TetrominoMap =
    { a : Coordinate
    , b : Coordinate
    , c : Coordinate
    , d : Coordinate
    }


buildRotationOptions : TetrominoMap -> List TetrominoMap -> List TetrominoMap
buildRotationOptions map discoveredRotations =
    let
        rotated =
            rotate map
    in
    case List.member rotated discoveredRotations of
        True ->
            discoveredRotations

        False ->
            buildRotationOptions rotated (List.append discoveredRotations [ rotated ])


rotate : TetrominoMap -> TetrominoMap
rotate map =
    normalize
        (TetrominoMap
            ( Tuple.second map.a, negate (Tuple.first map.a) )
            ( Tuple.second map.b, negate (Tuple.first map.b) )
            ( Tuple.second map.c, negate (Tuple.first map.c) )
            ( Tuple.second map.d, negate (Tuple.first map.d) )
        )


normalize : TetrominoMap -> TetrominoMap
normalize map =
    map
        |> normalizeRootSquare
        |> normalizeSquareOrder


normalizeRootSquare : TetrominoMap -> TetrominoMap
normalizeRootSquare map =
    let
        rootSquare =
            getRootSquare map
    in
    case rootSquare of
        ( 0, 0 ) ->
            map

        _ ->
            translate ( negate (Tuple.first rootSquare), negate (Tuple.second rootSquare) ) map


normalizeSquareOrder : TetrominoMap -> TetrominoMap
normalizeSquareOrder map =
    case compareCoordinates map.a map.b of
        GT ->
            normalizeSquareOrder (TetrominoMap map.b map.a map.c map.d)

        _ ->
            case compareCoordinates map.b map.c of
                GT ->
                    normalizeSquareOrder (TetrominoMap map.a map.c map.b map.d)

                _ ->
                    case compareCoordinates map.c map.d of
                        GT ->
                            normalizeSquareOrder (TetrominoMap map.a map.b map.d map.c)

                        _ ->
                            map


compareCoordinates : Coordinate -> Coordinate -> Order
compareCoordinates a b =
    let
        rowComparison =
            compare (Tuple.second a) (Tuple.second b)

        colComparison =
            compare (Tuple.first a) (Tuple.first b)
    in
    case rowComparison of
        EQ ->
            colComparison

        _ ->
            rowComparison


translate : Coordinate -> TetrominoMap -> TetrominoMap
translate translation map =
    let
        add_x =
            (+) (Tuple.first translation)

        add_y =
            (+) (Tuple.second translation)
    in
    TetrominoMap
        (map.a |> Tuple.mapFirst add_x |> Tuple.mapSecond add_y)
        (map.b |> Tuple.mapFirst add_x |> Tuple.mapSecond add_y)
        (map.c |> Tuple.mapFirst add_x |> Tuple.mapSecond add_y)
        (map.d |> Tuple.mapFirst add_x |> Tuple.mapSecond add_y)


getRootSquare : TetrominoMap -> Coordinate
getRootSquare map =
    fold Coordinate.chooseLowestThenLeftmostCoordinate map


getSquares : TetrominoMap -> List Coordinate
getSquares map =
    [ map.a, map.b, map.c, map.d ]


fold : (Coordinate -> Coordinate -> Coordinate) -> TetrominoMap -> Coordinate
fold func map =
    map.a
        |> func map.b
        |> func map.c
        |> func map.d
