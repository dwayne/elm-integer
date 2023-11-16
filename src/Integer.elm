module Integer exposing
    ( Integer, maxSafeInt, minSafeInt
    , zero, one, two, three, four, five, six, seven, eight, nine, ten
    , negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive
    , negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen
    , fromInt, fromSafeInt
    , toInt
    )

{-| Compute with the integers.


# Representation

@docs Integer, maxSafeInt, minSafeInt


# Constants

@docs zero, one, two, three, four, five, six, seven, eight, nine, ten
@docs negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive
@docs negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen


# Constructors

@docs fromInt, fromSafeInt


# Conversion

@docs toInt

-}

import Natural as N exposing (Natural)



-- REPRESENTATION


maxSafeInt : Int
maxSafeInt =
    N.maxSafeInt


minSafeInt : Int
minSafeInt =
    -maxSafeInt


type Integer
    = Zero
    | Positive Natural
    | Negative Natural



-- CONSTANTS


zero : Integer
zero =
    Zero


one : Integer
one =
    Positive N.one


two : Integer
two =
    Positive N.two


three : Integer
three =
    Positive N.three


four : Integer
four =
    Positive N.four


five : Integer
five =
    Positive N.five


six : Integer
six =
    Positive N.six


seven : Integer
seven =
    Positive N.seven


eight : Integer
eight =
    Positive N.eight


nine : Integer
nine =
    Positive N.nine


ten : Integer
ten =
    Positive N.ten


negativeOne : Integer
negativeOne =
    Negative N.one


negativeTwo : Integer
negativeTwo =
    Negative N.two


negativeThree : Integer
negativeThree =
    Negative N.three


negativeFour : Integer
negativeFour =
    Negative N.four


negativeFive : Integer
negativeFive =
    Negative N.five


negativeSix : Integer
negativeSix =
    Negative N.six


negativeSeven : Integer
negativeSeven =
    Negative N.seven


negativeEight : Integer
negativeEight =
    Negative N.eight


negativeNine : Integer
negativeNine =
    Negative N.nine


negativeTen : Integer
negativeTen =
    Negative N.ten



-- CONSTRUCTORS


fromInt : Int -> Maybe Integer
fromInt x =
    if x >= minSafeInt && x <= maxSafeInt then
        if x == 0 then
            Just Zero

        else if x > 0 then
            Maybe.map Positive <| N.fromInt x

        else
            Maybe.map Negative <| N.fromInt -x

    else
        Nothing


fromSafeInt : Int -> Integer
fromSafeInt =
    fromInt >> Maybe.withDefault zero



-- CONVERSION


toInt : Integer -> Int
toInt z =
    case z of
        Zero ->
            0

        Positive n ->
            N.toInt n

        Negative n ->
            -(N.toInt n)
