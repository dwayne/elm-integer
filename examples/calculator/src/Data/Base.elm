module Data.Base exposing (Base, fromInt, toInt, twenty)


type Base
    = Base Int


twenty : Base
twenty =
    Base 20


fromInt : Int -> Maybe Base
fromInt n =
    if n >= 2 && n <= 36 then
        Just <| Base n

    else
        Nothing


toInt : Base -> Int
toInt (Base b) =
    b
