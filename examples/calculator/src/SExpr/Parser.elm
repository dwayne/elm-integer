module SExpr.Parser exposing (atom, integer, sexpr)

import Integer as Z exposing (Integer)
import Parser as P exposing ((|.), (|=), Parser)
import SExpr.AST exposing (..)


sexpr : Parser SExpr
sexpr =
    P.oneOf
        [ P.map Atom atom
        , P.map Number integer
        , P.map List <|
            P.succeed identity
                |. symbol "("
                |= many (P.lazy (\_ -> sexpr))
                |. symbol ")"
        ]


atom : Parser Atom
atom =
    chompAtom
        |> P.getChompedString
        |> P.map
            (\s ->
                case s of
                    "abs" ->
                        Abs

                    "negate" ->
                        Negate

                    "add" ->
                        Add

                    "sub" ->
                        Sub

                    "mul" ->
                        Mul

                    "div" ->
                        Div

                    "mod" ->
                        Mod

                    "exp" ->
                        Exp

                    _ ->
                        -- We are guaranteed that s is one of the above values
                        -- and so we can return whatever we want here.
                        Abs
            )
        |> lexeme


chompAtom : Parser ()
chompAtom =
    [ "abs", "negate", "add", "sub", "mul", "div", "mod", "exp" ]
        |> List.map P.keyword
        |> P.oneOf


integer : Parser Integer
integer =
    chompInteger
        |> P.getChompedString
        |> P.map Z.fromSafeString
        |> lexeme


chompInteger : Parser ()
chompInteger =
    P.succeed ()
        |. chompSign
        |. chompMagnitude


chompSign : Parser ()
chompSign =
    chompOptional ((==) '-')


chompMagnitude : Parser ()
chompMagnitude =
    P.oneOf
        [ P.succeed ()
            |. chompPrefix [ "0b", "0B" ]
            |. chompBinary
        , P.succeed ()
            |. chompPrefix [ "0o", "0O" ]
            |. chompOctal
        , P.succeed ()
            |. chompPrefix [ "0x", "0X" ]
            |. chompHex
        , chompDecimal
        ]


chompPrefix : List String -> Parser ()
chompPrefix =
    P.oneOf << List.map P.token


chompBinary : Parser ()
chompBinary =
    chompOneOrMore isBinaryDigit


isBinaryDigit : Char -> Bool
isBinaryDigit c =
    c == '0' || c == '1'


chompOctal : Parser ()
chompOctal =
    chompOneOrMore Char.isOctDigit


chompHex : Parser ()
chompHex =
    chompOneOrMore Char.isHexDigit


chompDecimal : Parser ()
chompDecimal =
    chompOneOrMore Char.isDigit


chompOptional : (Char -> Bool) -> Parser ()
chompOptional isGood =
    P.oneOf
        [ P.chompIf isGood
        , P.succeed ()
        ]


chompOneOrMore : (Char -> Bool) -> Parser ()
chompOneOrMore isGood =
    P.succeed ()
        |. P.chompIf isGood
        |. P.chompWhile isGood


many : Parser a -> Parser (List a)
many p =
    let
        helper rev =
            P.oneOf
                [ P.succeed (\x -> P.Loop (x :: rev))
                    |= p
                , P.succeed ()
                    |> P.map (\_ -> P.Done (List.reverse rev))
                ]
    in
    P.loop [] helper


symbol : String -> Parser ()
symbol =
    lexeme << P.symbol


lexeme : Parser a -> Parser a
lexeme p =
    P.succeed identity
        |= p
        |. P.spaces
