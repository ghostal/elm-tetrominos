module Board exposing (Board, getPlacedTetrominoBag)

import Placement exposing (Placement)
import Tetromino exposing (Tetromino(..))
import TetrominoBag exposing (TetrominoBag)


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
