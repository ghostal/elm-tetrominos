module TetrominoBag exposing (TetrominoBag, getTetrominoQuantity, updateQuantity)

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
