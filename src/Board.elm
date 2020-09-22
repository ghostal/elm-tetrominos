module Board exposing (Board, firstEmptySquare, getPlacedTetrominoBag, isLatestPlacementValid, isSolved)

import Coordinate exposing (Coordinate)
import Placement exposing (Placement)
import Tetromino exposing (Tetromino(..))
import TetrominoBag exposing (TetrominoBag)
import TetrominoMap


type alias Board =
    { width : Int
    , height : Int
    , placements : List Placement
    }


getPlacedTetrominoBag : Board -> TetrominoBag
getPlacedTetrominoBag board =
    List.foldl
        (\placement bag ->
            case placement.tetromino of
                OTetromino ->
                    { bag | o = bag.o + 1 }

                ITetromino ->
                    { bag | i = bag.i + 1 }

                TTetromino ->
                    { bag | t = bag.t + 1 }

                JTetromino ->
                    { bag | j = bag.j + 1 }

                LTetromino ->
                    { bag | l = bag.l + 1 }

                STetromino ->
                    { bag | s = bag.s + 1 }

                ZTetromino ->
                    { bag | z = bag.z + 1 }
        )
        (TetrominoBag 0 0 0 0 0 0 0)
        board.placements


isSolved : Board -> Bool
isSolved board =
    let
        placedArea =
            4 * List.length board.placements

        boardArea =
            board.width * board.height
    in
    case List.reverse board.placements of
        [] ->
            False

        x :: xs ->
            case placedArea < boardArea of
                True ->
                    False

                False ->
                    not (Placement.overlaps xs x) && not (outOfBounds x board)


isLatestPlacementValid : Board -> Bool
isLatestPlacementValid board =
    case List.reverse board.placements of
        [] ->
            True

        x :: xs ->
            not (Placement.overlaps xs x) && not (outOfBounds x board)


firstEmptySquare : Board -> Coordinate
firstEmptySquare board =
    let
        placements =
            List.map (\placement -> placement.placement) board.placements

        coordinates =
            List.map TetrominoMap.getSquares placements
                |> List.concat
    in
    case coordinates of
        [] ->
            ( 0, 0 )

        xs ->
            findFirstEmptySquare coordinates board.width board.height 0 0


findFirstEmptySquare : List Coordinate -> Int -> Int -> Int -> Int -> Coordinate
findFirstEmptySquare used w h x y =
    if List.member ( x, y ) used then
        let
            newX =
                if x + 1 < w then
                    x + 1

                else
                    0

            newY =
                if newX == 0 then
                    y + 1

                else
                    y
        in
        findFirstEmptySquare used w h newX newY

    else
        ( x, y )


outOfBounds : Placement -> Board -> Bool
outOfBounds placement board =
    TetrominoMap.getSquares placement.placement
        |> List.map
            (\square ->
                let
                    x =
                        Tuple.first square

                    y =
                        Tuple.second square
                in
                x < 0 || y < 0 || x >= board.width || y >= board.height
            )
        |> List.any (\result -> result == True)
