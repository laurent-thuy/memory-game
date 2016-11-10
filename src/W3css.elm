module W3css exposing (w3css)

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
