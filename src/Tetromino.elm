module Tetromino exposing (Tetromino(..), allTetrominoes, getTetrominoMap, getTetrominoName)

import TetrominoMap exposing (TetrominoMap)


type Tetromino
    = ITetromino
    | OTetromino
    | TTetromino
    | JTetromino
    | LTetromino
    | STetromino
    | ZTetromino


allTetrominoes : List Tetromino
allTetrominoes =
    [ ITetromino
    , OTetromino
    , TTetromino
    , JTetromino
    , LTetromino
    , STetromino
    , ZTetromino
    ]


getTetrominoName : Tetromino -> String
getTetrominoName tetromino =
    case tetromino of
        ITetromino ->
            "I"

        OTetromino ->
            "O"

        TTetromino ->
            "T"

        JTetromino ->
            "J"

        LTetromino ->
            "L"

        STetromino ->
            "S"

        ZTetromino ->
            "Z"


getTetrominoMap : Tetromino -> TetrominoMap
getTetrominoMap tetromino =
    case tetromino of
        ITetromino ->
            TetrominoMap ( 0, 0 ) ( 0, 1 ) ( 0, 2 ) ( 0, 3 )

        OTetromino ->
            TetrominoMap ( 0, 0 ) ( 0, 1 ) ( 1, 0 ) ( 1, 1 )

        TTetromino ->
            TetrominoMap ( 1, 0 ) ( 0, 1 ) ( 1, 1 ) ( 2, 1 )

        JTetromino ->
            TetrominoMap ( 0, 0 ) ( 0, 1 ) ( 1, 1 ) ( 1, 2 )

        LTetromino ->
            TetrominoMap ( 0, 0 ) ( 1, 0 ) ( 0, 1 ) ( 0, 2 )

        STetromino ->
            TetrominoMap ( 0, 0 ) ( 1, 0 ) ( 1, 1 ) ( 2, 1 )

        ZTetromino ->
            TetrominoMap ( 1, 0 ) ( 2, 0 ) ( 0, 1 ) ( 1, 1 )
