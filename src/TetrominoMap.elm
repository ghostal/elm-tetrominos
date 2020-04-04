module TetrominoMap exposing (TetrominoMap)


type alias TetrominoMap =
    { a : Coordinate
    , b : Coordinate
    , c : Coordinate
    , d : Coordinate
    }


type alias Coordinate =
    ( Int, Int )


getRotationOptions : TetrominoMap -> List TetrominoMap
getRotationOptions map =
    -- TODO: Implement properly
    [ map ]


normalize : TetrominoMap -> TetrominoMap
normalize map =
    let
        rootSquare =
            getRootSquare map
    in
    case rootSquare of
        ( 0, 0 ) ->
            map

        _ ->
            translate ( negate (Tuple.first rootSquare), negate (Tuple.second rootSquare) ) map


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
    fold chooseLowestThenLeftmostCoordinate map


fold : (Coordinate -> Coordinate -> Coordinate) -> TetrominoMap -> Coordinate
fold func map =
    map.a
        |> func map.b
        |> func map.c
        |> func map.d


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
