module Test.Integer exposing (suite)

import Expect
import Fuzz
import Integer as Z
import Test exposing (Test, describe, fuzz, test)


suite : Test
suite =
    describe "Integer"
        [ intConversionSuite
        , constantsSuite
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
