module Test.Integer exposing (suite)

import Expect
import Fuzz exposing (Fuzzer)
import Integer as Z exposing (Integer)
import Natural as N exposing (Natural)
import Test exposing (Test, describe, fuzz, fuzz2, fuzz3, test)


suite : Test
suite =
    describe "Integer"
        [ constantsSuite
        , fromIntSuite
        , fromSafeIntSuite
        , fromNaturalSuite
        , fromBaseBStringSuite
        , fromStringSuite
        , toIntSuite
        , toNaturalSuite
        , stringConversionSuite
        , comparisonSuite
        , maxMinSuite
        , predicatesSuite
        , absSuite
        , negateSuite
        , additionSuite
        , subtractionSuite
        , multiplicationSuite
        , euclideanDivisionSuite
        , exponentiationSuite
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


fromIntSuite : Test
fromIntSuite =
    describe "fromInt"
        [ test "0" <|
            \_ ->
                Z.fromInt 0
                    |> Expect.equal (Just Z.zero)
        , test "1" <|
            \_ ->
                Z.fromInt 1
                    |> Expect.equal (Just Z.one)
        , test "-1" <|
            \_ ->
                Z.fromInt -1
                    |> Expect.equal (Just Z.negativeOne)
        , test "maxSafeInt" <|
            \_ ->
                Z.fromInt Z.maxSafeInt
                    |> Expect.equal (Z.fromString "9007199254740991")
        , test "minSafeInt" <|
            \_ ->
                Z.fromInt Z.minSafeInt
                    |> Expect.equal (Z.fromString "-9007199254740991")
        , test "minSafeInt - 1" <|
            \_ ->
                Z.fromInt (Z.minSafeInt - 1)
                    |> Expect.equal Nothing
        , test "maxSafeInt + 1" <|
            \_ ->
                Z.fromInt (Z.maxSafeInt + 1)
                    |> Expect.equal Nothing
        , describe "for all safe integers s, toInt (fromInt s) == s"
            [ test "maxSafeInt" <|
                \_ ->
                    Z.fromInt Z.maxSafeInt
                        |> Maybe.map Z.toInt
                        |> Expect.equal (Just Z.maxSafeInt)
            , test "minSafeInt" <|
                \_ ->
                    Z.fromInt Z.minSafeInt
                        |> Maybe.map Z.toInt
                        |> Expect.equal (Just Z.minSafeInt)
            , fuzz safeInt "safe integers" <|
                \s ->
                    Z.fromInt s
                        |> Maybe.map Z.toInt
                        |> Expect.equal (Just s)
            ]
        ]


fromSafeIntSuite : Test
fromSafeIntSuite =
    describe "fromSafeInt"
        [ test "0" <|
            \_ ->
                Z.fromSafeInt 0
                    |> Expect.equal Z.zero
        , test "1" <|
            \_ ->
                Z.fromSafeInt 1
                    |> Expect.equal Z.one
        , test "-1" <|
            \_ ->
                Z.fromSafeInt -1
                    |> Expect.equal Z.negativeOne
        , test "maxSafeInt" <|
            \_ ->
                Z.fromSafeInt Z.maxSafeInt
                    |> Expect.equal (Z.fromSafeString "9007199254740991")
        , test "minSafeInt" <|
            \_ ->
                Z.fromSafeInt Z.minSafeInt
                    |> Expect.equal (Z.fromSafeString "-9007199254740991")
        , test "minSafeInt - 1" <|
            \_ ->
                Z.fromSafeInt (Z.minSafeInt - 1)
                    |> Expect.equal Z.zero
        , test "maxSafeInt + 1" <|
            \_ ->
                Z.fromSafeInt (Z.maxSafeInt + 1)
                    |> Expect.equal Z.zero
        ]


fromNaturalSuite : Test
fromNaturalSuite =
    describe "fromNatural"
        [ fuzz natural "∀ n ∊ ℕ, toNatural (fromNatural n) == n" <|
            \n ->
                Z.toNatural (Z.fromNatural n)
                    |> Expect.equal n
        , fuzz natural "∀ n ∊ ℕ, isNonNegative (fromNatural n) == True" <|
            \n ->
                Z.isNonNegative (Z.fromNatural n)
                    |> Expect.equal True
        ]


fromBaseBStringSuite : Test
fromBaseBStringSuite =
    describe "fromBaseBString"
        [ test "b=2 1010" <|
            \_ ->
                Z.fromBaseBString 2 "1010"
                    |> Expect.equal (Just Z.ten)
        , test "b=2 -1010" <|
            \_ ->
                Z.fromBaseBString 2 "-1010"
                    |> Expect.equal (Just Z.negativeTen)
        , test "b=16 aD" <|
            \_ ->
                Z.fromBaseBString 16 "aD"
                    |> Expect.equal (Z.fromInt 173)
        , test "b=36 z" <|
            \_ ->
                Z.fromBaseBString 36 "z"
                    |> Expect.equal (Z.fromInt 35)
        , test "b=2 empty" <|
            \_ ->
                Z.fromBaseBString 2 ""
                    |> Expect.equal Nothing
        , test "b=8 -" <|
            \_ ->
                Z.fromBaseBString 8 "-"
                    |> Expect.equal Nothing
        , test "b=10 A" <|
            \_ ->
                Z.fromBaseBString 10 "A"
                    |> Expect.equal Nothing
        , fuzz baseBString "base-b string" <|
            \( b, s ) ->
                Z.fromBaseBString b s
                    |> Maybe.andThen (Z.toBaseBString b)
                    |> Expect.equal (Just <| toCanonicalBaseBString s)
        ]


fromStringSuite : Test
fromStringSuite =
    describe "fromString"
        [ test "0b10101101" <|
            \_ ->
                Z.fromString "0b10101101"
                    |> Expect.equal (Z.fromInt 173)
        , test "-0o255" <|
            \_ ->
                Z.fromString "-0o255"
                    |> Expect.equal (Z.fromInt -173)
        , test "0XaD" <|
            \_ ->
                Z.fromString "0XaD"
                    |> Expect.equal (Z.fromInt 173)
        , test "173" <|
            \_ ->
                Z.fromString "173"
                    |> Expect.equal (Z.fromInt 173)
        , test "b10101101" <|
            \_ ->
                Z.fromString "b10101101"
                    |> Expect.equal Nothing
        , test "-aD" <|
            \_ ->
                Z.fromString "-aD"
                    |> Expect.equal Nothing
        , test "0x" <|
            \_ ->
                Z.fromString "0x"
                    |> Expect.equal Nothing
        ]


toIntSuite : Test
toIntSuite =
    describe "toInt"
        [ test "0" <|
            \_ ->
                Z.toInt Z.zero
                    |> Expect.equal 0
        , test "10" <|
            \_ ->
                Z.toInt Z.ten
                    |> Expect.equal 10
        , test "-10" <|
            \_ ->
                Z.toInt Z.negativeTen
                    |> Expect.equal -10
        , test "maxSafeInt" <|
            \_ ->
                Z.toInt (Z.fromSafeInt Z.maxSafeInt)
                    |> Expect.equal Z.maxSafeInt
        , test "minSafeInt" <|
            \_ ->
                Z.toInt (Z.fromSafeInt Z.minSafeInt)
                    |> Expect.equal Z.minSafeInt
        , test "maxSafeInt + 1" <|
            \_ ->
                Z.toInt (Z.add (Z.fromSafeInt Z.maxSafeInt) Z.one)
                    |> Expect.equal 0
        , test "maxSafeInt + 10" <|
            \_ ->
                Z.toInt (Z.add (Z.fromSafeInt Z.maxSafeInt) Z.ten)
                    |> Expect.equal 9
        , test "minSafeInt - 1" <|
            \_ ->
                Z.toInt (Z.sub (Z.fromSafeInt Z.minSafeInt) Z.one)
                    |> Expect.equal 0
        , test "minSafeInt - 10" <|
            \_ ->
                Z.toInt (Z.sub (Z.fromSafeInt Z.minSafeInt) Z.ten)
                    |> Expect.equal -9
        ]


toNaturalSuite : Test
toNaturalSuite =
    describe "toNatural"
        [ fuzz integer "∀ z ∊ ℤ, fromNatural (toNatural z) == abs z" <|
            \z ->
                Z.fromNatural (Z.toNatural z)
                    |> Expect.equal (Z.abs z)
        ]


stringConversionSuite : Test
stringConversionSuite =
    describe "binary, octal, decimal, and hexadecimal string conversions"
        [ fuzz integer "∀ z ∊ ℤ, fromBinaryString (toBinaryString z) == Just z" <|
            \z ->
                Z.fromBinaryString (Z.toBinaryString z)
                    |> Expect.equal (Just z)
        , fuzz integer "∀ z ∊ ℤ, fromOctalString (toOctalString z) == Just z" <|
            \z ->
                Z.fromOctalString (Z.toOctalString z)
                    |> Expect.equal (Just z)
        , fuzz integer "∀ z ∊ ℤ, fromDecimalString (toDecimalString z) == Just z" <|
            \z ->
                Z.fromDecimalString (Z.toDecimalString z)
                    |> Expect.equal (Just z)
        , fuzz integer "∀ z ∊ ℤ, fromHexString (toHexString z) == Just z" <|
            \z ->
                Z.fromHexString (Z.toHexString z)
                    |> Expect.equal (Just z)
        ]


comparisonSuite : Test
comparisonSuite =
    describe "compare"
        [ fuzz2 safeInt safeInt "for all safe integers a and b, compare a b == compare (Z.fromSafeInt a) (Z.fromSafeInt b)" <|
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
        , fuzz integer "∀ z ∊ ℤ, z < z + 1" <|
            --
            -- The integers increase indefinitely without wrapping around or hitting a larget integer.
            --
            \z ->
                (z |> Z.isLessThan (Z.add z Z.one))
                    |> Expect.equal True
        , fuzz integer "∀ z ∊ ℤ, z - 1 < z" <|
            --
            -- The integers decrease indefinitely without wrapping around or hitting a smallest integer.
            --
            \z ->
                (Z.sub z Z.one |> Z.isLessThan z)
                    |> Expect.equal True
        , test "-5 < -2" <|
            \_ ->
                (Z.negativeFive |> Z.isLessThan Z.negativeTwo)
                    |> Expect.equal True
        , test "-2 <= -2" <|
            \_ ->
                (Z.negativeTwo |> Z.isLessThanOrEqual Z.negativeTwo)
                    |> Expect.equal True
        , test "5 > -10" <|
            \_ ->
                (Z.five |> Z.isGreaterThan Z.negativeTen)
                    |> Expect.equal True
        , test "-10 >= -10" <|
            \_ ->
                (Z.negativeTen |> Z.isGreaterThanOrEqual Z.negativeTen)
                    |> Expect.equal True
        ]


maxMinSuite : Test
maxMinSuite =
    describe "max / min"
        [ fuzz2 integer integer "∀ x, y ∊ ℤ, if x < y then max x y == y else max x y == x" <|
            \x y ->
                if x |> Z.isLessThan y then
                    Z.max x y
                        |> Expect.equal y

                else
                    Z.max x y
                        |> Expect.equal x
        , fuzz2 integer integer "∀ x, y ∊ ℤ, if x > y then min x y == y else min x y == x" <|
            \x y ->
                if x |> Z.isGreaterThan y then
                    Z.min x y
                        |> Expect.equal y

                else
                    Z.min x y
                        |> Expect.equal x
        , test "max 5 -10 == 5" <|
            \_ ->
                Z.max Z.five Z.negativeTen
                    |> Expect.equal Z.five
        , test "max -5 -2 == -2" <|
            \_ ->
                Z.max Z.negativeFive Z.negativeTwo
                    |> Expect.equal Z.negativeTwo
        , test "min 5 -10 == -10" <|
            \_ ->
                Z.min Z.five Z.negativeTen
                    |> Expect.equal Z.negativeTen
        , test "min -5 -2 == -5" <|
            \_ ->
                Z.min Z.negativeFive Z.negativeTwo
                    |> Expect.equal Z.negativeFive
        ]


predicatesSuite : Test
predicatesSuite =
    describe "predicates"
        [ fuzz safeInt "isNegative / isNonNegative" <|
            \s ->
                let
                    z =
                        Z.fromSafeInt s
                in
                if s < 0 then
                    Z.isNegative z
                        |> Expect.equal True

                else
                    Z.isNonNegative z
                        |> Expect.equal True
        , fuzz safeInt "isZero / isNonZero" <|
            \s ->
                let
                    z =
                        Z.fromSafeInt s
                in
                if s == 0 then
                    Z.isZero z
                        |> Expect.equal True

                else
                    Z.isNonZero z
                        |> Expect.equal True
        , fuzz safeInt "isPositive / isNonPositive" <|
            \s ->
                let
                    z =
                        Z.fromSafeInt s
                in
                if s > 0 then
                    Z.isPositive z
                        |> Expect.equal True

                else
                    Z.isNonPositive z
                        |> Expect.equal True
        , fuzz safeInt "isEven / isOdd" <|
            \s ->
                let
                    z =
                        Z.fromSafeInt s
                in
                if isEven s then
                    Z.isEven z
                        |> Expect.equal True

                else
                    Z.isOdd z
                        |> Expect.equal True
        ]


absSuite : Test
absSuite =
    describe "abs"
        [ fuzz safeInt "for all safe integers s, |s| == Z.toInt |Z.fromSafeInt s|" <|
            \s ->
                abs s |> Expect.equal (Z.toInt <| Z.abs <| Z.fromSafeInt s)
        , fuzz integer "∀ z ∊ ℤ, |z| >= 0" <|
            \z ->
                Z.abs z
                    |> Z.isNonNegative
                    |> Expect.equal True
        ]


negateSuite : Test
negateSuite =
    describe "negate"
        [ fuzz safeInt "for all safe integers s, -s == Z.toInt (Z.negate (Z.fromSafeInt s))" <|
            \s ->
                -s |> Expect.equal (Z.toInt <| Z.negate <| Z.fromSafeInt s)
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


multiplicationSuite : Test
multiplicationSuite =
    describe "mul"
        [ fuzz integer "∀ z ∊ ℤ, z * 0 = 0" <|
            --
            -- Multiplication by 0 on the right.
            --
            \z ->
                Z.mul z Z.zero
                    |> Expect.equal Z.zero
        , fuzz integer "∀ z ∊ ℤ, 0 * z = 0" <|
            --
            -- Multiplication by 0 on the left.
            --
            \z ->
                Z.mul Z.zero z
                    |> Expect.equal Z.zero
        , fuzz integer "∀ z ∊ ℤ, z * 1 = z" <|
            --
            -- Right identity.
            --
            \z ->
                Z.mul z Z.one
                    |> Expect.equal z
        , fuzz integer "∀ z ∊ ℤ, 1 * z = z" <|
            --
            -- Left identity.
            --
            \z ->
                Z.mul Z.one z
                    |> Expect.equal z
        , fuzz2 integer integer "∀ x, y ∊ ℤ, x * y = y * x" <|
            --
            -- Multiplication is commutative.
            --
            \x y ->
                Z.mul x y
                    |> Expect.equal (Z.mul y x)
        , fuzz3 integer integer integer "∀ x, y, z ∊ ℤ, (x * y) * z = x * (y * z)" <|
            --
            -- Multiplication is associative.
            --
            \x y z ->
                Z.mul (Z.mul x y) z
                    |> Expect.equal (Z.mul x (Z.mul y z))
        , fuzz3 integer integer integer "∀ x, y, z ∊ ℤ, x * (y + z) = x * y + x * z = y * x + z * x = (y + z) * x" <|
            --
            -- Multiplication distributes over addition.
            --
            \x y z ->
                Z.mul x (Z.add y z)
                    |> Expect.equal (Z.add (Z.mul x y) (Z.mul x z))
        , fuzz integer "∀ z ∊ ℤ, -1 * z = -z" <|
            \z ->
                Z.mul Z.negativeOne z
                    |> Expect.equal (Z.negate z)
        , fuzz integer "∀ z ∊ ℤ, z * -1 = -z" <|
            \z ->
                Z.mul z Z.negativeOne
                    |> Expect.equal (Z.negate z)
        ]


euclideanDivisionSuite : Test
euclideanDivisionSuite =
    describe "divModBy"
        [ test "10 ÷ 2" <|
            \_ ->
                (Z.ten |> Z.divModBy Z.two)
                    |> Expect.equal (Just ( Z.five, Z.zero ))
        , test "10 ÷ (-2)" <|
            \_ ->
                (Z.ten |> Z.divModBy Z.negativeTwo)
                    |> Expect.equal (Just ( Z.negativeFive, Z.zero ))
        , test "(-10) ÷ 2" <|
            \_ ->
                (Z.negativeTen |> Z.divModBy Z.two)
                    |> Expect.equal (Just ( Z.negativeFive, Z.zero ))
        , test "(-10) ÷ (-2)" <|
            \_ ->
                (Z.negativeTen |> Z.divModBy Z.negativeTwo)
                    |> Expect.equal (Just ( Z.five, Z.zero ))
        , test "10 ÷ 3" <|
            \_ ->
                (Z.ten |> Z.divModBy Z.three)
                    |> Expect.equal (Just ( Z.three, Z.one ))
        , test "10 ÷ (-3)" <|
            \_ ->
                (Z.ten |> Z.divModBy Z.negativeThree)
                    |> Expect.equal (Just ( Z.negativeThree, Z.one ))
        , test "(-10) ÷ 3" <|
            \_ ->
                (Z.negativeTen |> Z.divModBy Z.three)
                    |> Expect.equal (Just ( Z.negativeFour, Z.two ))
        , test "(-10) ÷ (-3)" <|
            \_ ->
                (Z.negativeTen |> Z.divModBy Z.negativeThree)
                    |> Expect.equal (Just ( Z.four, Z.two ))
        , fuzz2 integer integer "∀ D ∊ ℤ, d ∊ ℤ - {0}, D = d * q + r where q ∊ ℤ and 0 ≤ r < |d|" <|
            \bigD d ->
                case bigD |> Z.divModBy d of
                    Just ( q, r ) ->
                        ( bigD
                        , (r |> Z.isGreaterThanOrEqual Z.zero) && (r |> Z.isLessThan (Z.abs d))
                        )
                            |> Expect.equal
                                ( Z.add (Z.mul d q) r
                                , True
                                )

                    Nothing ->
                        Z.isZero d
                            |> Expect.equal True
        ]


exponentiationSuite : Test
exponentiationSuite =
    describe "exp"
        [ fuzz integer "∀ z ∊ ℤ, z ^ 0 = 1" <|
            \z ->
                Z.exp z N.zero
                    |> Expect.equal Z.one
        , fuzz nonZeroExponent "∀ n ∊ ℕ - {0}, 0 ^ n = 0" <|
            \n ->
                Z.exp Z.zero n
                    |> Expect.equal Z.zero
        , fuzz integer "∀ z ∊ ℤ, z ^ 1 = z" <|
            \z ->
                Z.exp z N.one
                    |> Expect.equal z
        , fuzz integer "∀ z ∊ ℤ, z ^ 2 = z * z" <|
            \z ->
                Z.exp z N.two
                    |> Expect.equal (Z.mul z z)
        , fuzz integer "∀ z ∊ ℤ, z ^ 3 = z * z * z" <|
            \z ->
                Z.exp z N.three
                    |> Expect.equal (Z.mul z <| Z.mul z z)
        , fuzz3 integer exponent exponent "∀ z ∊ ℤ, z ^ a * z ^ b = z ^ (a + b)" <|
            \z a b ->
                Z.mul (Z.exp z a) (Z.exp z b)
                    |> Expect.equal (Z.exp z <| N.add a b)
        ]



-- CUSTOM FUZZERS


safeInt : Fuzzer Int
safeInt =
    Fuzz.intRange Z.minSafeInt Z.maxSafeInt


natural : Fuzzer Natural
natural =
    Fuzz.intRange 0 N.maxSafeInt
        |> Fuzz.andThen (Fuzz.constant << N.fromSafeInt)


exponent : Fuzzer Natural
exponent =
    Fuzz.uniformInt 25
        |> Fuzz.andThen (Fuzz.constant << N.fromSafeInt)


nonZeroExponent : Fuzzer Natural
nonZeroExponent =
    exponent
        |> Fuzz.map (N.add N.one)


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
