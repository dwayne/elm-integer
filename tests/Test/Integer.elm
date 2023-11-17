module Test.Integer exposing (suite)

import Expect
import Fuzz exposing (Fuzzer)
import Integer as Z
import Test exposing (Test, describe, fuzz, test)


suite : Test
suite =
    describe "Integer"
        [ intConversionSuite
        , constantsSuite
        , baseBStringConversionSuite
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



-- CUSTOM FUZZERS


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
