module Solver exposing (Solver, solve)

import Board exposing (Board)
import CustomList
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
                retryLatestPlacement solver


retryLatestPlacement : Solver -> Solver
retryLatestPlacement solver =
    -- TODO: Invalid latest placement - so try the next rotation (or tetromino, if there's no more rotations)
    case solver.activeBoard of
        Nothing ->
            solver

        Just board ->
            case List.reverse board.placements of
                [] ->
                    failActiveBoard solver

                -- TODO: Pop the latest placement from the end of the list
                x :: reversedRemainingPlacements ->
                    let
                        -- TODO: See if there are other rotations after the current one
                        rotations =
                            Tetromino.getRotationOptions x.tetromino

                        nextRotation =
                            CustomList.firstAfter rotations (Just (TetrominoMap.normalize x.placement))

                        remainingPlacements =
                            List.reverse reversedRemainingPlacements
                    in
                    case nextRotation of
                        Nothing ->
                            -- TODO: If not, get the next tetromino
                            let
                                maybeNextTetromino =
                                    TetrominoBag.firstAfter
                                        solver.bag
                                        (Just x.tetromino)
                                        (Board.getPlacedTetrominoBag board)

                                nextTetrominoRotations =
                                    case maybeNextTetromino of
                                        Nothing ->
                                            []

                                        Just tetromino ->
                                            getRotationOptions tetromino

                                maybeNextTetrominoNextRotation =
                                    List.head nextTetrominoRotations
                            in
                            case maybeNextTetromino of
                                Nothing ->
                                    -- TODO: If no remaining tetromino... call this method again.
                                    let
                                        amendedSolver =
                                            { solver
                                                | activeBoard =
                                                    Just
                                                        { board
                                                            | placements = remainingPlacements
                                                        }
                                            }
                                    in
                                    retryLatestPlacement amendedSolver

                                Just nextTetromino ->
                                    case maybeNextTetrominoNextRotation of
                                        Just map ->
                                            { solver
                                                | activeBoard =
                                                    Just
                                                        { board
                                                            | placements =
                                                                List.append
                                                                    remainingPlacements
                                                                    [ { placement = TetrominoMap.translate x.placementSquare map
                                                                      , placementSquare = x.placementSquare
                                                                      , tetromino = nextTetromino
                                                                      }
                                                                    ]
                                                        }
                                            }

                                        Nothing ->
                                            -- TODO: If no remaining tetromino... call this method again.
                                            let
                                                amendedSolver =
                                                    { solver
                                                        | activeBoard =
                                                            Just
                                                                { board
                                                                    | placements = remainingPlacements
                                                                }
                                                    }
                                            in
                                            retryLatestPlacement amendedSolver

                        Just map ->
                            { solver
                                | activeBoard =
                                    Just
                                        { board
                                            | placements =
                                                List.append
                                                    remainingPlacements
                                                    [ { placement = TetrominoMap.translate x.placementSquare map
                                                      , placementSquare = x.placementSquare
                                                      , tetromino = x.tetromino
                                                      }
                                                    ]
                                        }
                            }


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
