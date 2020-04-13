module Solver exposing (Solver, solve)

import Board exposing (Board)
import Tetromino exposing (getRotationOptions)
import TetrominoBag exposing (TetrominoBag)
import TetrominoMap


type alias Solver =
    { unsolvedBoards : List Board
    , activeBoard : Maybe Board
    , solvedBoards : List Board
    , failedBoards : List Board
    , bag : TetrominoBag
    }


solve : Solver -> Solver
solve solver =
    case solver.activeBoard of
        Nothing ->
            activateNextBoard solver

        Just board ->
            if Board.isSolved board then
                solveActiveBoard solver

            else if Board.isLatestPlacementValid board then
                let
                    maybeNextTetromino =
                        TetrominoBag.firstAfter
                            solver.bag
                            Nothing
                            (Board.getPlacedTetrominoBag board)
                in
                case maybeNextTetromino of
                    Nothing ->
                        failActiveBoard solver

                    Just nextTetromino ->
                        let
                            rotations =
                                getRotationOptions nextTetromino

                            nextRotation =
                                List.head rotations

                            emptySquare =
                                Board.firstEmptySquare board
                        in
                        case nextRotation of
                            Nothing ->
                                -- Apparently this tetromino has zero rotations?!
                                failActiveBoard solver

                            Just map ->
                                -- TODO: Place this map at the next blank tile.
                                { solver
                                    | activeBoard =
                                        Just
                                            { board
                                                | placements =
                                                    List.append
                                                        board.placements
                                                        [ { placement = TetrominoMap.translate emptySquare map
                                                          , placementSquare = emptySquare
                                                          , tetromino = nextTetromino
                                                          }
                                                        ]
                                            }
                                }

            else
                -- TODO: Invalid latest placement - so try the next rotation (or tetromino, if there's no more rotations)
                solver


activateNextBoard : Solver -> Solver
activateNextBoard solver =
    case solver.unsolvedBoards of
        [] ->
            solver

        x :: xs ->
            { solver
                | activeBoard = Just x
                , unsolvedBoards = xs
            }


solveActiveBoard : Solver -> Solver
solveActiveBoard solver =
    case solver.activeBoard of
        Nothing ->
            solver

        Just board ->
            { solver
                | activeBoard = Nothing
                , solvedBoards = board :: solver.solvedBoards
            }


failActiveBoard : Solver -> Solver
failActiveBoard solver =
    case solver.activeBoard of
        Nothing ->
            solver

        Just board ->
            { solver
                | activeBoard = Nothing
                , failedBoards = board :: solver.failedBoards
            }
