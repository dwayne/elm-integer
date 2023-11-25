module Test.SExpr.Parser exposing (suite)

import Expect
import Integer as Z
import Parser as P
import SExpr.AST exposing (..)
import SExpr.Parser exposing (sexpr)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "SExpr.Parser"
        [ atomSuite
        , numberSuite
        , listSuite
        ]


atomSuite : Test
atomSuite =
    describe "AST.Atom" <|
        List.map expectAtom
            [ ( "abs", Just Abs )
            , ( "absolute", Nothing )
            , ( "negate", Just Negate )
            , ( "neg", Nothing )
            , ( "add", Just Add )
            , ( "plus", Nothing )
            , ( "sub", Just Sub )
            , ( "subtract", Nothing )
            , ( "diff", Nothing )
            , ( "mul", Just Mul )
            , ( "multiply", Nothing )
            , ( "div", Just Div )
            , ( "divide", Nothing )
            , ( "mod", Just Mod )
            , ( "%", Nothing )
            , ( "exp", Just Exp )
            , ( "pow", Nothing )
            ]


numberSuite : Test
numberSuite =
    describe "AST.Number" <|
        List.map expectNumber
            -- Binary
            [ "0b1010"
            , "-0B1111"

            -- Octal
            , "0o1234567"
            , "-0O7654321"

            -- Hexadecimal
            , "0X1234567890aBcDeF"
            , "-0xfEdCbA0987654321"

            -- Decimal
            , "123456789"
            , "-918273645"
            ]


listSuite : Test
listSuite =
    describe "AST.List"
        [ test "()" <|
            \_ ->
                parse "()"
                    |> Expect.equal (Just <| List [])
        , test "(() (()))" <|
            \_ ->
                parse "(() (()))"
                    |> Expect.equal (Just <| List [ List [], List [ List [] ] ])
        , test "(abs -0x2)" <|
            \_ ->
                parse "(abs -0x2)"
                    |> Expect.equal (Just <| List [ Atom Abs, Number (Z.fromSafeString "-0x2") ])
        ]



-- EXPECTATIONS


expectAtom : ( String, Maybe Atom ) -> Test
expectAtom ( s, maybeAtom ) =
    test s <|
        \_ ->
            parse s
                |> Expect.equal (Maybe.map Atom maybeAtom)


expectNumber : String -> Test
expectNumber s =
    test s <|
        \_ ->
            parse s
                |> Expect.equal (Maybe.map Number <| Z.fromString s)



-- PARSER


parse : String -> Maybe SExpr
parse =
    Result.toMaybe << P.run sexpr
