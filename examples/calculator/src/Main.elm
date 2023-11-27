module Main exposing (main)

import Browser as B
import Data.Base as Base exposing (Base)
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Integer as Z exposing (Integer)
import SExpr.Evaluator as E


main : Program () Model Msg
main =
    B.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { input : String
    , previousBaseBBase : Base
    , format : Format
    , maybeResult : Maybe (Result E.Error Integer)
    }


type Format
    = Decimal
    | Binary
    | Octal
    | Hex
    | BaseB Base


formatToInt : Format -> Int
formatToInt format =
    case format of
        Decimal ->
            10

        Binary ->
            2

        Octal ->
            8

        Hex ->
            16

        BaseB base ->
            Base.toInt base


init : Model
init =
    { input = ""
    , previousBaseBBase = Base.twenty
    , format = Decimal
    , maybeResult = Nothing
    }



-- UPDATE


type Msg
    = ChangedInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangedInput newInput ->
            { model | input = newInput }



-- VIEW


view : Model -> H.Html Msg
view { input, previousBaseBBase, format, maybeResult } =
    H.div []
        [ viewIntroSection
        , viewInputSection input
        , viewOutputOptionsSection previousBaseBBase format
        , viewOutputSection format maybeResult
        ]


viewIntroSection : H.Html msg
viewIntroSection =
    H.div []
        [ H.h1 [] [ H.text "Calculator" ]
        , H.p []
            [ H.text "This is a simple "
            , H.a [ HA.href "https://en.wikipedia.org/wiki/Integer" ] [ H.text "integer" ]
            , H.text " calculator built upon the "
            , H.a [ HA.href "https://github.com/dwayne/elm-integer" ] [ H.text "elm-integer" ]
            , H.text " library. It's designed to make it easy to test out all the "
            , H.strong [] [ H.text "integer input formats" ]
            , H.text ", "
            , H.strong [] [ H.text "arithmetic operations" ]
            , H.text ", and "
            , H.strong [] [ H.text "integer output formats" ]
            , H.text " that's supported by the library."
            ]
        ]


viewInputSection : String -> H.Html Msg
viewInputSection input =
    let
        cfg =
            """
    Expr      ::= Integer
                | '(' 'abs' Expr ')'
                | '(' 'negate' Expr ')'
                | '(' 'add' Expr* ')'
                | '(' 'sub' Expr Expr ')'
                | '(' 'mul' Expr* ')'
                | '(' 'div' Expr Expr ')'
                | '(' 'mod' Expr Expr ')'
                | '(' 'exp' Expr Expr ')'
    Integer   ::= Sign Magnitude
    Sign      ::= '-'?
    Magnitude ::= ('0b' | '0B') Binary
                | ('0o' | '0O') Octal
                | ('0x' | '0X') Hex
                | Decimal
    Binary    ::= [0-1]+
    Octal     ::= [0-7]+
    Hex       ::= [0-9a-fA-F]+
    Decimal   ::= [0-9]+
            """
    in
    H.div []
        [ H.h2 [] [ H.text "Input" ]
        , H.p []
            [ H.text "You can enter your expression using an "
            , H.a [ HA.href "https://en.wikipedia.org/wiki/S-expression" ] [ H.text "S-expression" ]
            , H.text " based language."
            ]
        , H.p [] [ H.text "The following syntax is supported:" ]
        , H.pre [] [ H.text cfg ]
        , H.textarea
            [ HA.rows 10
            , HA.cols 80
            , HA.placeholder "(add 1 0b10 (negate (sub 5 0O10)) (abs -0B100) (div 0xC8 0o50))"
            , HE.onInput ChangedInput
            ]
            [ H.text input ]
        , H.p []
            [ H.button [] [ H.text "Calculate!" ] ]
        ]


viewOutputOptionsSection : Base -> Format -> H.Html msg
viewOutputOptionsSection previousBaseBBase format =
    H.div []
        [ H.h2 [] [ H.text "Output Options" ]
        , H.p [] [ H.text "Select how you would like your integer result to be formatted." ]
        , viewRadioButtons previousBaseBBase format
        ]


viewRadioButtons : Base -> Format -> H.Html msg
viewRadioButtons previousBaseBBase format =
    H.div []
        [ viewRadioButton
            { id = "decimalFormat"
            , value = "decimal"
            , isChecked = format == Decimal
            , text = "Decimal"
            }
            Nothing
        , viewRadioButton
            { id = "binaryFormat"
            , value = "binary"
            , isChecked = format == Binary
            , text = "Binary"
            }
            Nothing
        , viewRadioButton
            { id = "octalFormat"
            , value = "octal"
            , isChecked = format == Octal
            , text = "Octal"
            }
            Nothing
        , viewRadioButton
            { id = "hexFormat"
            , value = "hex"
            , isChecked = format == Hex
            , text = "Hexadecimal"
            }
            Nothing
        , let
            ( isChecked, viewSelect ) =
                case format of
                    BaseB base ->
                        ( True, viewBaseBSelect False base )

                    _ ->
                        ( False, viewBaseBSelect True previousBaseBBase )
          in
          viewRadioButton
            { id = "baseBFormat"
            , value = "baseB"
            , isChecked = isChecked
            , text = "Base "
            }
            (Just viewSelect)
        ]


viewRadioButton : { id : String, value : String, isChecked : Bool, text : String } -> Maybe (H.Html msg) -> H.Html msg
viewRadioButton { id, value, isChecked, text } maybeHtml =
    H.div []
        [ H.input
            [ HA.type_ "radio"
            , HA.id id
            , HA.name "format"
            , HA.value value
            , HA.checked isChecked
            ]
            []
        , H.label [ HA.for id ] [ H.text text ]
        , maybeHtml
            |> Maybe.withDefault (H.text "")
        ]


viewBaseBSelect : Bool -> Base -> H.Html msg
viewBaseBSelect isDisabled base =
    let
        selectedB =
            Base.toInt base
    in
    H.select [ HA.disabled isDisabled ] <|
        List.map
            (\b ->
                H.option
                    [ HA.selected <| b == selectedB ]
                    [ H.text <| String.fromInt b ]
            )
            (List.range 2 36)


viewOutputSection : Format -> Maybe (Result E.Error Integer) -> H.Html msg
viewOutputSection format maybeResult =
    H.div []
        [ H.h2 [] [ H.text "Output" ]
        , viewOutput format maybeResult
        ]


viewOutput : Format -> Maybe (Result E.Error Integer) -> H.Html msg
viewOutput format maybeResult =
    let
        { status, text } =
            case maybeResult of
                Just (Ok z) ->
                    { status = Just "success"
                    , text =
                        let
                            b =
                                formatToInt format
                        in
                        Z.toBaseBString b z |> Maybe.withDefault ""
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
