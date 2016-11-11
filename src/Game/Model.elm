module Game.Model exposing (Model)

import Game.Tile exposing (Tile)
import Array exposing (Array)


type alias Model =
    { tiles : List Tile }
