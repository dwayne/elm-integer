module SExpr.Evaluator exposing
    ( Error(..)
    , Expectation(..)
    , RuntimeError(..)
    , evaluate
    )

import Integer as Z exposing (Integer)
import Parser exposing (DeadEnd, run)
import SExpr.AST exposing (Atom(..), SExpr(..))
import SExpr.Parser as P


type Error
    = SyntaxError (List DeadEnd)
    | RuntimeError RuntimeError


type RuntimeError
    = ExpectedAtom SExpr
    | ExpectedNumber SExpr
    | ArityError Expectation Int
    | DivisionByZero
    | NegativeExponent
    | InternalError


type Expectation
    = Fixed Int
    | AtLeast Int


evaluate : String -> Result Error Integer
evaluate input =
    case run P.input input of
        Ok sexpr ->
            evaluateSExpr sexpr
                |> Result.mapError RuntimeError

        Err deadEnds ->
            Err <| SyntaxError deadEnds


evaluateSExpr : SExpr -> Result RuntimeError Integer
evaluateSExpr sexpr =
    case sexpr of
        Atom _ ->
            Err <| ExpectedNumber sexpr

        Number z ->
            Ok z

        List sexprs ->
            case sexprs of
                [] ->
                    Err <| ExpectedNumber sexpr

                sexpr1 :: sexprRest ->
                    case sexpr1 of
                        Atom atom ->
                            evaluateOp atom sexprRest

                        _ ->
                            Err <| ExpectedAtom sexpr1


evaluateOp : Atom -> List SExpr -> Result RuntimeError Integer
evaluateOp atom =
    case atom of
        Abs ->
            call abs (Fixed 1)

        Negate ->
            call negate (Fixed 1)

        Add ->
            call add (AtLeast 0)

        Sub ->
            call sub (Fixed 2)

        Mul ->
            call mul (AtLeast 0)

        Div ->
            call div (Fixed 2)

        Mod ->
            call mod (Fixed 2)

        Quot ->
            call quot (Fixed 2)

        Rem ->
            call rem (Fixed 2)

        Exp ->
            call exp (Fixed 2)


call : (List Integer -> Result RuntimeError Integer) -> Expectation -> List SExpr -> Result RuntimeError Integer
call evaluateF expectation =
    expectArgs expectation
        >> Result.andThen evaluateArgs
        >> Result.andThen evaluateF


expectArgs : Expectation -> List SExpr -> Result RuntimeError (List SExpr)
expectArgs expectation sexprs =
    let
        l =
            List.length sexprs
    in
    case expectation of
        Fixed n ->
            if l == n then
                Ok sexprs

            else
                Err <| ArityError expectation l

        AtLeast n ->
            if l >= n then
                Ok sexprs

            else
                Err <| ArityError expectation l


evaluateArgs : List SExpr -> Result RuntimeError (List Integer)
evaluateArgs sexprs =
    case sexprs of
        [] ->
            Ok []

        sexpr :: restSExprs ->
            evaluateSExpr sexpr
                |> Result.andThen
                    (\z ->
                        evaluateArgs restSExprs
                            |> Result.map ((::) z)
                    )


abs : List Integer -> Result RuntimeError Integer
abs args =
    case args of
        [ x ] ->
            Ok <| Z.abs x

        _ ->
            Err InternalError


negate : List Integer -> Result RuntimeError Integer
negate args =
    case args of
        [ x ] ->
            Ok <| Z.negate x

        _ ->
            Err InternalError


add : List Integer -> Result RuntimeError Integer
add =
    Ok << addHelper Z.zero


addHelper : Integer -> List Integer -> Integer
addHelper sum args =
    case args of
        [] ->
            sum

        x :: restArgs ->
            addHelper (Z.add x sum) restArgs


sub : List Integer -> Result RuntimeError Integer
sub args =
    case args of
        [ x, y ] ->
            Ok <| Z.sub x y

        _ ->
            Err InternalError


mul : List Integer -> Result RuntimeError Integer
mul =
    Ok << mulHelper Z.one


mulHelper : Integer -> List Integer -> Integer
mulHelper product args =
    case args of
        [] ->
            product

        x :: restArgs ->
            mulHelper (Z.mul x product) restArgs


div : List Integer -> Result RuntimeError Integer
div args =
    case args of
        [ x, y ] ->
            Z.divBy y x
                |> Result.fromMaybe DivisionByZero

        _ ->
            Err InternalError


mod : List Integer -> Result RuntimeError Integer
mod args =
    case args of
        [ x, y ] ->
            Z.modBy y x
                |> Result.fromMaybe DivisionByZero

        _ ->
            Err InternalError


quot : List Integer -> Result RuntimeError Integer
quot args =
    case args of
        [ x, y ] ->
            Z.quotBy y x
                |> Result.fromMaybe DivisionByZero

        _ ->
            Err InternalError


rem : List Integer -> Result RuntimeError Integer
rem args =
    case args of
        [ x, y ] ->
            Z.remBy y x
                |> Result.fromMaybe DivisionByZero

        _ ->
            Err InternalError


exp : List Integer -> Result RuntimeError Integer
exp args =
    case args of
        [ x, y ] ->
            if Z.isNonNegative y then
                Ok <| Z.exp x (Z.toNatural y)

            else
                Err <| NegativeExponent

        _ ->
            Err InternalError
