module Tetrominos exposing (Model, Msg, main)

import Board exposing (Board)
import Browser
import Debug
import Delay
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Solver exposing (Solver)
import Tetromino exposing (Tetromino(..))
import TetrominoBag exposing (TetrominoBag)
import TetrominoMap exposing (..)


type ApplicationState
    = InitialConfiguration
    | Solving


type alias Model =
    { appState : ApplicationState
    , tileQuantities : TetrominoBag
    , possibleBoards : Maybe (List ( Int, Int ))
    , solver : Maybe Solver
    }


type Msg
    = Tick
    | ChangedTetrominoCount Tetromino String
    | SolveClicked


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
    { appState = InitialConfiguration
    , tileQuantities =
        bag
    , possibleBoards = Nothing
    , solver = Nothing
    }


calculatePossibleBoards : TetrominoBag -> List ( Int, Int )
calculatePossibleBoards bag =
    let
        area =
            TetrominoBag.area bag
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
        , button [ onClick SolveClicked ] [ text "Solve!" ]
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

        SolveClicked ->
            let
                possibleBoards =
                    calculatePossibleBoards model.tileQuantities
            in
            case possibleBoards of
                [] ->
                    Debug.log "no possible boards" ( model, Cmd.none )

                x :: xs ->
                    Debug.log "set up some boards"
                        ( { model
                            | solver =
                                Just
                                    { unsolvedBoards =
                                        List.map
                                            (\element ->
                                                { width = Tuple.first element
                                                , height = Tuple.second element
                                                , placements = []
                                                }
                                            )
                                            xs
                                    , activeBoard =
                                        Just
                                            { width = Tuple.first x
                                            , height = Tuple.second x
                                            , placements = []
                                            }
                                    , solvedBoards = []
                                    , failedBoards = []
                                    , bag = model.tileQuantities
                                    }
                            , appState = Solving
                          }
                        , Delay.after 500 Delay.Millisecond Tick
                        )

        Tick ->
            case model.appState of
                Solving ->
                    case model.solver of
                        Just solver ->
                            ( { model | solver = Just (Debug.log "tick!" (Solver.solve solver)) }, Delay.after 500 Delay.Millisecond Tick )

                        _ ->
                            ( { model | appState = InitialConfiguration }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
