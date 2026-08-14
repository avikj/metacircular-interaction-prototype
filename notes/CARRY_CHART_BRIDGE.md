# Carry reduction inside the canonical digit chart

**Status:** checked in safe Cubical Agda.  This is an operational adapter and
one killed naïve translation; it adds no group-cohomology claim.

## The obstruction

`NaturalMachine.Digits` represents a natural number by a little-endian
canonical word: the last, most-significant digit must be nonzero.
`NaturalMachine.Endian.π` deletes that last digit.  It is therefore a map on raw
words, but not a map on `CanWord`: in every base at least two,

\[
  [1,0,1]\quad\longmapsto\quad[1,0],
\]

and the result has a zero most-significant digit.  The checked term
`rawπ-does-not-restrict` records this counterexample.  Thus the proposed direct
restriction of `π` to canonical words is ill-typed, not merely unproved.

The least repair is normalization by the already-proved digit equivalence:

\[
  \operatorname{normalizeMSD}(w)
  = \operatorname{digitsC}(\operatorname{value}(π w)).
\]

It preserves the truncated value exactly while deleting any newly exposed
leading zeros.

## The exact adapter

Fix `b = 2 + k` and adjacent levels `n = 1 + n'`.  The module defines total
residue charts

\[
 \operatorname{chartM}:\mathrm{CanWord}\to\mathrm{Fin}(M),\qquad
 \operatorname{chartN}:\mathrm{CanWord}\to\mathrm{Fin}(N),
\]

where `CarryObstruction.BasePower` supplies checked paths
`M≡b : M ≡ b^(n+1)` and `N≡ : N ≡ b^n`.  If a canonical word is written
as `xs ++ [y]` with `length xs ≡ n`, then

\[
 \boxed{
 \operatorname{red}(\operatorname{chartM}(xs\mathbin{+\!+}[y]))
 =
 \operatorname{chartN}
   (\operatorname{normalizeMSD}(xs\mathbin{+\!+}[y])) .}
\]

This is `red-chart-truncates`.  Its arithmetic core is the positional identity

\[
 \operatorname{value}(xs\mathbin{+\!+}[y])
 = \operatorname{value}(xs)+b^{|xs|}y,
\]

followed by the fact that the second summand is zero modulo `N = b^n`.
`CarryObstruction.mod-mod` then identifies reduction modulo `M` followed by
reduction modulo `N` with direct reduction modulo `N`.

The square commutes propositionally, not by `refl`.  Three distinctions are
load-bearing: the modulus is connected to a literal power by a path; modular
reduction is a theorem rather than definitional computation at variable
width; and raw truncation must be normalized before it returns to `CanWord`.

## What changed

`CarryObstruction` previously proved nonsplitting only in cyclic quotient
coordinates.  The adapter now makes its `red` map executable on the repository's
actual numeral presentation.  A consumer can move from a canonical word at one
finite digit level to the adjacent residue coordinate without inventing a
second evaluator.  Conversely, any future statement equating raw `π` directly
with a `CanWord → CanWord` operation must confront the checked counterexample.

This does **not** construct
`H²(ℤ/b^n;ℤ/b)`, exhibit a carrying pair from the constructive negation of
universal carry-freeness, or identify least representatives with arbitrary
sections.  Those boundaries of `CarryObstruction` remain unchanged.

## Replay

```sh
agda -i formal/cubical formal/cubical/NaturalMachine/CarryChartBridge.agda
sh formal/check.sh
```

The source is
`formal/cubical/NaturalMachine/CarryChartBridge.agda`; the root aggregate imports
it, so the second command checks the adapter as part of the complete formal gate.

