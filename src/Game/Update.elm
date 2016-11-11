module Game.Update exposing (update, Msg(..))

import Game.Model exposing (Model)
import Time exposing (Time)
import Game.Tile exposing (Tile, TileState(..), dummyTile)
import List.Extra exposing (updateAt, getAt)
import Array exposing (Array)


type Msg
    = TurnUp Int
    | TurnDown Int
    | CheckBoard Time
    | NewColors (Array String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TurnUp index ->
            ( { model
                | tiles =
                    up index model.tiles
              }
            , Cmd.none
            )

        TurnDown index ->
            ( { model
                | tiles =
                    down index model.tiles
              }
            , Cmd.none
            )

        CheckBoard _ ->
            ( { model | tiles = checkBoard model.tiles }, Cmd.none )

        NewColors colorsArray ->
            ( { model | tiles = setColors model.tiles colorsArray }, Cmd.none )



-- set tiles colors once at init time when random cmd executed


setColors : List Tile -> Array String -> List Tile
setColors tiles colorsArray =
    let
        colorsList =
            Array.toList colorsArray
    in
        tiles
            |> List.map2 setTileColor colorsList


setTileColor : String -> Tile -> Tile
setTileColor color tile =
    { tile | color = color }



-- check board


checkBoard : List Tile -> List Tile
checkBoard tiles =
    let
        faceUpList =
            getUpList tiles
    in
        if isTwoUp faceUpList && isSameColor faceUpList then
            done faceUpList tiles
        else
            tiles


getUpList : List Tile -> List Tile
getUpList tiles =
    tiles
        |> List.filter isUp


isTwoUp : List Tile -> Bool
isTwoUp faceUpList =
    List.length faceUpList == 2


isSameColor : List Tile -> Bool
isSameColor faceUpList =
    case faceUpList of
        [ x, y ] ->
            if x.color == y.color then
                True
            else
                False

        _ ->
            False



-- change tile state to FaceUp, FaceDown or Done


down : Int -> List Tile -> List Tile
down index tiles =
    updateAt index stateDown tiles
        |> Maybe.withDefault []


up : Int -> List Tile -> List Tile
up index tiles =
    let
        faceUpList =
            getUpList tiles
    in
        if not (isTwoUp faceUpList) then
            updateAt index stateUp tiles
                |> Maybe.withDefault []
        else
            resetDown tiles
                |> up index


done : List Tile -> List Tile -> List Tile
done faceUpList tiles =
    let
        ( fstIndex, sndIndex ) =
            case faceUpList of
                [ x, y ] ->
                    ( x.index, y.index )

                _ ->
                    -- should not happen
                    ( -1, -1 )
    in
        tiles
            |> updateAt fstIndex stateDone
            |> Maybe.withDefault []
            |> updateAt sndIndex stateDone
            |> Maybe.withDefault []


resetDown : List Tile -> List Tile
resetDown tiles =
    tiles
        |> List.map (\tile -> stateDownIfUp tile)



-- helpers


stateDone : Tile -> Tile
stateDone tile =
    { tile | state = Done }


stateUp : Tile -> Tile
stateUp tile =
    { tile | state = FaceUp }


stateDown : Tile -> Tile
stateDown tile =
    { tile | state = FaceDown }


stateDownIfUp : Tile -> Tile
stateDownIfUp tile =
    case tile.state of
        FaceUp ->
            stateDown tile

        _ ->
            tile


isUp : Tile -> Bool
isUp { state } =
    case state of
        FaceUp ->
            True

        _ ->
            False
