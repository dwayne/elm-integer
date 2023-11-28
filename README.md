# Elm Integer

A pure Elm library for computing with the [integers](https://en.wikipedia.org/wiki/Integer),
ℤ = { ..., -2, -1, 0, 1, 2, ... }.

## What's available?

### The integers from -10 to 10

- `negativeTen`
- `negativeNine`
- `negativeEight`
- `negativeSeven`
- `negativeSix`
- `negativeFive`
- `negativeFour`
- `negativeThree`
- `negativeTwo`
- `negativeOne`
- `zero`
- `one`
- `two`
- `three`
- `four`
- `five`
- `six`
- `seven`
- `eight`
- `nine`
- `ten`

### Ways to create integers from an `Int` or a [`Natural`][Natural]

- `fromSafeInt`
- `fromInt`
- `fromNatural`

### Ways to create integers from a `String`

- `fromSafeString`
- `fromString`
- `fromBinaryString`
- `fromOctalString`
- `fromDecimalString`
- `fromHexString`
- `fromBaseBString`

### Comparison operators

- `==`
- `/=`
- `compare`
- `isLessThan`
- `isLessThanOrEqual`
- `isGreaterThan`
- `isGreaterThanOrEqual`
- `max`
- `min`

### Predicates for classification

- `isNegative` (i.e. `< 0`)
- `isNonNegative` (i.e. `>= 0`)
- `isZero` (i.e. `== 0`)
- `isNonZero` (i.e. `/= 0`)
- `isPositive` (i.e. `> 0`)
- `isNonPositive` (i.e. `<= 0`)
- `isEven`
- `isOdd`

### Arithmetic

- `abs`
- `negate`
- `add`
- `sub`
- `mul`
- `divModBy` (Euclidean division)
- `divBy`
- `modBy`
- `quotRemBy` (differs from `divModBy` in its handling of negative operands)
- `quotBy`
- `remBy`
- `exp`

### Ways to convert to an `Int` or a [`Natural`][Natural]

- `toInt`
- `toNatural`

**N.B.** *Please remember to use them with caution since they discard information.*

### Ways to convert to a `String`

- `toString` (same as `toDecimalString`)
- `toBinaryString`
- `toOctalString`
- `toDecimalString`
- `toHexString`
- `toBaseBString`

## Examples

TODO

## Performance

**TL;DR** The performance of this library depends solely on the performance of [elm-natural][elm-natural].

This library is built on elm-natural and each function that is implemented using functions from elm-natural only introduces
a constant amount of overhead. As a result, the performance characteristics of a given function, `f`, from this library are
directly related to
[the performance characteristics of the functions from elm-natural][elm-natural-performance]
that are used to implement `f`. Practically speaking, this means that any performance gains in elm-natural will necessarily
lead to corresponding performance gains within elm-integer.

## Resources

- Chapter 18 - Arbitrary-Precision Arithmetic of [C Interfaces and Implementations: Techniques for Creating Reusable Software](https://archive.org/details/cinterfacesimple0000hans) helped me figure out how to design, organize and build the library using the natural numbers as a starting point.
- [Euclidean Division: Integer Division with Remainders](https://www.probabilisticworld.com/euclidean-division-integer-division-with-remainders/) by Probabilistic World helped me to understand all the intricacies involved with implementing Euclidean division over the integers.

[elm-natural]: https://package.elm-lang.org/packages/dwayne/elm-natural/1.0.1
[Natural]: https://package.elm-lang.org/packages/dwayne/elm-natural/1.0.1/Natural
[elm-natural-performance]: https://github.com/dwayne/elm-natural/tree/1.0.1#performance
