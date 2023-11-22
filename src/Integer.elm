module Integer exposing
    ( Integer
    , zero, one, two, three, four, five, six, seven, eight, nine, ten
    , negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive, negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen
    , maxSafeInt, minSafeInt
    , fromInt, fromSafeInt, fromNatural, fromBinaryString, fromOctalString, fromDecimalString, fromHexString, fromString, fromSafeString, fromBaseBString
    , compare, isLessThan, isLessThanOrEqual, isGreaterThan, isGreaterThanOrEqual, max, min
    , isNegative, isNonNegative, isZero, isNonZero, isPositive, isNonPositive, isEven, isOdd
    , abs, negate, add, sub, mul, divModBy, divBy, modBy, exp
    , toInt, toNatural, toBinaryString, toOctalString, toDecimalString, toHexString, toString, toBaseBString
    )

{-| Compute with the [integers](https://en.wikipedia.org/wiki/Integer), ℤ = { ..., -2, -1, 0, 1, 2, ... }.


# Representation

@docs Integer


# Constants

The integers from `-10` to `10` inclusive are named.

@docs zero, one, two, three, four, five, six, seven, eight, nine, ten
@docs negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive, negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen


# Limits

Let `n : Int`. If `minSafeInt <= n && n <= maxSafeInt` then `n` is called a **safe `Int`**.

@docs maxSafeInt, minSafeInt


# Constructors

@docs fromInt, fromSafeInt, fromNatural, fromBinaryString, fromOctalString, fromDecimalString, fromHexString, fromString, fromSafeString, fromBaseBString


# Comparison

To test for equality between two integers you can use `==` and `/=`.

    add negativeFive two == negativeThree

    mul negativeThree negativeThree /= negativeNine

For all other comparisons you will have to use the functions below.

@docs compare, isLessThan, isLessThanOrEqual, isGreaterThan, isGreaterThanOrEqual, max, min


# Predicates

@docs isNegative, isNonNegative, isZero, isNonZero, isPositive, isNonPositive, isEven, isOdd


# Arithmetic

@docs abs, negate, add, sub, mul, divModBy, divBy, modBy, exp


# Conversion

@docs toInt, toNatural, toBinaryString, toOctalString, toDecimalString, toHexString, toString, toBaseBString

-}

import Natural as N exposing (Natural)



-- REPRESENTATION


{-| A representation of the integers.

If you must know, it uses a **sign-magnitude** representation.

**N.B.** _The size of the numbers you can compute with is only limited by the available memory._

-}
type
    Integer
    --
    -- There is only one representation of 0. `Positive N.zero` and `Negative N.zero` are
    -- illegal representations that are NEVER produced by any of the functions exported by
    -- this library.
    --
    -- 0
    = Zero
      -- 1, 2, 3, 4, 5, ...
    | Positive Natural
      -- -1, -2, -3, -4, -5, ...
    | Negative Natural



-- CONSTANTS


{-| The integer [`0`](https://en.wikipedia.org/wiki/0).

To be more precise, it is a representation of the integer `0`. However, I will not
have any cause to make that distinction. A similar remark can be made about the
other constants.

-}
zero : Integer
zero =
    Zero


{-| The integer [`1`](https://en.wikipedia.org/wiki/1).
-}
one : Integer
one =
    Positive N.one


{-| The integer [`2`](https://en.wikipedia.org/wiki/2).
-}
two : Integer
two =
    Positive N.two


{-| The integer [`3`](https://en.wikipedia.org/wiki/3).
-}
three : Integer
three =
    Positive N.three


{-| The integer [`4`](https://en.wikipedia.org/wiki/4).
-}
four : Integer
four =
    Positive N.four


{-| The integer [`5`](https://en.wikipedia.org/wiki/5).
-}
five : Integer
five =
    Positive N.five


{-| The integer [`6`](https://en.wikipedia.org/wiki/6).
-}
six : Integer
six =
    Positive N.six


{-| The integer [`7`](https://en.wikipedia.org/wiki/7).
-}
seven : Integer
seven =
    Positive N.seven


{-| The integer [`8`](https://en.wikipedia.org/wiki/8).
-}
eight : Integer
eight =
    Positive N.eight


{-| The integer [`9`](https://en.wikipedia.org/wiki/9).
-}
nine : Integer
nine =
    Positive N.nine


{-| The integer [`10`](https://en.wikipedia.org/wiki/10).
-}
ten : Integer
ten =
    Positive N.ten


{-| The integer [`-1`](https://en.wikipedia.org/wiki/-1).
-}
negativeOne : Integer
negativeOne =
    Negative N.one


{-| The integer `-2`.
-}
negativeTwo : Integer
negativeTwo =
    Negative N.two


{-| The integer `-3`.
-}
negativeThree : Integer
negativeThree =
    Negative N.three


{-| The integer `-4`.
-}
negativeFour : Integer
negativeFour =
    Negative N.four


{-| The integer `-5`.
-}
negativeFive : Integer
negativeFive =
    Negative N.five


{-| The integer `-6`.
-}
negativeSix : Integer
negativeSix =
    Negative N.six


{-| The integer `-7`.
-}
negativeSeven : Integer
negativeSeven =
    Negative N.seven


{-| The integer `-8`.
-}
negativeEight : Integer
negativeEight =
    Negative N.eight


{-| The integer `-9`.
-}
negativeNine : Integer
negativeNine =
    Negative N.nine


{-| The integer `-10`.
-}
negativeTen : Integer
negativeTen =
    Negative N.ten



-- LIMITS


{-| The largest `Int`, currently `2^53 - 1 = 9007199254740991`, which can be given as input to
[`fromInt`](#fromInt) and [`fromSafeInt`](#fromSafeInt) without causing problems.
-}
maxSafeInt : Int
maxSafeInt =
    N.maxSafeInt


{-| The smallest `Int`, currently `-2^53 + 1 = -9007199254740991`, which can be given as input to
[`fromInt`](#fromInt) and [`fromSafeInt`](#fromSafeInt) without causing problems.
-}
minSafeInt : Int
minSafeInt =
    -maxSafeInt



-- CONSTRUCTORS


{-| Create the integer that represents the given `Int`.

    fromInt 0 == Just zero

    fromInt 1 == Just one

    fromInt -1 == Just negativeOne

    fromInt maxSafeInt == fromString "9007199254740991"

    fromInt minSafeInt == fromString "-9007199254740991"

Unless the given `Int` is less than [`minSafeInt`](#minSafeInt) or greater than [`maxSafeInt`](#maxSafeInt).

    fromInt (minSafeInt - 1) == Nothing

    fromInt (maxSafeInt + 1) == Nothing

-}
fromInt : Int -> Maybe Integer
fromInt x =
    if minSafeInt <= x && x <= maxSafeInt then
        if x == 0 then
            Just Zero

        else if x > 0 then
            Maybe.map Positive <| N.fromInt x

        else
            Maybe.map Negative <| N.fromInt -x

    else
        Nothing


{-| Use this function when you know the given `Int` is a [safe `Int`](#limits).

    fromSafeInt 0 == zero

    fromSafeInt 1 == one

    fromSafeInt -1 == negativeOne

    fromSafeInt maxSafeInt == fromSafeString "9007199254740991"

    fromSafeInt minSafeInt == fromSafeString "-9007199254740991"

If the given `Int` isn't safe then [`zero`](#zero) is returned.

    fromSafeInt (minSafeInt - 1) == zero

    fromSafeInt (maxSafeInt + 1) == zero

This function is useful for establishing **small constants** in a calculation. For e.g.
to [compute the first 100 digits of π using John Machin's formula](https://en.wikipedia.org/wiki/Machin-like_formula)
the integer 239 is needed.

    twoThirtyNine : Integer
    twoThirtyNine =
        fromSafeInt 239

-}
fromSafeInt : Int -> Integer
fromSafeInt =
    fromInt >> Maybe.withDefault Zero


{-| If you happen to have a natural number at hand then you can convert it to an integer using this function.

For all `n : Natural`:

  - `toNatural (fromNatural n) == n`,
  - `isNonNegative (fromNatural n) == True`.

-}
fromNatural : Natural -> Integer
fromNatural n =
    if N.isZero n then
        Zero

    else
        Positive n


{-| -}
fromBinaryString : String -> Maybe Integer
fromBinaryString =
    fromBaseBString 2


{-| -}
fromOctalString : String -> Maybe Integer
fromOctalString =
    fromBaseBString 8


{-| -}
fromDecimalString : String -> Maybe Integer
fromDecimalString =
    fromBaseBString 10


{-| -}
fromHexString : String -> Maybe Integer
fromHexString =
    fromBaseBString 16


{-| -}
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


{-| -}
fromSafeString : String -> Integer
fromSafeString =
    fromString >> Maybe.withDefault Zero


{-| -}
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


{-| -}
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


{-| -}
isLessThan : Integer -> Integer -> Bool
isLessThan y x =
    --
    -- Is x < y?
    --
    compare x y == LT


{-| -}
isLessThanOrEqual : Integer -> Integer -> Bool
isLessThanOrEqual y x =
    --
    -- Is x <= y?
    --
    -- x <= y iff not (x > y)
    --
    not (x |> isGreaterThan y)


{-| -}
isGreaterThan : Integer -> Integer -> Bool
isGreaterThan y x =
    --
    -- Is x > y?
    --
    compare x y == GT


{-| -}
isGreaterThanOrEqual : Integer -> Integer -> Bool
isGreaterThanOrEqual y x =
    --
    -- Is x >= y?
    --
    -- x >= y iff not (x < y)
    --
    not (x |> isLessThan y)


{-| -}
max : Integer -> Integer -> Integer
max x y =
    if x |> isLessThan y then
        y

    else
        x


{-| -}
min : Integer -> Integer -> Integer
min x y =
    if x |> isGreaterThan y then
        y

    else
        x



-- PREDICATES


{-| -}
isNegative : Integer -> Bool
isNegative =
    isLessThan zero


{-| -}
isNonNegative : Integer -> Bool
isNonNegative =
    not << isNegative


{-| -}
isZero : Integer -> Bool
isZero =
    (==) zero


{-| -}
isNonZero : Integer -> Bool
isNonZero =
    not << isZero


{-| -}
isPositive : Integer -> Bool
isPositive =
    isGreaterThan zero


{-| -}
isNonPositive : Integer -> Bool
isNonPositive =
    not << isPositive


{-| -}
isEven : Integer -> Bool
isEven z =
    case z of
        Zero ->
            True

        Positive n ->
            N.isEven n

        Negative n ->
            N.isEven n


{-| -}
isOdd : Integer -> Bool
isOdd =
    not << isEven



-- ARITHMETIC


{-| -}
abs : Integer -> Integer
abs z =
    case z of
        Negative n ->
            Positive n

        _ ->
            z


{-| -}
negate : Integer -> Integer
negate z =
    case z of
        Positive n ->
            Negative n

        Negative n ->
            Positive n

        _ ->
            z


{-| -}
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


{-| -}
sub : Integer -> Integer -> Integer
sub x y =
    --
    -- x - y = x + (-y)
    --
    add x <| negate y


{-| -}
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


{-| -}
divModBy : Integer -> Integer -> Maybe ( Integer, Natural )
divModBy divisor dividend =
    case ( divisor, dividend ) of
        ( Zero, _ ) ->
            --
            -- Division by 0 is undefined.
            --
            Nothing

        ( _, Zero ) ->
            --
            -- Anything divided by 0 is 0.
            --
            Just ( zero, N.zero )

        ( Positive b, Positive a ) ->
            --
            -- 10 = 2 * 5 + 0
            --
            -- 10 = 3 * 3 + 1
            --
            N.divModBy b a
                |> Maybe.map (Tuple.mapFirst fromNatural)

        ( Negative b, Positive a ) ->
            --
            -- 10 = -2 * -5 + 0
            --
            -- 10 = -3 * -3 + 1
            --
            N.divModBy b a
                |> Maybe.map (Tuple.mapFirst <| negate << fromNatural)

        ( Positive b, Negative a ) ->
            --
            -- -10 = 2 * -5 + 0
            --
            -- -10 = 3 * -4 + 2
            --
            N.divModBy b a
                |> Maybe.map
                    (\( q, r ) ->
                        if N.isZero r then
                            ( q
                                |> fromNatural
                                |> negate
                            , r
                            )

                        else
                            ( q
                                |> N.add N.one
                                |> fromNatural
                                |> negate
                            , N.sub b r
                            )
                    )

        ( Negative b, Negative a ) ->
            --
            -- -10 = -2 * 5 + 0
            --
            -- -10 = -3 * 4 + 2
            --
            N.divModBy b a
                |> Maybe.map
                    (\( q, r ) ->
                        if N.isZero r then
                            ( fromNatural q, r )

                        else
                            ( q
                                |> N.add N.one
                                |> fromNatural
                            , N.sub b r
                            )
                    )


{-| -}
divBy : Integer -> Integer -> Maybe Integer
divBy divisor dividend =
    divModBy divisor dividend
        |> Maybe.map Tuple.first


{-| -}
modBy : Integer -> Integer -> Maybe Natural
modBy divisor dividend =
    divModBy divisor dividend
        |> Maybe.map Tuple.second


{-| -}
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


{-| -}
toInt : Integer -> Int
toInt z =
    case z of
        Zero ->
            0

        Positive n ->
            N.toInt n

        Negative n ->
            -(N.toInt n)


{-| -}
toNatural : Integer -> Natural
toNatural z =
    --
    -- It returns the absolute value of z as a Natural.
    --
    case z of
        Zero ->
            N.zero

        Positive n ->
            n

        Negative n ->
            n


{-| -}
toBinaryString : Integer -> String
toBinaryString =
    toBaseBString 2 >> Maybe.withDefault ""


{-| -}
toOctalString : Integer -> String
toOctalString =
    toBaseBString 8 >> Maybe.withDefault ""


{-| -}
toDecimalString : Integer -> String
toDecimalString =
    toBaseBString 10 >> Maybe.withDefault ""


{-| -}
toHexString : Integer -> String
toHexString =
    toBaseBString 16 >> Maybe.withDefault ""


{-| -}
toString : Integer -> String
toString =
    toDecimalString


{-| -}
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
