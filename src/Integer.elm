module Integer exposing
    ( Integer, maxSafeInt, minSafeInt
    , zero, one, two, three, four, five, six, seven, eight, nine, ten
    , negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive, negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen
    , fromInt, fromSafeInt, fromNatural, fromBinaryString, fromOctalString, fromDecimalString, fromHexString, fromString, fromSafeString, fromBaseBString
    , compare, isLessThan, isLessThanOrEqual, isGreaterThan, isGreaterThanOrEqual, max, min
    , isNegative, isNonNegative, isZero, isNonZero, isPositive, isNonPositive, isEven, isOdd
    , abs, negate, add, sub, mul, exp
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


# Comparison

@docs compare, isLessThan, isLessThanOrEqual, isGreaterThan, isGreaterThanOrEqual, max, min


# Predicates

@docs isNegative, isNonNegative, isZero, isNonZero, isPositive, isNonPositive, isEven, isOdd


# Arithmetic

@docs abs, negate, add, sub, mul, exp


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



-- COMPARISON


compare : Integer -> Integer -> Order
compare x y =
    case x of
        Negative a ->
            case y of
                Negative b ->
                    N.compare b a

                _ ->
                    LT

        Zero ->
            case y of
                Negative _ ->
                    GT

                Zero ->
                    EQ

                _ ->
                    LT

        Positive a ->
            case y of
                Positive b ->
                    N.compare a b

                _ ->
                    GT


isLessThan : Integer -> Integer -> Bool
isLessThan y x =
    --
    -- Is x < y?
    --
    compare x y == LT


isLessThanOrEqual : Integer -> Integer -> Bool
isLessThanOrEqual y x =
    --
    -- Is x <= y?
    --
    -- x <= y iff not (x > y)
    --
    not (x |> isGreaterThan y)


isGreaterThan : Integer -> Integer -> Bool
isGreaterThan y x =
    --
    -- Is x > y?
    --
    compare x y == GT


isGreaterThanOrEqual : Integer -> Integer -> Bool
isGreaterThanOrEqual y x =
    --
    -- Is x >= y?
    --
    -- x >= y iff not (x < y)
    --
    not (x |> isLessThan y)


max : Integer -> Integer -> Integer
max x y =
    if x |> isLessThan y then
        y

    else
        x


min : Integer -> Integer -> Integer
min x y =
    if x |> isGreaterThan y then
        y

    else
        x



-- PREDICATES


isNegative : Integer -> Bool
isNegative =
    isLessThan zero


isNonNegative : Integer -> Bool
isNonNegative =
    not << isNegative


isZero : Integer -> Bool
isZero =
    (==) zero


isNonZero : Integer -> Bool
isNonZero =
    not << isZero


isPositive : Integer -> Bool
isPositive =
    isGreaterThan zero


isNonPositive : Integer -> Bool
isNonPositive =
    not << isPositive


isEven : Integer -> Bool
isEven z =
    case z of
        Zero ->
            True

        Positive n ->
            N.isEven n

        Negative n ->
            N.isEven n


isOdd : Integer -> Bool
isOdd =
    not << isEven



-- ARITHMETIC


abs : Integer -> Integer
abs z =
    case z of
        Negative n ->
            Positive n

        _ ->
            z


negate : Integer -> Integer
negate z =
    case z of
        Positive n ->
            Negative n

        Negative n ->
            Positive n

        _ ->
            z


add : Integer -> Integer -> Integer
add x y =
    case ( x, y ) of
        ( _, Zero ) ->
            --
            -- x + 0 = x
            --
            x

        ( Zero, _ ) ->
            --
            -- 0 + y = y
            --
            y

        ( Negative a, Negative b ) ->
            --
            -- -5 + -4 = -(5+4)
            --
            Negative <| N.add a b

        ( Negative a, Positive b ) ->
            --
            -- -5 + 4 = -(5 - 4) = -1
            --
            -- -5 + 5 = 0
            --
            -- -5 + 6 = 6 - 5 = 1
            --
            if a == b then
                Zero

            else if a |> N.isGreaterThan b then
                Negative <| N.sub a b

            else
                Positive <| N.sub b a

        ( Positive a, Negative b ) ->
            --
            -- 5 + (-4) = 5 - 4 = 1
            --
            -- 5 + (-5) = 0
            --
            -- 5 + (-6) = -(6 - 5) = -1
            --
            if a == b then
                Zero

            else if a |> N.isGreaterThan b then
                Positive <| N.sub a b

            else
                Negative <| N.sub b a

        ( Positive a, Positive b ) ->
            --
            -- 5 + 4 = 9
            --
            Positive <| N.add a b


sub : Integer -> Integer -> Integer
sub x y =
    --
    -- x - y = x + (-y)
    --
    add x <| negate y


mul : Integer -> Integer -> Integer
mul x y =
    case ( x, y ) of
        ( _, Zero ) ->
            --
            -- x * 0 = 0
            --
            Zero

        ( Zero, _ ) ->
            --
            -- 0 * y = 0
            --
            Zero

        ( Negative a, Negative b ) ->
            --
            -- -5 * -4 = 9
            --
            Positive <| N.mul a b

        ( Negative a, Positive b ) ->
            --
            -- -5 * 4 = -9
            --
            Negative <| N.mul a b

        ( Positive a, Negative b ) ->
            --
            -- 5 * -4 = -9
            --
            Negative <| N.mul a b

        ( Positive a, Positive b ) ->
            --
            -- 5 * 4 = 9
            --
            Positive <| N.mul a b


exp : Integer -> Natural -> Integer
exp x n =
    case x of
        Zero ->
            if N.isZero n then
                --
                -- 0^0 == 1
                --
                one

            else
                --
                -- 0^n == 0, ∀ n ∊ ℕ - {0}
                --
                zero

        Positive b ->
            Positive <| N.exp b n

        Negative b ->
            if N.isEven n then
                Positive <| N.exp b n

            else
                Negative <| N.exp b n



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
