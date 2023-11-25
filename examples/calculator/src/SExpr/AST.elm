module SExpr.AST exposing (Atom(..), SExpr(..))

import Integer exposing (Integer)


type SExpr
    = Atom Atom
    | Number Integer
    | List (List SExpr)


type Atom
    = Abs
    | Negate
    | Add
    | Sub
    | Mul
    | Div
    | Mod
