module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.App as App
import Html.Attributes exposing (..)
import W3css exposing (w3css)
import Meta exposing (meta)
import List.Extra exposing (updateAt, groupsOf)
import VirtualDom


-- colors
-- TODO    randomize colors order


colorsList : List String
colorsList =
    [ "w3-pink", "w3-amber", "w3-lime", "w3-teal", "w3-light-blue", "w3-deep-orange", "w3-deep-purple", "w3-purple" ]
        |> List.append [ "w3-pink", "w3-amber", "w3-lime", "w3-teal", "w3-light-blue", "w3-deep-orange", "w3-deep-purple", "w3-purple" ]



-- model


type alias Tile =
    { color : String, faceUp : Bool, index : Int }


type alias Model =
    { tiles : List (Maybe Tile) }


init : ( Model, Cmd Msg )
init =
    ( { tiles = createTiles }
    , Cmd.none
    )


createTiles : List (Maybe Tile)
createTiles =
    { color = "", faceUp = False, index = 0 }
        |> List.repeat 16
        |> List.indexedMap
            (\index tile ->
                { tile | index = index }
            )
        |> List.map2 (\color tile -> { tile | color = color }) colorsList
        |> List.map (\tile -> Just tile)



-- view


view : Model -> Html Msg
view model =
    --    text (toString model)
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
            , div [] (displayAllTiles model.tiles)
            ]
        ]


displayAllTiles : List (Maybe Tile) -> List (Html Msg)
displayAllTiles maybeTiles =
    groupsOf 4 maybeTiles
        |> List.map (\maybeTilesRow -> displayOneRow maybeTilesRow)


displayOneRow : List (Maybe Tile) -> Html Msg
displayOneRow maybeTilesRow =
    List.map displayOneTile maybeTilesRow
        |> div []


tileStyle : List ( String, String )
tileStyle =
    [ ( "height", "80px" )
    , ( "width", "80px" )
    , ( "border-radius", "5px" )
    , ( "margin", "2px" )
    , ( "display", "inline-block" )
    ]


displayOneTile : Maybe Tile -> Html Msg
displayOneTile maybeTile =
    case maybeTile of
        Just tile ->
            div
                [ class
                    (if tile.faceUp then
                        tile.color
                     else
                        "w3-light-grey"
                    )
                , style tileStyle
                , onClick (ToggleTile tile.index)
                ]
                []

        Nothing ->
            div
                [ style tileStyle ]
                [ text "nothing" ]



-- update


type Msg
    = ToggleTile Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleTile index ->
            ( { model
                | tiles =
                    updateTile index model.tiles
              }
            , Cmd.none
            )


updateTile : Int -> List (Maybe Tile) -> List (Maybe Tile)
updateTile index maybeTiles =
    updateAt index (\maybeTile -> toggleTile maybeTile) maybeTiles
        |> Maybe.withDefault []


toggleTile : Maybe Tile -> Maybe Tile
toggleTile maybeTile =
    Maybe.map
        (\maybeTile ->
            { maybeTile | faceUp = (not maybeTile.faceUp) }
        )
        maybeTile



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- main


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
