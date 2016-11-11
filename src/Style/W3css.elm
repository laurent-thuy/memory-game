module Style.W3css exposing (w3css, w3Colors)

import VirtualDom exposing (node)
import Html.Attributes exposing (attribute)


w3css : VirtualDom.Node a
w3css =
    let
        tag =
            "link"

        attrs =
            [ attribute "Rel" "stylesheet"
            , attribute "href" "http://www.w3schools.com/lib/w3.css"
            ]
    in
        node tag attrs []


w3Colors : List String
w3Colors =
    [ "w3-pink", "w3-amber", "w3-lime", "w3-teal", "w3-light-blue", "w3-deep-orange", "w3-deep-purple", "w3-purple" ]
        |> List.append [ "w3-pink", "w3-amber", "w3-lime", "w3-teal", "w3-light-blue", "w3-deep-orange", "w3-deep-purple", "w3-purple" ]
