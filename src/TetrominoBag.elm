module TetrominoBag exposing (TetrominoBag, area, firstAfter, getTetrominoQuantity, updateQuantity)

import Debug
import Tetromino exposing (Tetromino(..))


type alias TetrominoBag =
    { o : Int
    , i : Int
    , s : Int
    , z : Int
    , t : Int
    , j : Int
    , l : Int
    }


updateQuantity : Tetromino -> Int -> TetrominoBag -> TetrominoBag
updateQuantity tetromino quantity bag =
    case tetromino of
        ITetromino ->
            { bag | i = quantity }

        OTetromino ->
            { bag | o = quantity }

        TTetromino ->
            { bag | t = quantity }

        JTetromino ->
            { bag | j = quantity }

        LTetromino ->
            { bag | l = quantity }

        STetromino ->
            { bag | s = quantity }

        ZTetromino ->
            { bag | z = quantity }


area : TetrominoBag -> Int
area bag =
    totalQuantity bag * 4


totalQuantity : TetrominoBag -> Int
totalQuantity bag =
    List.map (\t -> getTetrominoQuantity t bag) Tetromino.allTetrominoes
        |> List.sum


getTetrominoQuantity : Tetromino -> TetrominoBag -> Int
getTetrominoQuantity tetromino bag =
    case tetromino of
        ITetromino ->
            bag.i

        OTetromino ->
            bag.o

        TTetromino ->
            bag.t

        JTetromino ->
            bag.j

        LTetromino ->
            bag.l

        STetromino ->
            bag.s

        ZTetromino ->
            bag.z


firstAfter : TetrominoBag -> Maybe Tetromino -> TetrominoBag -> Maybe Tetromino
firstAfter bag afterTetromino used =
    List.foldl
        (\tetromino maybe ->
            case maybe of
                Just _ ->
                    maybe

                Nothing ->
                    if getTetrominoQuantity tetromino bag > getTetrominoQuantity tetromino used then
                        Just tetromino

                    else
                        Nothing
        )
        Nothing
        (case afterTetromino of
            Nothing ->
                Tetromino.allTetrominoes

            Just x ->
                dropUntil Tetromino.allTetrominoes x
        )


dropUntil : List Tetromino -> Tetromino -> List Tetromino
dropUntil list match =
    case list of
        x :: xs ->
            if x == match then
                xs

            else
                dropUntil xs match

        [] ->
            []
