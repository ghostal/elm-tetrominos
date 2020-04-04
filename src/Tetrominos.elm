module Tetrominos exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    Int


type Msg
    = Tick


type Tetromino
    = ITetromino
    | OTetromino
    | TTetromino
    | JTetromino
    | LTetromino
    | STetromino
    | ZTetromino


getTetrominoMap : Tetromino -> List ( Int, Int )
getTetrominoMap tetromino =
    case tetromino of
        ITetromino ->
            [ ( 0, 0 ), ( 0, 1 ), ( 0, 2 ), ( 0, 3 ) ]

        OTetromino ->
            [ ( 0, 0 ), ( 0, 1 ), ( 1, 0 ), ( 1, 1 ) ]

        TTetromino ->
            [ ( 1, 0 ), ( 0, 1 ), ( 1, 1 ), ( 2, 1 ) ]

        JTetromino ->
            [ ( 0, 0 ), ( 0, 1 ), ( 1, 1 ), ( 1, 2 ) ]

        LTetromino ->
            [ ( 0, 0 ), ( 1, 0 ), ( 0, 1 ), ( 0, 2 ) ]

        STetromino ->
            [ ( 0, 0 ), ( 1, 0 ), ( 1, 1 ), ( 2, 1 ) ]

        ZTetromino ->
            [ ( 1, 0 ), ( 2, 0 ), ( 0, 1 ), ( 1, 1 ) ]


initialModel : Model
initialModel =
    1


view : Model -> Html Msg
view model =
    div [] []


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
