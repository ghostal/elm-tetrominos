module Placement exposing (Placement)

import Coordinate exposing (Coordinate)
import Tetromino exposing (Tetromino)
import TetrominoMap exposing (TetrominoMap)


type alias Placement =
    { placementSquare : Coordinate -- Board square the root square is placed on
    , placement : TetrominoMap -- Map of squares used by this placement
    , tetromino : Tetromino -- The tetromino that's been placed
    }
