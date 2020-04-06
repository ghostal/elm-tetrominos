module Tetrominos exposing (main)

import Browser
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Tetromino exposing (Tetromino(..))
import TetrominoBag exposing (TetrominoBag)
import TetrominoMap exposing (..)


type alias Model =
    { tileQuantities : Maybe TetrominoBag
    , possibleBoards : Maybe (List ( Int, Int ))
    }


type Msg
    = Tick


initialModel : Model
initialModel =
    let
        bag =
            { o = 7
            , i = 7
            , s = 7
            , z = 7
            , t = 7
            , j = 7
            , l = 7
            }
    in
    Debug.log "tile bag"
        { tileQuantities =
            Just
                bag
        , possibleBoards = Just (calculatePossibleBoards bag)
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
