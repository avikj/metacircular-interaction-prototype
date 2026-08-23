# Bounded coverage compiles witness fibres to canonical least inhabitants

`MathMachine` now contains the generic Theorem Factory II transformation,
without any prime or Goldbach assertion.

`leastCovered` consumes:

- an explicitly ordered finite fibre;
- a decidable predicate;
- an accepted coverage witness.

It first validates that the supplied witness lies in the fibre and satisfies
the predicate. Only then does it return `LeastWitness`, consisting of the
canonical first satisfying value and the complete rejected prefix. Invalid
coverage remains typed as `WitnessOutsideFiber` or `WitnessRejected`.

For an unbounded recurrence claim, `searchPrefix` has the deliberately weaker
codomain `FoundLeast | OpenBeyond searchedPrefix`. Exhausting a finite prefix
cannot become a totality or nonexistence claim.

Scoped executable control:

```text
fibre = [0..20]
P(n) = n >= 7 and n = 1 mod 3
satisfying witnesses = {7,10,13,16,19}
canonical representative = 7
```

Thus five arbitrary witnesses collapse to one after coverage is supplied. A
false supplied witness `15` returns `WitnessRejected`; searching only `[0..6]`
returns `OpenBeyond [0..6]`.
