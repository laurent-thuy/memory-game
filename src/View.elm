module View exposing (view)

import Html exposing (Html, div, br, h1, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)
import Style.W3css exposing (w3css, w3Colors)
import Style.Meta exposing (meta)
import Model exposing (Model)
import Update exposing (Msg(..))
import Tile exposing (Tile, TileState(..))
import List.Extra exposing (groupsOf)


view : Model -> Html Msg
view model =
    div
        []
        [ meta
        , w3css
        , br [] []
        , br [] []
        , br [] []
        , div [ class "w3-content" ]
            [ h1 [] [ text "Memory Game" ]
            , br [] []
            , br [] []
            , div [] (tilesToDivs model.tiles)
            ]
        ]


tileStyle : List ( String, String )
tileStyle =
    [ ( "height", "80px" )
    , ( "width", "80px" )
    , ( "border-radius", "5px" )
    , ( "margin", "5px" )
    , ( "display", "inline-block" )
    ]


tilesToDivs : List Tile -> List (Html Msg)
tilesToDivs tiles =
    groupsOf 4 tiles
        |> List.map (\row -> tilesRowToDiv row)


tilesRowToDiv : List Tile -> Html Msg
tilesRowToDiv row =
    List.map tileToDiv row
        |> div []


tileToDiv : Tile -> Html Msg
tileToDiv tile =
    case tile.state of
        FaceUp ->
            div
                [ class tile.color
                , style (List.append tileStyle [ ( "cursor", "pointer" ) ])
                , onClick (TurnDown tile.index)
                ]
                []

        FaceDown ->
            div
                [ class "w3-light-grey"
                , style (List.append tileStyle [ ( "cursor", "pointer" ) ])
                , onClick (TurnUp tile.index)
                ]
                []

        Done ->
            div
                [ class tile.color
                , style (List.append tileStyle [ ( "opacity", "0.05" ) ])
                ]
                []
