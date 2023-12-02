module Test.SExpr.Evaluator exposing (suite)

import Expect
import Integer as Z exposing (Integer)
import SExpr.AST exposing (Atom(..), SExpr(..))
import SExpr.Evaluator as E
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "SExpr.Evaluator"
        [ evaluateOkSuite
        , evaluateErrSuite
        ]


evaluateOkSuite : Test
evaluateOkSuite =
    describe "successful evaluations" <|
        List.map expectEvaluateOk
            -- Decimal
            [ ( "0", Z.zero )
            , ( "10", Z.ten )
            , ( "-10", Z.negativeTen )

            -- 1 Googol
            , ( "10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
              , Z.fromSafeString "10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
              )

            -- Binary
            , ( "0b11", Z.three )
            , ( "-0B101", Z.negativeFive )

            -- Octal
            , ( "0o12", Z.ten )
            , ( "-0O12", Z.negativeTen )

            -- Hexadecimal
            , ( "0xFf", Z.fromSafeString "0xFF" )
            , ( "-0XabcdEf", Z.fromSafeString "-0xABCDEF" )

            -- Arithmetic
            , ( "(abs -4)", Z.four )
            , ( "(negate 1)", Z.negativeOne )
            , ( "(add)", Z.zero )
            , ( "(add 1)", Z.one )
            , ( "(add 1 2)", Z.three )
            , ( "(add 1 2 3)", Z.six )
            , ( "(add 1 2 3 4)", Z.ten )
            , ( "(sub 1 9)", Z.negativeEight )
            , ( "(mul)", Z.one )
            , ( "(mul 2)", Z.two )
            , ( "(mul 2 3)", Z.six )
            , ( "(mul 2 3 4)", Z.fromSafeInt 24 )
            , ( "(mul 2 3 4 5)", Z.fromSafeInt 120 )
            , ( "(div 10 2)", Z.five )
            , ( "(div 10 -2)", Z.negativeFive )
            , ( "(div -10 2)", Z.negativeFive )
            , ( "(div -10 -2)", Z.five )
            , ( "(div 10 3)", Z.three )
            , ( "(div 10 -3)", Z.negativeThree )
            , ( "(div -10 3)", Z.negativeFour )
            , ( "(div -10 -3)", Z.four )
            , ( "(mod 10 2)", Z.zero )
            , ( "(mod 10 -2)", Z.zero )
            , ( "(mod -10 2)", Z.zero )
            , ( "(mod -10 -2)", Z.zero )
            , ( "(mod 10 3)", Z.one )
            , ( "(mod 10 -3)", Z.one )
            , ( "(mod -10 3)", Z.two )
            , ( "(mod -10 -3)", Z.two )
            , ( "(quot 10 2)", Z.five )
            , ( "(quot 10 -2)", Z.negativeFive )
            , ( "(quot -10 2)", Z.negativeFive )
            , ( "(quot -10 -2)", Z.five )
            , ( "(quot 10 3)", Z.three )
            , ( "(quot 10 -3)", Z.negativeThree )
            , ( "(quot -10 3)", Z.negativeThree )
            , ( "(quot -10 -3)", Z.three )
            , ( "(rem 10 2)", Z.zero )
            , ( "(rem 10 -2)", Z.zero )
            , ( "(rem -10 2)", Z.zero )
            , ( "(rem -10 -2)", Z.zero )
            , ( "(rem 10 3)", Z.one )
            , ( "(rem 10 -3)", Z.one )
            , ( "(rem -10 3)", Z.negativeOne )
            , ( "(rem -10 -3)", Z.negativeOne )
            , ( "(exp 0 0)", Z.one )
            , ( "(exp 0 2)", Z.zero )
            , ( "(exp 1 100000)", Z.one )
            , ( "(exp 100000 0)", Z.one )
            , ( "(exp 2 3)", Z.eight )
            , ( "(exp -2 3)", Z.negativeEight )
            , ( "(add 1 2 (sub 5 2) (div (negate (exp -2 (add 1 2))) 2))", Z.ten )
            ]


evaluateErrSuite : Test
evaluateErrSuite =
    describe "unsuccessful evaluations" <|
        List.map expectEvaluateErr
            [ ( "", syntaxError )
            , ( "(abs -4", syntaxError )
            , ( "abs", expectedNumber Abs )
            , ( "(1 2)", expectedAtom Z.one )
            , ( "(abs)", arityError { expected = 1, given = 0 } )
            , ( "(abs 1 2)", arityError { expected = 1, given = 2 } )
            , ( "(sub)", arityError { expected = 2, given = 0 } )
            , ( "(sub 1)", arityError { expected = 2, given = 1 } )
            , ( "(sub 1 2 3)", arityError { expected = 2, given = 3 } )
            , ( "(div 1 0)", divisionByZero )
            , ( "(mod 1 0)", divisionByZero )
            , ( "(quot 1 0)", divisionByZero )
            , ( "(rem 1 0)", divisionByZero )
            , ( "(exp 2 -3)", negativeExponent )
            ]


syntaxError : E.Error
syntaxError =
    E.SyntaxError []


expectedNumber : Atom -> E.Error
expectedNumber =
    E.RuntimeError << E.ExpectedNumber << Atom


expectedAtom : Integer -> E.Error
expectedAtom =
    E.RuntimeError << E.ExpectedAtom << Number


arityError : { expected : Int, given : Int } -> E.Error
arityError { expected, given } =
    E.RuntimeError <| E.ArityError (E.Fixed expected) given


divisionByZero : E.Error
divisionByZero =
    E.RuntimeError E.DivisionByZero


negativeExponent : E.Error
negativeExponent =
    E.RuntimeError E.NegativeExponent


expectEvaluateOk : ( String, Integer ) -> Test
expectEvaluateOk ( input, z ) =
    test input <|
        \_ ->
            E.evaluate input
                |> Expect.equal (Ok z)


expectEvaluateErr : ( String, E.Error ) -> Test
expectEvaluateErr ( input, e ) =
    let
        description =
            if String.isEmpty input then
                "no input"

            else
                input
    in
    test description <|
        \_ ->
            case ( E.evaluate input, e ) of
                ( Err (E.SyntaxError _), E.SyntaxError _ ) ->
                    Expect.pass

                ( evaluationE, _ ) ->
                    evaluationE |> Expect.equal (Err e)
