module Main exposing (..)

import Html.App as App
import Tile exposing (Tile, TileState(..), dummyTile)
import Model exposing (Model)
import View exposing (view)
import Update exposing (update, Msg(..))
import Style.W3css exposing (w3Colors)
import Time


-- colors
-- TODO    randomize colors order


colors : List String
colors =
    w3Colors


init : ( Model, Cmd Msg )
init =
    ( { tiles = createTiles }
    , Cmd.none
    )


createTiles : List Tile
createTiles =
    { color = "", state = FaceDown, index = 0 }
        |> List.repeat 16
        |> List.indexedMap
            (\index tile ->
                { tile | index = index }
            )
        |> List.map2 (\color tile -> { tile | color = color }) colors



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
