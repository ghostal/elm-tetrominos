module Tetrominos exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    Int


type Msg
    = Tick


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
