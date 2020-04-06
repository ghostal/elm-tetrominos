module Tetrominos exposing (main)

import Board exposing (Board)
import Browser
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Tetromino exposing (Tetromino(..))
import TetrominoBag exposing (TetrominoBag)
import TetrominoMap exposing (..)


type alias Model =
    { tileQuantities : TetrominoBag
    , possibleBoards : Maybe (List ( Int, Int ))
    }


type Msg
    = Tick
    | ChangedTetrominoCount Tetromino String
    | StartClicked


initialModel : Model
initialModel =
    let
        bag =
            { o = 0
            , i = 0
            , s = 0
            , z = 0
            , t = 0
            , j = 0
            , l = 0
            }
    in
    { tileQuantities =
        bag
    , possibleBoards = Nothing
    }


calculatePossibleBoards : TetrominoBag -> List ( Int, Int )
calculatePossibleBoards bag =
    let
        area =
            4 * List.foldl (+) 0 [ bag.o, bag.i, bag.s, bag.z, bag.t, bag.j, bag.l ]
    in
    List.foldl
        (\candidate acc ->
            if area // candidate >= candidate && modBy candidate area == 0 then
                ( candidate, area // candidate ) :: acc

            else
                acc
        )
        []
        (List.range
            1
            (area // 2)
        )


view : Model -> Html Msg
view model =
    case model.possibleBoards of
        Nothing ->
            viewInitializationSettings model

        Just possibleBoards ->
            viewPossibleBoards model possibleBoards


viewInitializationSettings : Model -> Html Msg
viewInitializationSettings model =
    div []
        [ table []
            (List.map
                (\constructor ->
                    tr []
                        [ td [] [ text (Tetromino.getTetrominoName constructor) ]
                        , td []
                            [ input [ onInput (ChangedTetrominoCount constructor), value (String.fromInt (TetrominoBag.getTetrominoQuantity constructor model.tileQuantities)) ] []
                            ]
                        ]
                )
                Tetromino.allTetrominoes
            )
        , button [ onClick StartClicked ] [ text "Solve!" ]
        ]


viewPossibleBoards : Model -> List ( Int, Int ) -> Html Msg
viewPossibleBoards model boards =
    div []
        (List.map
            (\board ->
                div []
                    [ text
                        (String.fromInt (Tuple.first board)
                            ++ " x "
                            ++ String.fromInt (Tuple.second board)
                        )
                    ]
            )
            boards
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedTetrominoCount tetromino value ->
            ( { model
                | tileQuantities =
                    TetrominoBag.updateQuantity
                        tetromino
                        (case String.toInt value of
                            Just int ->
                                int

                            Nothing ->
                                0
                        )
                        model.tileQuantities
              }
            , Cmd.none
            )

        StartClicked ->
            ( { model | possibleBoards = Just (calculatePossibleBoards model.tileQuantities) }, Cmd.none )

        Tick ->
            ( model, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
