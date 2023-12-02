module Data.Base exposing (Base, fromString, toInt, twenty)


type Base
    = Base Int


twenty : Base
twenty =
    Base 20


fromString : String -> Maybe Base
fromString =
    Maybe.andThen fromInt << String.toInt


fromInt : Int -> Maybe Base
fromInt n =
    if n >= 2 && n <= 36 then
        Just <| Base n

    else
        Nothing


toInt : Base -> Int
toInt (Base b) =
    b
