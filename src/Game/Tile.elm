module Game.Tile exposing (Tile, TileState(..), dummyTile)


type TileState
    = FaceUp
    | FaceDown
    | Done


type alias Tile =
    { color : String, state : TileState, index : Int }


dummyTile : Tile
dummyTile =
    { color = "", state = FaceDown, index = -1 }
