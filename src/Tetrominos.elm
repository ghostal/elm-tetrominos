module Tetrominos exposing (main)

import Browser
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Tetromino exposing (Tetromino(..))
import TetrominoMap exposing (..)


type alias Model =
    List TetrominoMap


type Msg
    = Tick


initialModel : Model
initialModel =
    Debug.log "maps" (getRotationOptions (Tetromino.getTetrominoMap TTetromino) [])


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
