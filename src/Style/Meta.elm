module Style.Meta exposing (meta)

import VirtualDom exposing (node)
import Html.Attributes exposing (attribute)


meta : VirtualDom.Node a
meta =
    let
        tag =
            "meta"

        attrs =
            [ attribute "name" "viewport"
            , attribute "content" "width=device-width, initial-scale=1"
            ]
    in
        node tag attrs []
