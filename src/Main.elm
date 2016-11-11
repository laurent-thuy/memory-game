module Main exposing (..)

import Html.App as App
import Game.Tile exposing (Tile, TileState(..), dummyTile)
import Game.Model exposing (Model)
import Game.View exposing (view)
import Game.Update exposing (update, Msg(..))
import Time
import Random
import Style.Colors exposing (colorsGenerator)


init : ( Model, Cmd Msg )
init =
    ( { tiles = createTiles }
    , Random.generate NewColors colorsGenerator
    )


createTiles : List Tile
createTiles =
    { color = "", state = FaceDown, index = 0 }
        |> List.repeat 16
        |> List.indexedMap
            (\index tile ->
                { tile | index = index }
            )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.second * 0.1) CheckBoard



-- main


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
