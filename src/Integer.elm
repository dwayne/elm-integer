module Integer exposing
    ( Integer, maxSafeInt, minSafeInt
    , zero, one, two, three, four, five, six, seven, eight, nine, ten
    , negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive, negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen
    , fromInt, fromSafeInt, fromNatural, fromBinaryString, fromOctalString, fromDecimalString, fromHexString, fromString, fromSafeString, fromBaseBString
    , toInt, toNatural, toBinaryString, toOctalString, toDecimalString, toHexString, toString, toBaseBString
    )

{-| Compute with the integers.


# Representation

@docs Integer, maxSafeInt, minSafeInt


# Constants

@docs zero, one, two, three, four, five, six, seven, eight, nine, ten
@docs negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive, negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen


# Constructors

@docs fromInt, fromSafeInt, fromNatural, fromBinaryString, fromOctalString, fromDecimalString, fromHexString, fromString, fromSafeString, fromBaseBString


# Conversion

@docs toInt, toNatural, toBinaryString, toOctalString, toDecimalString, toHexString, toString, toBaseBString

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
    fromInt >> Maybe.withDefault Zero


fromNatural : Natural -> Integer
fromNatural n =
    if N.isZero n then
        Zero

    else
        Positive n


fromBinaryString : String -> Maybe Integer
fromBinaryString =
    fromBaseBString 2


fromOctalString : String -> Maybe Integer
fromOctalString =
    fromBaseBString 8


fromDecimalString : String -> Maybe Integer
fromDecimalString =
    fromBaseBString 10


fromHexString : String -> Maybe Integer
fromHexString =
    fromBaseBString 16


fromString : String -> Maybe Integer
fromString input =
    String.uncons input
        |> Maybe.andThen
            (\( c, restInput ) ->
                if c == '-' then
                    N.fromString restInput
                        |> Maybe.map
                            (\n ->
                                if N.isZero n then
                                    Zero

                                else
                                    Negative n
                            )

                else
                    N.fromString input
                        |> Maybe.map
                            (\n ->
                                if N.isZero n then
                                    Zero

                                else
                                    Positive n
                            )
            )


fromSafeString : String -> Integer
fromSafeString =
    fromString >> Maybe.withDefault Zero


fromBaseBString : Int -> String -> Maybe Integer
fromBaseBString b input =
    --
    -- N.B. The input string must be of the format
    --
    --   input ::= -? baseBString"
    --
    -- For e.g. "123", "-123", "0", "-0", "-0b11", "-0xF".
    --
    String.uncons input
        |> Maybe.andThen
            (\( c, restInput ) ->
                if c == '-' then
                    N.fromBaseBString b restInput
                        |> Maybe.map
                            (\n ->
                                if N.isZero n then
                                    Zero

                                else
                                    Negative n
                            )

                else
                    N.fromBaseBString b input
                        |> Maybe.map
                            (\n ->
                                if N.isZero n then
                                    Zero

                                else
                                    Positive n
                            )
            )



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


toNatural : Integer -> Maybe Natural
toNatural z =
    --
    -- FIXME: I'm not too sure what to return in the negative case.
    --
    -- Should it be `toNatural : Integer -> Natural` instead?
    -- In that case, do I return N.zero or n in the negative case?
    --
    -- Is this function even needed or necessary?
    --
    case z of
        Zero ->
            Just N.zero

        Positive n ->
            Just n

        Negative _ ->
            Nothing


toBinaryString : Integer -> String
toBinaryString =
    toBaseBString 2 >> Maybe.withDefault ""


toOctalString : Integer -> String
toOctalString =
    toBaseBString 8 >> Maybe.withDefault ""


toDecimalString : Integer -> String
toDecimalString =
    toBaseBString 10 >> Maybe.withDefault ""


toHexString : Integer -> String
toHexString =
    toBaseBString 16 >> Maybe.withDefault ""


toString : Integer -> String
toString =
    toDecimalString


toBaseBString : Int -> Integer -> Maybe String
toBaseBString b z =
    case z of
        Zero ->
            Just "0"

        Positive n ->
            N.toBaseBString b n

        Negative n ->
            N.toBaseBString b n
                |> Maybe.map (String.cons '-')
