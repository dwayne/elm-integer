module Test.Integer exposing (suite)

import Expect
import Fuzz exposing (Fuzzer)
import Integer as Z exposing (Integer)
import Test exposing (Test, describe, fuzz, fuzz2, fuzz3, test)


suite : Test
suite =
    describe "Integer"
        [ intConversionSuite
        , constantsSuite
        , baseBStringConversionSuite
        , comparisonSuite
        , predicatesSuite
        , absSuite
        , negateSuite
        , additionSuite
        , subtractionSuite
        ]


intConversionSuite : Test
intConversionSuite =
    describe "fromInt / toInt conversion"
        [ fuzz Fuzz.int "small integers" <|
            \z ->
                Z.fromInt z
                    |> Maybe.map Z.toInt
                    |> Expect.equal (Just z)
        , test "maxSafeInt" <|
            \_ ->
                Z.fromInt Z.maxSafeInt
                    |> Maybe.map Z.toInt
                    |> Expect.equal (Just Z.maxSafeInt)
        , test "minSafeInt" <|
            \_ ->
                Z.fromInt Z.minSafeInt
                    |> Maybe.map Z.toInt
                    |> Expect.equal (Just Z.minSafeInt)
        ]


constantsSuite : Test
constantsSuite =
    describe "constants"
        [ test "0" <|
            \_ ->
                Z.zero
                    |> Expect.equal (Z.fromSafeInt 0)
        , test "1" <|
            \_ ->
                Z.one
                    |> Expect.equal (Z.fromSafeInt 1)
        , test "2" <|
            \_ ->
                Z.two
                    |> Expect.equal (Z.fromSafeInt 2)
        , test "3" <|
            \_ ->
                Z.three
                    |> Expect.equal (Z.fromSafeInt 3)
        , test "4" <|
            \_ ->
                Z.four
                    |> Expect.equal (Z.fromSafeInt 4)
        , test "5" <|
            \_ ->
                Z.five
                    |> Expect.equal (Z.fromSafeInt 5)
        , test "6" <|
            \_ ->
                Z.six
                    |> Expect.equal (Z.fromSafeInt 6)
        , test "7" <|
            \_ ->
                Z.seven
                    |> Expect.equal (Z.fromSafeInt 7)
        , test "8" <|
            \_ ->
                Z.eight
                    |> Expect.equal (Z.fromSafeInt 8)
        , test "9" <|
            \_ ->
                Z.nine
                    |> Expect.equal (Z.fromSafeInt 9)
        , test "10" <|
            \_ ->
                Z.ten
                    |> Expect.equal (Z.fromSafeInt 10)
        , test "-1" <|
            \_ ->
                Z.negativeOne
                    |> Expect.equal (Z.fromSafeInt -1)
        , test "-2" <|
            \_ ->
                Z.negativeTwo
                    |> Expect.equal (Z.fromSafeInt -2)
        , test "-3" <|
            \_ ->
                Z.negativeThree
                    |> Expect.equal (Z.fromSafeInt -3)
        , test "-4" <|
            \_ ->
                Z.negativeFour
                    |> Expect.equal (Z.fromSafeInt -4)
        , test "-5" <|
            \_ ->
                Z.negativeFive
                    |> Expect.equal (Z.fromSafeInt -5)
        , test "-6" <|
            \_ ->
                Z.negativeSix
                    |> Expect.equal (Z.fromSafeInt -6)
        , test "-7" <|
            \_ ->
                Z.negativeSeven
                    |> Expect.equal (Z.fromSafeInt -7)
        , test "-8" <|
            \_ ->
                Z.negativeEight
                    |> Expect.equal (Z.fromSafeInt -8)
        , test "-9" <|
            \_ ->
                Z.negativeNine
                    |> Expect.equal (Z.fromSafeInt -9)
        , test "-10" <|
            \_ ->
                Z.negativeTen
                    |> Expect.equal (Z.fromSafeInt -10)
        ]


baseBStringConversionSuite : Test
baseBStringConversionSuite =
    describe "fromBaseBString / toBaseBString conversion"
        [ fuzz baseBString "base b string" <|
            \( b, s ) ->
                Z.fromBaseBString b s
                    |> Maybe.andThen (Z.toBaseBString b)
                    |> Expect.equal (Just <| toCanonicalBaseBString s)
        ]


comparisonSuite : Test
comparisonSuite =
    describe "compare"
        [ fuzz2
            safeInt
            safeInt
            "compare a b == compare (Z.fromSafeInt a) (Z.fromSafeInt b)"
          <|
            \a b ->
                let
                    x =
                        Z.fromSafeInt a

                    y =
                        Z.fromSafeInt b
                in
                compare a b
                    |> Expect.equal (Z.compare x y)
        , fuzz integer "∀ z ∊ ℤ, z == z" <|
            \z ->
                Z.compare z z
                    |> Expect.equal EQ

        -- TODO:
        -- 1. Add z < z + 1
        -- 2. Add z - 1 < z
        ]


predicatesSuite : Test
predicatesSuite =
    describe "predicates"
        [ fuzz safeInt "isNegative / isNonNegative" <|
            \a ->
                let
                    z =
                        Z.fromSafeInt a
                in
                if a < 0 then
                    Z.isNegative z
                        |> Expect.equal True

                else
                    Z.isNonNegative z
                        |> Expect.equal True
        , fuzz safeInt "isZero / isNonZero" <|
            \a ->
                let
                    z =
                        Z.fromSafeInt a
                in
                if a == 0 then
                    Z.isZero z
                        |> Expect.equal True

                else
                    Z.isNonZero z
                        |> Expect.equal True
        , fuzz safeInt "isPositive / isNonPositive" <|
            \a ->
                let
                    z =
                        Z.fromSafeInt a
                in
                if a > 0 then
                    Z.isPositive z
                        |> Expect.equal True

                else
                    Z.isNonPositive z
                        |> Expect.equal True
        , fuzz safeInt "isEven / isOdd" <|
            \a ->
                let
                    z =
                        Z.fromSafeInt a
                in
                if isEven a then
                    Z.isEven z
                        |> Expect.equal True

                else
                    Z.isOdd z
                        |> Expect.equal True
        ]


absSuite : Test
absSuite =
    describe "abs"
        [ fuzz safeInt "|a| = Z.toInt |Z.fromSafeInt a|" <|
            \a ->
                let
                    z =
                        Z.fromSafeInt a
                in
                Z.abs z
                    |> Z.toInt
                    |> Expect.equal (abs a)
        , fuzz integer "∀ z ∊ ℤ, |z| >= 0" <|
            \z ->
                Z.abs z
                    |> Z.isNonNegative
                    |> Expect.equal True
        ]


negateSuite : Test
negateSuite =
    describe "negate"
        [ fuzz safeInt "-a == Z.toInt (Z.negate (Z.fromSafeInt a))" <|
            \a ->
                let
                    z =
                        Z.fromSafeInt a
                in
                Z.negate z
                    |> Z.toInt
                    |> Expect.equal -a
        , fuzz integer "∀ z ∊ ℤ, -(-z) == z" <|
            \z ->
                Z.negate (Z.negate z)
                    |> Expect.equal z
        ]


additionSuite : Test
additionSuite =
    describe "add"
        [ fuzz integer "∀ z ∊ ℤ, z + 0 = z" <|
            --
            -- Right identity.
            --
            \z ->
                Z.add z Z.zero
                    |> Expect.equal z
        , fuzz integer "∀ z ∊ ℤ, 0 + z = z" <|
            --
            -- Left identity.
            --
            \z ->
                Z.add Z.zero z
                    |> Expect.equal z
        , fuzz integer "∀ z ∊ ℤ, z + (-z) = 0" <|
            --
            -- Right inverse.
            --
            \z ->
                Z.add z (Z.negate z)
                    |> Expect.equal Z.zero
        , fuzz integer "∀ z ∊ ℤ, (-z) + z = 0" <|
            --
            -- Left inverse.
            --
            \z ->
                Z.add (Z.negate z) z
                    |> Expect.equal Z.zero
        , fuzz2 integer integer "∀ x, y ∊ ℤ, x + y = y + x" <|
            --
            -- Addition is commutative.
            --
            \x y ->
                Z.add x y
                    |> Expect.equal (Z.add y x)
        , fuzz3 integer integer integer "∀ x, y, z ∊ ℤ, (x + y) + z = x + (y + z)" <|
            --
            -- Addition is associative.
            --
            \x y z ->
                Z.add (Z.add x y) z
                    |> Expect.equal (Z.add x (Z.add y z))
        ]


subtractionSuite : Test
subtractionSuite =
    describe "sub"
        [ fuzz integer "∀ z ∊ ℤ, z - 0 = z" <|
            \z ->
                Z.sub z Z.zero
                    |> Expect.equal z
        , fuzz integer "∀ z ∊ ℤ, 0 - z = -z" <|
            \z ->
                Z.sub Z.zero z
                    |> Expect.equal (Z.negate z)
        , fuzz integer "∀ z ∊ ℤ, z - z = 0" <|
            \z ->
                Z.sub z z
                    |> Expect.equal Z.zero
        , fuzz2 integer integer "∀ x, y ∊ ℤ, x - y = -(y - x)" <|
            \x y ->
                Z.sub x y
                    |> Expect.equal (Z.negate <| Z.sub y x)
        ]



-- CUSTOM FUZZERS


safeInt : Fuzzer Int
safeInt =
    Fuzz.intRange Z.minSafeInt Z.maxSafeInt


integer : Fuzzer Integer
integer =
    baseBString
        |> Fuzz.andThen
            (\( b, s ) ->
                case Z.fromBaseBString b s of
                    Just z ->
                        Fuzz.constant z

                    Nothing ->
                        --
                        -- This should NEVER happen if both baseBString and
                        -- Z.fromBaseBString are written correctly.
                        --
                        Fuzz.invalid <| "integer: an unexpected error"
            )


baseBString : Fuzzer ( Int, String )
baseBString =
    --
    -- Generate random signed base b (2 <= b <= 36) strings
    -- of at least 1 character and at most 100 characters.
    --
    sign
        |> Fuzz.andThen
            (\s ->
                Fuzz.intRange 2 36
                    |> Fuzz.andThen
                        (\b ->
                            Fuzz.listOfLengthBetween 1 100 (baseBChar b)
                                |> Fuzz.map
                                    (\l ->
                                        ( b, s ++ String.fromList l )
                                    )
                        )
            )


sign : Fuzzer String
sign =
    Fuzz.oneOfValues
        [ "" -- +ve
        , "-" -- -ve
        ]


baseBChar : Int -> Fuzzer Char
baseBChar b =
    if 2 <= b && b <= 36 then
        Fuzz.uniformInt (b - 1)
            |> Fuzz.map
                (\offset ->
                    Char.fromCode <|
                        if offset < 10 then
                            0x30 + offset

                        else
                            (if modBy 2 offset == 0 then
                                0x61

                             else
                                0x41
                            )
                                + offset
                                - 10
                )

    else
        Fuzz.invalid "baseBChar: the base must be between 2 and 36 inclusive"



-- HELPERS


toCanonicalBaseBString : String -> String
toCanonicalBaseBString input =
    case String.uncons input of
        Just ( c, restInput ) ->
            if c == '-' then
                let
                    magnitude =
                        restInput
                            |> removeLeadingZeros
                            |> String.toUpper
                in
                if magnitude == "0" then
                    magnitude

                else
                    String.cons '-' magnitude

            else
                input
                    |> removeLeadingZeros
                    |> String.toUpper

        Nothing ->
            input


removeLeadingZeros : String -> String
removeLeadingZeros s =
    case String.uncons s of
        Just ( _, "" ) ->
            s

        Just ( '0', t ) ->
            removeLeadingZeros t

        _ ->
            s


isEven : Int -> Bool
isEven =
    modBy 2 >> (==) 0
