module Main exposing (main)

import Html as H
import Html.Attributes as HA
import Integer as Z exposing (Integer)
import SExpr.Evaluator as E


main : H.Html msg
main =
    H.div []
        [ viewOutput 2 Nothing
        , viewOutput 16 <| Just (Ok Z.ten)
        , viewOutput 36 <| Just (Err <| E.SyntaxError [])
        ]


viewOutput : Int -> Maybe (Result E.Error Integer) -> H.Html msg
viewOutput i maybeResult =
    let
        b =
            clamp 2 36 i

        { status, text } =
            case maybeResult of
                Just (Ok z) ->
                    { status = Just "success"
                    , text = Z.toBaseBString b z |> Maybe.withDefault ""
                    }

                Just (Err e) ->
                    { status = Just "error"
                    , text = errorToString e
                    }

                Nothing ->
                    { status = Nothing
                    , text = "The result of your calculation will appear here."
                    }
    in
    H.output []
        [ H.p
            [ HA.classList
                [ ( "success", status == Just "success" )
                , ( "error", status == Just "error" )
                ]
            ]
            [ H.text text ]
        ]


errorToString : E.Error -> String
errorToString e =
    case e of
        E.SyntaxError _ ->
            "Please check your syntax."

        E.RuntimeError re ->
            case re of
                E.ExpectedAtom _ ->
                    "Expected an atom."

                E.ExpectedNumber _ ->
                    "Expected an integer."

                E.ArityError expectation given ->
                    String.join ""
                        [ "Expected "
                        , expectationToString expectation
                        , ", but was given "
                        , givenToString given
                        , "."
                        ]

                E.DivisionByZero ->
                    "Division by zero is undefined."

                E.NegativeExponent ->
                    "Raising an integer to a negative exponent is undefined."

                E.InternalError ->
                    -- N.B. This should NEVER happen if the implementation is correct.
                    "An unexpected error occurred."


expectationToString : E.Expectation -> String
expectationToString expectation =
    case expectation of
        E.Fixed n ->
            String.fromInt n ++ " " ++ pluralizeArgument n

        E.AtLeast n ->
            "at least " ++ String.fromInt n ++ " " ++ pluralizeArgument n


givenToString : Int -> String
givenToString n =
    String.fromInt n ++ " " ++ pluralizeArgument n


pluralizeArgument : Int -> String
pluralizeArgument =
    pluralize
        { singular = "argument"
        , plural = "arguments"
        }


pluralize : { singular : String, plural : String } -> Int -> String
pluralize { singular, plural } n =
    --
    -- Assumes n >= 0.
    --
    if n == 1 then
        singular

    else
        plural
