module Style.Colors exposing (colorsGenerator)

import Array exposing (Array)
import Random.Array exposing (shuffle)
import Random


w3Colors : List String
w3Colors =
    [ "w3-pink", "w3-amber", "w3-lime", "w3-teal", "w3-light-blue", "w3-deep-orange", "w3-deep-purple", "w3-purple" ]


colors : List String
colors =
    List.append w3Colors w3Colors


colorsArray : Array String
colorsArray =
    Array.fromList colors


colorsGenerator : Random.Generator (Array String)
colorsGenerator =
    shuffle colorsArray
