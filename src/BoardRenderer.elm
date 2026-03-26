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
    div []
        [ Canvas.toHtml
            ( canvasWidth board, canvasHeight board )
            []
            (List.concat
                [ [ resetScreen board ]
                , [ renderGrid board ]
                , List.concatMap
                    (\placement ->
                        [ shapes
                            [ fill (Tetromino.getTetrominoBorderColor placement.tetromino) ]
                            (renderMap board placement.placement)
                        , shapes
                            [ fill (Tetromino.getTetrominoColor placement.tetromino) ]
                            (renderMapInner board placement.placement)
                        ]
                    )
                    board.placements
                ]
            )
        , p []
            [ text
                (String.fromInt board.width
                    ++ " x "
                    ++ String.fromInt board.height
                )
            ]
        ]


renderGrid : Board -> Renderable
renderGrid board =
    let
        cells =
            List.concatMap
                (\col -> List.map (\row -> ( col, row )) (List.range 0 (board.height - 1)))
                (List.range 0 (board.width - 1))
    in
    shapes
        [ fill (Color.rgb255 238 238 238) ]
        (List.map
            (\( col, row ) ->
                let
                    x =
                        toFloat (col * round squareSize + gutterSize) + borderSize

                    y =
                        toFloat (-(row * round squareSize) + board.height * round squareSize) + borderSize
                in
                rect ( x, y ) (squareSize - borderSize * 2) (squareSize - borderSize * 2)
            )
            cells
        )


renderMap : Board -> TetrominoMap -> List Shape
renderMap board map =
    List.map
        (\square -> rect (Coordinate.toPoint square) squareSize squareSize)
        (squareCoordinates board map)


renderMapInner : Board -> TetrominoMap -> List Shape
renderMapInner board map =
    List.map
        (\square ->
            let
                ( x, y ) =
                    Coordinate.toPoint square
            in
            rect ( x + borderSize, y + borderSize ) (squareSize - borderSize * 2) (squareSize - borderSize * 2)
        )
        (squareCoordinates board map)


squareCoordinates : Board -> TetrominoMap -> List Coordinate.Coordinate
squareCoordinates board map =
    let
        renderedOrigin =
            ( gutterSize
            , board.height * round squareSize
            )

        scale =
            \x -> x * round squareSize

        translateCoord =
            \c ->
                ( Tuple.first c + gutterSize
                , Tuple.second c * -1 + Tuple.second renderedOrigin
                )
    in
    [ map.a, map.b, map.c, map.d ]
        |> List.map (\coordinate -> Tuple.mapBoth scale scale coordinate)
        |> List.map translateCoord


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
    (board.width * round squareSize) + gutterSize * 2


canvasHeight : Board -> Int
canvasHeight board =
    (board.height * round squareSize) + gutterSize * 2


gutterSize : Int
gutterSize =
    50


squareSize : Float
squareSize =
    20


borderSize : Float
borderSize =
    1
