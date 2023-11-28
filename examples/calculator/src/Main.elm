module Main exposing (main)

import Browser as B
import Data.Base as Base exposing (Base)
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Integer as Z exposing (Integer)
import Json.Decode as JD
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
    , baseBBase : Base
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
    , baseBBase = Base.twenty
    , format = Decimal
    , maybeResult = Nothing
    }



-- UPDATE


type Msg
    = ChangedInput String
    | ClickedCalculate
    | ChangedFormat Format
    | ChangedBaseBBase Base


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangedInput newInput ->
            { model | input = newInput }

        ClickedCalculate ->
            let
                cleanedInput =
                    String.trim model.input
            in
            if String.isEmpty cleanedInput then
                model

            else
                { model
                    | maybeResult = Just <| E.evaluate cleanedInput
                }

        ChangedFormat newFormat ->
            { model | format = newFormat }

        ChangedBaseBBase base ->
            { model | baseBBase = base, format = BaseB base }



-- VIEW


view : Model -> H.Html Msg
view { input, baseBBase, format, maybeResult } =
    H.div []
        [ viewIntroSection
        , viewInputSection input
        , viewOutputOptionsSection baseBBase format
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
                | '(' 'quot' Expr Expr ')'
                | '(' 'rem' Expr Expr ')'
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
            [ H.button
                [ HA.disabled (String.isEmpty <| String.trim input)
                , HE.onClick ClickedCalculate
                ]
                [ H.text "Calculate!" ]
            ]
        ]


viewOutputOptionsSection : Base -> Format -> H.Html Msg
viewOutputOptionsSection baseBBase format =
    H.div []
        [ H.h2 [] [ H.text "Output Options" ]
        , H.p [] [ H.text "Select how you would like your integer result to be formatted." ]
        , viewRadioButtons baseBBase format
        ]


viewRadioButtons : Base -> Format -> H.Html Msg
viewRadioButtons baseBBase format =
    H.div []
        [ viewRadioButton
            { selectedFormat = format
            , currentFormat = Decimal
            }
        , viewRadioButton
            { selectedFormat = format
            , currentFormat = Binary
            }
        , viewRadioButton
            { selectedFormat = format
            , currentFormat = Octal
            }
        , viewRadioButton
            { selectedFormat = format
            , currentFormat = Hex
            }
        , viewRadioButton
            { selectedFormat = format
            , currentFormat = BaseB baseBBase
            }
        ]


viewRadioButton : { selectedFormat : Format, currentFormat : Format } -> H.Html Msg
viewRadioButton { selectedFormat, currentFormat } =
    let
        isChecked =
            currentFormat == selectedFormat

        { id, value, text, maybeHtml } =
            case currentFormat of
                Decimal ->
                    { id = "decimalFormat"
                    , value = "decimal"
                    , text = "Decimal"
                    , maybeHtml = Nothing
                    }

                Binary ->
                    { id = "binaryFormat"
                    , value = "binary"
                    , text = "Binary"
                    , maybeHtml = Nothing
                    }

                Octal ->
                    { id = "octalFormat"
                    , value = "octal"
                    , text = "Octal"
                    , maybeHtml = Nothing
                    }

                Hex ->
                    { id = "hexFormat"
                    , value = "hex"
                    , text = "Hexadecimal"
                    , maybeHtml = Nothing
                    }

                BaseB base ->
                    { id = "baseBFormat"
                    , value = "baseB"
                    , text = "Base "
                    , maybeHtml =
                        Just <|
                            if isChecked then
                                viewBaseBSelect False base

                            else
                                viewBaseBSelect True base
                    }
    in
    H.div []
        [ H.input
            [ HA.type_ "radio"
            , HA.id id
            , HA.name "format"
            , HA.value value
            , HA.checked isChecked
            , onFormat (ChangedFormat currentFormat)
            ]
            []
        , H.label [ HA.for id ] [ H.text text ]
        , maybeHtml
            |> Maybe.withDefault (H.text "")
        ]


onFormat : msg -> H.Attribute msg
onFormat msg =
    HE.on "input" (JD.succeed msg)


viewBaseBSelect : Bool -> Base -> H.Html Msg
viewBaseBSelect isDisabled base =
    let
        selectedB =
            Base.toInt base

        attrs =
            if isDisabled then
                [ HA.disabled True ]

            else
                [ onBaseBBase ChangedBaseBBase ]
    in
    H.select attrs <|
        List.map
            (\b ->
                H.option
                    [ HA.selected <| b == selectedB
                    ]
                    [ H.text <| String.fromInt b ]
            )
            (List.range 2 36)


onBaseBBase : (Base -> msg) -> H.Attribute msg
onBaseBBase toMsg =
    let
        decoder =
            HE.targetValue
                |> JD.andThen
                    (\s ->
                        case Base.fromString s of
                            Just base ->
                                JD.succeed <| toMsg base

                            Nothing ->
                                JD.fail <| "Expected an positive integer between 2 and 36 inclusive: " ++ s
                    )
    in
    HE.on "input" decoder


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
