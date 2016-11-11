module Update exposing (update, Msg(..))

import Model exposing (Model)
import Time exposing (Time)
import Tile exposing (Tile, TileState(..), dummyTile)
import Dict exposing (Dict)
import List.Extra exposing (updateAt, getAt)


type Msg
    = TurnUp Int
    | TurnDown Int
    | CheckBoard Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TurnUp index ->
            ( { model
                | tiles =
                    faceUp index model.tiles
              }
            , Cmd.none
            )

        TurnDown index ->
            ( { model
                | tiles =
                    faceDown index model.tiles
              }
            , Cmd.none
            )

        CheckBoard _ ->
            ( { model | tiles = checkBoard model.tiles }, Cmd.none )


checkBoard : List Tile -> List Tile
checkBoard tiles =
    let
        tileDict =
            faceUpTiles tiles
    in
        if isTwoFaceUp tileDict && isSameColor tileDict then
            markAsDone tileDict tiles
        else
            tiles


isSameColor : Dict String Tile -> Bool
isSameColor tileDict =
    let
        fstColor =
            Dict.get "fst" tileDict
                |> Maybe.withDefault dummyTile
                |> .color

        sndColor =
            Dict.get "snd" tileDict
                |> Maybe.withDefault dummyTile
                |> .color
    in
        fstColor == sndColor


isTwoFaceUp : Dict String Tile -> Bool
isTwoFaceUp dict =
    Dict.size dict == 2


faceUpTiles : List Tile -> Dict String Tile
faceUpTiles tiles =
    tiles
        |> List.filter isFaceUp
        |> faceUpTilesToDict


faceUpTilesToDict : List Tile -> Dict String Tile
faceUpTilesToDict tiles =
    let
        dict =
            Dict.empty
    in
        case tiles of
            x :: y :: [] ->
                Dict.insert "fst" x dict
                    |> Dict.insert "snd" y

            _ ->
                dict


isFaceUp : Tile -> Bool
isFaceUp { state } =
    case state of
        FaceUp ->
            True

        _ ->
            False


faceDownAll : List Tile -> List Tile
faceDownAll tiles =
    tiles
        |> List.map
            (\t ->
                if isFaceUp t then
                    tileToFaceDown t
                else
                    t
            )


markAsDone : Dict String Tile -> List Tile -> List Tile
markAsDone tileDict tiles =
    let
        fstIndex =
            Dict.get "fst" tileDict
                |> Maybe.withDefault dummyTile
                |> .index

        sndIndex =
            Dict.get "snd" tileDict
                |> Maybe.withDefault dummyTile
                |> .index
    in
        tiles
            |> updateAt fstIndex tileToDone
            |> Maybe.withDefault []
            |> updateAt sndIndex tileToDone
            |> Maybe.withDefault []


tileToDone : Tile -> Tile
tileToDone tile =
    { tile | state = Done }


tileToFaceUp : Tile -> Tile
tileToFaceUp tile =
    { tile | state = FaceUp }


tileToFaceDown : Tile -> Tile
tileToFaceDown tile =
    { tile | state = FaceDown }


faceDown : Int -> List Tile -> List Tile
faceDown index tiles =
    updateAt index tileToFaceDown tiles
        |> Maybe.withDefault []


faceUp : Int -> List Tile -> List Tile
faceUp index tiles =
    if not (Dict.size (faceUpTiles tiles) == 2) then
        updateAt index tileToFaceUp tiles
            |> Maybe.withDefault []
    else
        faceDownAll tiles
            |> faceUp index
