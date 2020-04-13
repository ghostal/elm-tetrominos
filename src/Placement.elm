module Placement exposing (Placement, overlaps)

import Coordinate exposing (Coordinate)
import Tetromino exposing (Tetromino)
import TetrominoMap exposing (TetrominoMap)


type alias Placement =
    { placementSquare : Coordinate -- Board square the root square is placed on
    , placement : TetrominoMap -- Map of squares used by this placement
    , tetromino : Tetromino -- The tetromino that's been placed
    }


overlaps : List Placement -> Placement -> Bool
overlaps placements candidate =
    -- TODO: Implement a real version of this method
    True
