module BoardRenderer exposing (render)

import Board exposing (Board)
import Canvas exposing (Renderable, Shape, rect, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Color
import Coordinate
import Html exposing (..)
import Tetromino
import TetrominoMap exposing (TetrominoMap)


render : Board -> Html a
render board =
    Canvas.toHtml
        ( canvasWidth board, canvasHeight board )
        []
        (List.concat
            [ [ resetScreen board ]
            , List.map
                (\placement ->
                    shapes
                        [ fill (Tetromino.getTetrominoColor placement.tetromino) ]
                        (renderMap board placement.placement)
                )
                board.placements
            ]
        )


renderMap : Board -> TetrominoMap -> List Shape
renderMap board map =
    let
        renderedOrigin =
            ( gutterSize
            , board.height * round squareSize
            )

        scale =
            \x -> x * round squareSize

        translate =
            \c ->
                ( Tuple.first c + gutterSize
                , Tuple.second c * -1 + Tuple.second renderedOrigin
                )

        squares =
            [ map.a, map.b, map.c, map.d ]
                |> List.map
                    (\coordinate -> Tuple.mapBoth scale scale coordinate)
                |> List.map translate
    in
    List.map
        (\square -> rect (Coordinate.toPoint square) squareSize squareSize)
        squares


resetScreen : Board -> Renderable
resetScreen board =
    let
        width =
            toFloat (canvasWidth board)

        height =
            toFloat (canvasHeight board)
    in
    shapes [ fill Color.white ] [ rect ( 0, 0 ) width height ]


canvasWidth : Board -> Int
canvasWidth board =
    (board.width * round squareSize) + gutterSize


canvasHeight : Board -> Int
canvasHeight board =
    (board.height * round squareSize) + gutterSize


gutterSize : Int
gutterSize =
    20


squareSize : Float
squareSize =
    10
