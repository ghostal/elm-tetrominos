module Tetromino exposing (Tetromino(..), allTetrominoes, getRotationOptions, getTetrominoColor, getTetrominoMap, getTetrominoName)

import Color exposing (Color)
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
    [ OTetromino
    , TTetromino
    , JTetromino
    , STetromino
    , ZTetromino
    , LTetromino
    , ITetromino
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


getTetrominoColor : Tetromino -> Color
getTetrominoColor tetromino =
    case tetromino of
        ITetromino ->
            Color.rgb255 0 193 251

        OTetromino ->
            Color.rgb255 249 248 113

        TTetromino ->
            Color.rgb255 189 147 249

        JTetromino ->
            Color.rgb255 100 150 247

        LTetromino ->
            Color.rgb255 255 174 134

        STetromino ->
            Color.rgb255 0 117 91

        ZTetromino ->
            Color.rgb255 194 78 57


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
            TetrominoMap ( 0, 0 ) ( 0, 1 ) ( 1, 0 ) ( 2, 0 )

        LTetromino ->
            TetrominoMap ( 0, 0 ) ( 1, 0 ) ( 0, 1 ) ( 0, 2 )

        STetromino ->
            TetrominoMap ( 0, 0 ) ( 1, 0 ) ( 1, 1 ) ( 2, 1 )

        ZTetromino ->
            TetrominoMap ( 1, 0 ) ( 2, 0 ) ( 0, 1 ) ( 1, 1 )


getRotationOptions : Tetromino -> List TetrominoMap
getRotationOptions tetromino =
    TetrominoMap.buildRotationOptions (getTetrominoMap tetromino) []
