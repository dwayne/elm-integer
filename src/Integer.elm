module Integer exposing
    ( Integer
    , zero, one, two, three, four, five, six, seven, eight, nine, ten
    , negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive, negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen
    , maxSafeInt, minSafeInt
    , fromSafeInt, fromInt, fromNatural, fromSafeString, fromString, fromBinaryString, fromOctalString, fromDecimalString, fromHexString, fromBaseBString
    , compare, isLessThan, isLessThanOrEqual, isGreaterThan, isGreaterThanOrEqual, max, min
    , isNegative, isNonNegative, isZero, isNonZero, isPositive, isNonPositive, isEven, isOdd
    , abs, negate, add, sub, mul, divModBy, divBy, modBy, quotRemBy, quotBy, remBy, exp
    , toInt, toNatural, toString, toBinaryString, toOctalString, toDecimalString, toHexString, toBaseBString
    )

{-| Compute with the [integers](https://en.wikipedia.org/wiki/Integer), ℤ = { ..., -2, -1, 0, 1, 2, ... }.


# Representation

@docs Integer


# Constants

The integers from [`-10`](#negativeTen) to [`10`](#ten) inclusive are named.

@docs zero, one, two, three, four, five, six, seven, eight, nine, ten
@docs negativeOne, negativeTwo, negativeThree, negativeFour, negativeFive, negativeSix, negativeSeven, negativeEight, negativeNine, negativeTen


# Limits

Let `n : Int`. If `minSafeInt <= n <= maxSafeInt` then `n` is called a **safe `Int`**.

@docs maxSafeInt, minSafeInt


# Constructors

@docs fromSafeInt, fromInt, fromNatural, fromSafeString, fromString, fromBinaryString, fromOctalString, fromDecimalString, fromHexString, fromBaseBString


# Comparison

To test for equality between two integers you can use `==` and `/=`.

    add negativeFive two == negativeThree

    mul negativeThree negativeThree /= negativeNine

For all other comparisons you will have to use the functions below.

@docs compare, isLessThan, isLessThanOrEqual, isGreaterThan, isGreaterThanOrEqual, max, min


# Predicates

@docs isNegative, isNonNegative, isZero, isNonZero, isPositive, isNonPositive, isEven, isOdd


# Arithmetic

@docs abs, negate, add, sub, mul, divModBy, divBy, modBy, quotRemBy, quotBy, remBy, exp


# Conversion

@docs toInt, toNatural, toString, toBinaryString, toOctalString, toDecimalString, toHexString, toBaseBString

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
[`fromSafeInt`](#fromSafeInt) and [`fromInt`](#fromInt) without causing problems.
-}
maxSafeInt : Int
maxSafeInt =
    N.maxSafeInt


{-| The smallest `Int`, currently `-2^53 + 1 = -9007199254740991`, which can be given as input to
[`fromSafeInt`](#fromSafeInt) and [`fromInt`](#fromInt) without causing problems.
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


{-| If you happen to have a [natural number](https://package.elm-lang.org/packages/dwayne/elm-natural/1.0.1/Natural)
at hand then you can convert it to an integer using this function.

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


{-| Create the integer represented by the given signed base-`b` string.

`b` must be between 2 and 36 inclusive and each character in the string must be a valid base-`b` digit.


### About base-`b` digits

A valid base-`b` digit is any digit `d` such that `0 <= d <= b - 1`.

For bases larger than 10, you can use case-insensitive letters from the [Latin alphabet](https://en.wikipedia.org/wiki/Latin_alphabet)
to represent the base-`b` digits that are 10 or larger. So,

```txt
A or a represents 10
B or b represents 11
C or c represents 12
...
Z or z represents 35
```

For e.g.

If `b = 16` then the valid base-16 digits are `[0-9a-fA-F]`.

If `b = 36` then the valid base-36 digits are `[0-9a-zA-Z]`.


### Syntax for `fromBaseBString` input

```txt
input ::= -? [digit]+
digit ::= [0-9a-zA-Z]
```

Valid strings when `b = 16`:

`"0"`, `"-0"`, `"123"`, `"-123"`, and `"-Ff"`.

Invalid strings when `b = 16`:

  - `"+2"`, because `'+'` is not part of the allowed syntax,
  - `"5g"`, because `'g'` is not a hexadecimal digit.


### Examples

    fromBaseBString 2 "1010" == Just ten

    fromBaseBString 2 "-1010" == Just negativeTen

    fromBaseBString 16 "aD" == fromInt 173

    fromBaseBString 36 "z" == fromInt 35

    fromBaseBString 2 "" == Nothing
    -- Because the string is empty.

    fromBaseBString 8 "-" == Nothing
    -- Because there must be at least one octal digit.

    fromBaseBString 10 "A" == Nothing
    -- Because 'A' is not a decimal digit.

-}
fromBaseBString : Int -> String -> Maybe Integer
fromBaseBString b input =
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


{-| Create the integer represented by the given signed binary string.

```txt
binary ::= -? [0-1]+
```

For e.g.

    fromBinaryString "0" == Just zero

    fromBinaryString "1010" == Just ten

    fromBinaryString "-1010" == Just negativeTen

    fromBinaryString "" == Nothing
    -- Because the string is empty.

    fromBinaryString "-" == Nothing
    -- Because there must be at least one binary digit.

    fromBinaryString "2" == Nothing
    -- Because '2' is not a binary digit.

-}
fromBinaryString : String -> Maybe Integer
fromBinaryString =
    fromBaseBString 2


{-| Create the integer represented by the given signed octal string.

```txt
octal ::= -? [0-7]+
```

For e.g.

    fromOctalString "0" == Just zero

    fromOctalString "12" == Just ten

    fromOctalString "-12" == Just negativeTen

    fromOctalString "" == Nothing
    -- Because the string is empty.

    fromOctalString "-" == Nothing
    -- Because there must be at least one octal digit.

    fromOctalString "8" == Nothing
    -- Because '8' is not an octal digit.

-}
fromOctalString : String -> Maybe Integer
fromOctalString =
    fromBaseBString 8


{-| Create the integer represented by the given signed decimal string.

```txt
decimal ::= -? [0-9]+
```

For e.g.

    fromDecimalString "0" == Just zero

    fromDecimalString "10" == Just ten

    fromDecimalString "-10" == Just negativeTen

    fromDecimalString "" == Nothing
    -- Because the string is empty.

    fromDecimalString "-" == Nothing
    -- Because there must be at least one decimal digit.

    fromDecimalString "A" == Nothing
    -- Because 'A' is not a decimal digit.

-}
fromDecimalString : String -> Maybe Integer
fromDecimalString =
    fromBaseBString 10


{-| Create the integer represented by the given signed hexadecimal string.

```txt
hex ::= -? [0-9a-fA-F]+
```

For e.g.

    fromHexString "0" == Just zero

    fromHexString "a" == Just ten

    fromHexString "-A" == Just negativeTen

    fromHexString "" == Nothing
    -- Because the string is empty.

    fromHexString "-" == Nothing
    -- Because there must be at least one hexadecimal digit.

    fromHexString "5g" == Nothing
    -- Because 'g' is not a hexadecimal digit.

-}
fromHexString : String -> Maybe Integer
fromHexString =
    fromBaseBString 16


{-| Create the integer represented by the given signed string.


### Syntax for `fromString` input

```txt
input    ::= signed
signed   ::= -? unsigned
unsigned ::= ('0b' | '0B') binary
           | ('0o' | '0O') octal
           | ('0x' | '0X') hex
           | decimal
binary   ::= [0-1]+
octal    ::= [0-7]+
hex      ::= [0-9a-fA-F]+
decimal  ::= [0-9]+
```

For e.g.

    fromString "0b10101101" == fromInt 173

    fromString "-0o255" == fromInt -173

    fromString "0XaD" == fromInt 173

    fromString "173" == fromInt 173

    fromString "b10101101" == Nothing
    -- Because the leading '0' is missing.

    fromString "-aD" == Nothing
    -- Because 'a' is not a decimal digit.

    fromString "0x" == Nothing
    -- Because there must be at least one hexadecimal digit.

-}
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


{-| It's best to use this function when you can guarantee that the string you're dealing with
is a valid input to the [`fromString`](#fromString) function.

If the input is invalid then [`zero`](#zero) is returned.

**N.B.** _Read the documentation of [`fromString`](#fromString) to learn what's considered to
be valid or invalid input to this function._

This function is useful for establishing **large constants** in a calculation.

    oneGoogol : Natural
    oneGoogol =
        -- 10 ^ 100
        fromSafeString "10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

Learn more about a [googol](https://en.wikipedia.org/wiki/Googol).


### What's considered a large constant?

Let `n : Int`, since `fromSafeInt n` can be used for `minSafeInt <= n <= maxSafeInt` then it makes sense
to consider any number smaller than [`minSafeInt`](#minSafeInt) or larger than [`maxSafeInt`](#maxSafeInt),
a large constant.

-}
fromSafeString : String -> Integer
fromSafeString =
    fromString >> Maybe.withDefault Zero



-- COMPARISON


{-| Compare any two integers.

    compare negativeFive negativeTwo == LT

    compare two two == EQ

    compare five negativeTen == GT

-}
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


{-| Determine if the second integer is less than the first.

    (negativeFive |> isLessThan negativeTwo) == True

    (two |> isLessThan two) == False

    (five |> isLessThan negativeTen) == False

-}
isLessThan : Integer -> Integer -> Bool
isLessThan y x =
    --
    -- Is x < y?
    --
    compare x y == LT


{-| Determine if the second integer is less than or equal to the first.

    (negativeFive |> isLessThanOrEqual negativeTwo) == True

    (two |> isLessThanOrEqual two) == True

    (five |> isLessThanOrEqual negativeTen) == False

-}
isLessThanOrEqual : Integer -> Integer -> Bool
isLessThanOrEqual y x =
    --
    -- Is x <= y?
    --
    -- x <= y iff not (x > y)
    --
    not (x |> isGreaterThan y)


{-| Determine if the second integer is greater than the first.

    (negativeFive |> isGreaterThan negativeTwo) == False

    (two |> isGreaterThan two) == False

    (five |> isGreaterThan negativeTen) == True

-}
isGreaterThan : Integer -> Integer -> Bool
isGreaterThan y x =
    --
    -- Is x > y?
    --
    compare x y == GT


{-| Determine if the second integer is greater than or equal to the first.

    (negativeFive |> isGreaterThanOrEqual negativeTwo) == False

    (two |> isGreaterThanOrEqual two) == True

    (five |> isGreaterThanOrEqual negativeTen) == True

-}
isGreaterThanOrEqual : Integer -> Integer -> Bool
isGreaterThanOrEqual y x =
    --
    -- Is x >= y?
    --
    -- x >= y iff not (x < y)
    --
    not (x |> isLessThan y)


{-| Find the larger of two integers.

    max five negativeTen == five

    max negativeFive negativeTwo == negativeTwo

-}
max : Integer -> Integer -> Integer
max x y =
    if x |> isLessThan y then
        y

    else
        x


{-| Find the smaller of two integers.

    min five negativeTen == negativeTen

    min negativeFive negativeTwo == negativeFive

-}
min : Integer -> Integer -> Integer
min x y =
    if x |> isGreaterThan y then
        y

    else
        x



-- PREDICATES


{-| Determine if the integer is negative (i.e. less than [`0`](#zero)).

    isNegative negativeTwo == True

    isNegative zero == False

    isNegative two == False

-}
isNegative : Integer -> Bool
isNegative =
    isLessThan zero


{-| Determine if the integer is non-negative (i.e. not negative, so greater than or equal to [`0`](#zero)).

    isNonNegative negativeTwo == False

    isNonNegative zero == True

    isNonNegative two == True

-}
isNonNegative : Integer -> Bool
isNonNegative =
    not << isNegative


{-| Determine if the integer is `0`.

    isZero zero == True

    isZero negativeSeven == False

    isZero six == False

-}
isZero : Integer -> Bool
isZero =
    (==) zero


{-| Determine if the integer is non-zero (i.e. not [`0`](#zero), so either positive or negative).

    isNonZero zero == False

    isNonZero negativeSeven == True

    isNonZero six == True

-}
isNonZero : Integer -> Bool
isNonZero =
    not << isZero


{-| Determine if the integer is positive (i.e. greater than [`0`](#zero)).

    isPositive five == True

    isPositive zero == False

    isPositive negativeEight == False

-}
isPositive : Integer -> Bool
isPositive =
    isGreaterThan zero


{-| Determine if the integer is non-positive (i.e. not positive, so less than or equal to [`0`](#zero)).

    isNonPositive five == False

    isNonPositive zero == True

    isNonPositive negativeEight == True

-}
isNonPositive : Integer -> Bool
isNonPositive =
    not << isPositive


{-| Determine if the integer is even (i.e. divisible by [`2`](#two)).

    isEven zero == True

    isEven negativeFour == True

    isEven eight == True

    isEven three == False

    isEven negativeNine == False

-}
isEven : Integer -> Bool
isEven z =
    case z of
        Zero ->
            True

        Positive n ->
            N.isEven n

        Negative n ->
            N.isEven n


{-| Determine if the integer is odd (i.e. not even, so not divisible by [`2`](#two)).

    isOdd zero == False

    isOdd negativeFour == False

    isOdd eight == False

    isOdd three == True

    isOdd negativeNine == True

-}
isOdd : Integer -> Bool
isOdd =
    not << isEven



-- ARITHMETIC


{-| Compute the [absolute value](https://en.wikipedia.org/wiki/Absolute_value) of the given integer.
If you want it as a [natural number](https://package.elm-lang.org/packages/dwayne/elm-natural/1.0.1/Natural),
use [`toNatural`](#toNatural).

You can think of the absolute value of an integer as its distance from [`0`](#zero).

    abs zero == zero

    abs five == five

    abs negativeFive = five
    -- Because 5 and -5 are the same distance away from 0.

-}
abs : Integer -> Integer
abs z =
    case z of
        Negative n ->
            Positive n

        _ ->
            z


{-| Compute the [additive inverse](https://en.wikipedia.org/wiki/Additive_inverse) of the given integer.

The additive inverse of an integer, `z`, is the integer that, when added to `z`, yields [`0`](#zero).

    negate five == negativeFive
    -- Because 5 + (-5) = 0.

    negate negativeFive == five
    -- Because -5 + 5 = 0.

    negate zero == zero
    -- Becase 0 + 0 = 0.

-}
negate : Integer -> Integer
negate z =
    case z of
        Positive n ->
            Negative n

        Negative n ->
            Positive n

        _ ->
            z


{-| Add two integers.
-}
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


{-| Subtract the second integer from the first.

    sub ten four == six
    -- 10 - 4 = 6

    sub four ten == negativeSix
    -- 4 - 10 = -6

-}
sub : Integer -> Integer -> Integer
sub x y =
    --
    -- x - y = x + (-y)
    --
    add x <| negate y


{-| Multiply two integers.
-}
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


{-| Find the quotient and remainder when the second integer (the **dividend**) is divided by the first (the **divisor**).

This operation performs [Euclidean division](https://en.wikipedia.org/wiki/Euclidean_division)
or **division with remainder**.

`divModBy d D` of two integers `D` and `d ≠ 0`, is defined as producing
two unique integers `q` (the **quotient**) and `r` (the **remainder**) such that

  - `d * q` is the greatest multiple of `d` less than or equal to `D`, and
  - `r = D - d * q` such that `0 <= r < |d|` (i.e. `r` is always non-negative).

For e.g.

    (ten |> divModBy two) == Just (five, zero)
    -- Because 2 * 5 is the greatest multiple of 2 less than or equal to 10,
    -- and 0 = 10 - (2 * 5).

    (ten |> divModBy negativeTwo) == Just (negativeFive, zero)
    -- Because -2 * -5 is the greatest multiple of -2 less than or equal to 10,
    -- and 0 = 10 - (-2 * -5).

    (negativeTen |> divModBy two) == Just (negativeFive, zero)
    -- Because 2 * -5 is the greatest multiple of 2 less than or equal to -10,
    -- and 0 = -10 - (2 * -5).

    (negativeTen |> divModBy negativeTwo) == Just (five, zero)
    -- Because -2 * 5 is the greatest multiple of -2 less than or equal to -10,
    -- and 0 = -10 - (-2 * 5).

    (ten |> divModBy three) == Just (three, one)
    -- Because 3 * 3 is the greatest multiple of 3 less than or equal to 10,
    -- and 1 = 10 - (3 * 3).

    (ten |> divModBy negativeThree) == Just (negativeThree, one)
    -- Because -3 * -3 is the greatest multiple of -3 less than or equal to 10,
    -- and 1 = 10 - (-3 * -3).

    (negativeTen |> divModBy three) == Just (negativeFour, two)
    -- Because 3 * -4 is the greatest multiple of 3 less than or equal to -10,
    -- and 2 = -10 - (3 * -4).

    (negativeTen |> divModBy negativeThree) == Just (four, two)
    -- Because -3 * 4 is the greatest multiple of -3 less than or equal to -10,
    -- and 2 = -10 - (-3 * 4).

Division by `0` is not allowed. So, for all `z : Integer`,

    (z |> divModBy zero) == Nothing

**N.B.** _This [Euclidean division article by Probabilistic World](https://www.probabilisticworld.com/euclidean-division-integer-division-with-remainders/)
is well written and can help you understand `divModBy` in greater depth._

-}
divModBy : Integer -> Integer -> Maybe ( Integer, Integer )
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
            Just ( zero, zero )

        ( Positive b, Positive a ) ->
            --
            -- 10 = 2 * 5 + 0
            --
            -- 10 = 3 * 3 + 1
            --
            N.divModBy b a
                |> Maybe.map (Tuple.mapBoth fromNatural fromNatural)

        ( Negative b, Positive a ) ->
            --
            -- 10 = -2 * -5 + 0
            --
            -- 10 = -3 * -3 + 1
            --
            N.divModBy b a
                |> Maybe.map (Tuple.mapBoth (negate << fromNatural) fromNatural)

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
                                |> fromNatural
                            )

                        else
                            ( q
                                |> N.add N.one
                                |> fromNatural
                                |> negate
                            , N.sub b r
                                |> fromNatural
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
                            ( fromNatural q, fromNatural r )

                        else
                            ( q
                                |> N.add N.one
                                |> fromNatural
                            , N.sub b r
                                |> fromNatural
                            )
                    )


{-| Find the quotient when the second integer is divided by the first.

**N.B.** _Please see [`divModBy`](#divModBy) to understand how the quotient is computed._

-}
divBy : Integer -> Integer -> Maybe Integer
divBy divisor dividend =
    divModBy divisor dividend
        |> Maybe.map Tuple.first


{-| Find the remainder when the second integer is divided by the first.

**N.B.** _Please see [`divModBy`](#divModBy) to understand how the remainder is computed._

-}
modBy : Integer -> Integer -> Maybe Integer
modBy divisor dividend =
    divModBy divisor dividend
        |> Maybe.map Tuple.second


{-| Find the quotient and remainder when the second integer (the **dividend**) is divided by the first (the **divisor**).

`quotRemBy d D` of two integers `D` and `d ≠ 0`, is defined as producing
two unique integers `q` (the **quotient**) and `r` (the **remainder**) such that

  - `|d * q|` is the greatest multiple of `d` less than or equal to `|D|`, and
  - `r = D - d * q` such that `0 <= |r| < |d|` (i.e. `r` can be negative).

For e.g.

    (ten |> quotRemBy two) == Just (five, zero)
    -- Because |2 * 5| is the greatest multiple of 2 less than or equal to |10|,
    -- and 0 = 10 - (2 * 5).

    (ten |> quotRemBy negativeTwo) == Just (negativeFive, zero)
    -- Because |-2 * -5| is the greatest multiple of -2 less than or equal to |10|,
    -- and 0 = 10 - (-2 * -5).

    (negativeTen |> quotRemBy two) == Just (negativeFive, zero)
    -- Because |2 * -5| is the greatest multiple of 2 less than or equal to |-10|,
    -- and 0 = -10 - (2 * -5).

    (negativeTen |> quotRemBy negativeTwo) == Just (five, zero)
    -- Because |-2 * 5| is the greatest multiple of -2 less than or equal to |-10|,
    -- and 0 = -10 - (-2 * 5).

    (ten |> quotRemBy three) == Just (three, one)
    -- Because |3 * 3| is the greatest multiple of 3 less than or equal to |10|,
    -- and 1 = 10 - (3 * 3).

    (ten |> quotRemBy negativeThree) == Just (negativeThree, one)
    -- Because |-3 * -3| is the greatest multiple of -3 less than or equal to |10|,
    -- and 1 = 10 - (-3 * -3).

    (negativeTen |> quotRemBy three) == Just (negativeThree, negativeOne)
    -- Because |3 * -3| is the greatest multiple of 3 less than or equal to |-10|,
    -- and -1 = -10 - (3 * -3).

    (negativeTen |> quotRemBy negativeThree) == Just (three, negativeOne)
    -- Because |-3 * 3| is the greatest multiple of -3 less than or equal to |-10|,
    -- and -1 = -10 - (-3 * 3).

Division by `0` is not allowed. So, for all `z : Integer`,

    (z |> quotRemBy zero) == Nothing

**N.B.** _This [Euclidean division article by Probabilistic World](https://www.probabilisticworld.com/euclidean-division-integer-division-with-remainders/)
is well written and can help you understand `quotRemBy` in greater depth._

-}
quotRemBy : Integer -> Integer -> Maybe ( Integer, Integer )
quotRemBy divisor dividend =
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
            Just ( zero, zero )

        ( Positive b, Positive a ) ->
            --
            -- 10 = 2 * 5 + 0
            --
            -- 10 = 3 * 3 + 1
            --
            N.divModBy b a
                |> Maybe.map (Tuple.mapBoth fromNatural fromNatural)

        ( Negative b, Positive a ) ->
            --
            -- 10 = -2 * -5 + 0
            --
            -- 10 = -3 * -3 + 1
            --
            N.divModBy b a
                |> Maybe.map (Tuple.mapBoth (negate << fromNatural) fromNatural)

        ( Positive b, Negative a ) ->
            --
            -- -10 = 2 * -5 + 0
            --
            -- -10 = 3 * -3 - 1
            --
            N.divModBy b a
                |> Maybe.map
                    (\( q, r ) ->
                        if N.isZero r then
                            ( q
                                |> fromNatural
                                |> negate
                            , r
                                |> fromNatural
                            )

                        else
                            ( q
                                |> fromNatural
                                |> negate
                            , r
                                |> fromNatural
                                |> negate
                            )
                    )

        ( Negative b, Negative a ) ->
            --
            -- -10 = -2 * 5 + 0
            --
            -- -10 = -3 * 3 - 1
            --
            N.divModBy b a
                |> Maybe.map
                    (\( q, r ) ->
                        if N.isZero r then
                            ( fromNatural q, fromNatural r )

                        else
                            ( q
                                |> fromNatural
                            , r
                                |> fromNatural
                                |> negate
                            )
                    )


{-| Find the quotient when the second integer is divided by the first.

**N.B.** _Please see [`quotRemBy`](#quotRemBy) to understand how the quotient is computed._

-}
quotBy : Integer -> Integer -> Maybe Integer
quotBy divisor dividend =
    quotRemBy divisor dividend
        |> Maybe.map Tuple.first


{-| Find the remainder when the second integer is divided by the first.

**N.B.** _Please see [`quotRemBy`](#quotRemBy) to understand how the remainder is computed._

-}
remBy : Integer -> Integer -> Maybe Integer
remBy divisor dividend =
    quotRemBy divisor dividend
        |> Maybe.map Tuple.second


{-| Integer exponentiation. Find the power of the integer (the **base**) to the natural number (the **exponent**).

Given,

    import Natural as N

Then,

    exp two N.three == eight

    exp negativeTwo N.three == negativeEight

For all `z : Integer`,

    exp z N.zero == one

In particular,

    exp zero N.zero == one

**N.B.** _You can read "[What is `0^0`?](https://maa.org/book/export/html/116806)" to learn more_.

For all `n : Natural`, where `n` is positive,

    exp zero n == zero

-}
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


{-| Convert any integer, `z`, to `sign z * (|z| mod (maxSafeInt + 1))`, where

```txt
sign z =
    -1 if z < 0
     0 if z = 0
     1 if z > 0
```

For e.g.

    toInt zero == 0

    toInt ten == 10

    toInt negativeTen == -10

    toInt (fromSafeInt maxSafeInt) == maxSafeInt

    toInt (fromSafeInt minSafeInt) == minSafeInt

    toInt (add (fromSafeInt maxSafeInt) one) == 0

    toInt (add (fromSafeInt maxSafeInt) ten) == 9

    toInt (sub (fromSafeInt minSafeInt) one) == 0

    toInt (sub (fromSafeInt minSafeInt) ten) == -9

-}
toInt : Integer -> Int
toInt z =
    case z of
        Zero ->
            0

        Positive n ->
            N.toInt n

        Negative n ->
            -(N.toInt n)


{-| Compute the [absolute value](https://en.wikipedia.org/wiki/Absolute_value) of the given integer as a
[natural number](https://package.elm-lang.org/packages/dwayne/elm-natural/1.0.1/Natural#Natural).
If you want an [integer](#Integer), use [`abs`](#abs).
-}
toNatural : Integer -> Natural
toNatural z =
    case z of
        Zero ->
            N.zero

        Positive n ->
            n

        Negative n ->
            n


{-| An alias for [`toDecimalString`](#toDecimalString).
-}
toString : Integer -> String
toString =
    toDecimalString


{-| Convert any integer to its signed binary (base-2) representation.

    toBinaryString zero == "0"

    toBinaryString one == "1"

    toBinaryString ten == "1010"

    toBinaryString negativeTen == "-1010"

    toBinaryString (fromSafeInt -1729) == "-11011000001"

    toBinaryString (add (fromSafeInt maxSafeInt) one) == "100000000000000000000000000000000000000000000000000000"

    toBinaryString (sub (fromSafeInt minSafeInt) one) == "-100000000000000000000000000000000000000000000000000000"

-}
toBinaryString : Integer -> String
toBinaryString =
    toBaseBString 2 >> Maybe.withDefault ""


{-| Convert any integer to its signed octal (base-8) representation.

    toOctalString zero == "0"

    toOctalString one == "1"

    toOctalString ten == "12"

    toOctalString negativeTen == "-12"

    toOctalString (fromSafeInt -1729) == "-3301"

    toOctalString (add (fromSafeInt maxSafeInt) one) == "400000000000000000"

    toOctalString (sub (fromSafeInt minSafeInt) one) == "-400000000000000000"

-}
toOctalString : Integer -> String
toOctalString =
    toBaseBString 8 >> Maybe.withDefault ""


{-| Convert any integer to its signed decimal (base-10) representation.

    toDecimalString zero == "0"

    toDecimalString one == "1"

    toDecimalString ten == "10"

    toDecimalString negativeTen == "-10"

    toDecimalString (fromSafeInt -1729) == "-1729"

    toDecimalString (add (fromSafeInt maxSafeInt) one) == "9007199254740992"

    toDecimalString (sub (fromSafeInt minSafeInt) one) == "-9007199254740992"

-}
toDecimalString : Integer -> String
toDecimalString =
    toBaseBString 10 >> Maybe.withDefault ""


{-| Convert any integer to its signed hexadecimal (base-16) representation.

    toHexString zero == "0"

    toHexString one == "1"

    toHexString ten == "A"

    toHexString negativeTen == "-A"

    toHexString (fromSafeInt -1729) == "-6C1"

    toHexString (add (fromSafeInt maxSafeInt) one) == "20000000000000"

    toHexString (sub (fromSafeInt minSafeInt) one) == "-20000000000000"

-}
toHexString : Integer -> String
toHexString =
    toBaseBString 16 >> Maybe.withDefault ""


{-| Convert any integer to its signed base-`b` representation.

`b` must be between 2 and 36 inclusive and each character in the resulting string
will be a valid base-`b` digit.

All [Latin letters](https://en.wikipedia.org/wiki/Latin_alphabet) in the base-`b`
representation will be uppercased.

For e.g.

    toBaseBString 2 (fromSafeInt 1729) == Just "11011000001"

    toBaseBString 8 (fromSafeInt -1729) == Just "-3301"

    toBaseBString 10 (fromSafeInt 1729) == Just "1729"

    toBaseBString 16 (fromSafeInt -1729) == Just "-6C1"

    toBaseBString 36 (fromSafeInt 1729) == Just "1C1"

For any `k : Int` where `k < 2` or `k > 36`, and any `z : Integer`,

    toBaseBString k z == Nothing

**N.B.** _Please refer to [`fromBaseBString`](#about-base-b-digits) to learn more about base-`b` digits._

-}
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
