# Delta 21's involution story is PGL₂, and that is a deflation

**Status:** checked. `formal/cubical/CayleyPairChart.agda`, on the button.
**Source:** Delta 21 (owner, 2026-08-13), §21.5 / §21.7 / §21.12.

## What was claimed, and what is now proved

Delta 21 asserts three things that are pure algebra. Assertion is not the
right register for pure algebra, so they are settled instead.

| Delta 21 | statement | name in the module |
|---|---|---|
| T21.8 (§21.5) | the compatibility tensor `α_ij = x_i(β_ij − 1)` | `compatibility` |
| T21.11 (§21.7) | Cayley conjugates leg-exchange `z ↦ 1/z` to negation `x ↦ −x` | `legExchangeIsNegation` |
| T21.11 (§21.7) | Cayley conjugates sign-flip `z ↦ −z` to inversion `x ↦ 1/x` | `signFlipIsInversion` |
| S21.19 (§21.12) | sum–gap duality is the one-leg sign involution on `L₊ = a+b`, `L₋ = a−b` | `sumGapDuality`, `gapSumDuality` |

C21.12 is the consequence, and it is the point of the exercise: the split
torus, the Weyl reflection, the angular Jacobi coordinate and the sum–gap
inversion are **one object** — Möbius geometry on P¹. Delta 21 calls this a
simplification. It is also a deflation, and the module is where the deflation
becomes non-negotiable: none of that structure was new geometry, and no
further note should spend pages re-deriving it.

## The one methodological move: clear the denominators

The Cayley transform is a quotient, `x = (z−1)/(z+1)`, so the naive
formalization needs a field, an inverse, and a silent side condition
`z ≠ −1`. All three are avoidable. State the chart as a **relation**:

```agda
Chart : R → R → Type
Chart z x = x · (z + 1r) ≡ z - 1r
```

Then every statement lives over ℤ, no field is needed, and — this is the
part worth keeping — the excluded points stop being silent. In
`signFlipIsInversion` the degeneracy appears as a hypothesis you must
discharge:

```agda
signFlipIsInversion : (z x x' : R) → Chart z x
                    → x' · ((- z) + 1r) ≡ (- z) - 1r
                    → ((1r - z · z) ≡ 0r → ⊥)
                    → x · x' ≡ 1r
```

`1 − z² = 0` is exactly `z = ±1`, which is exactly the pair of points
C21.13 identifies as the images of the interval endpoints. The boundary of
the chart is not a technicality bolted on afterwards; it is the ring
element the proof has to cancel, and it is cancelled by `isIntegralℤ` — the
same integral-domain step that carries `Gamma0Converse` and
`Gamma0Freeness`. One cancellation lemma, three theorems.

The proof of the inversion half is four lines of content: multiply the two
cleared charts, observe both sides carry the same quadratic factor
`e² − z²`, cancel it.

## A solver hazard, recorded because it will recur

**`1r` may not appear inside a `solve ℤCommRing` goal.** ℤ's own reductions
fire before reflection — `z + 1r ↝ sucℤ z`, `z − 1r ↝ predℤ z` — and the
reflected expression then carries the *variable* as a ring constant
(`Expr.K β`), so the solver's normal form cannot match the goal. The error
is a two-hundred-line dump of `IteratedHornerForms` internals and says
nothing about the cause.

The fix is the idiom `Rank1DihedralChart.detChart` already used without
naming: abstract the unit to a variable `e`, solve, instantiate at `1r`.

```agda
scaleDiff : (β xi e : R) → β · xi - e · xi ≡ xi · (β - e)
scaleDiff = solve ℤCommRing
-- then: scaleDiff β xi 1r  :  β · xi - xi ≡ xi · (β - 1r)     (1r · xi reduces)
```

This is legal only where the identity is **homogeneous in `(z, e)`** — `e`
must be substitutable for the unit uniformly. Where it is not (here: the
step `k · 1r ≡ k`), the unit has to come from a library lemma, `·IdR` or
`+IdL`, not from the solver. Getting this wrong is silent: the
generalized statement is simply false, and the failure surfaces only at
instantiation.

Gamma0Transitivity already carries a partial version of this note ("ℤ
reduction facts (probed): 0r·a, 1r·a, a+0r reduce; the mirrored forms are
stuck"). It should have been a rule, not a comment on one lemma.

## What this does not settle

Delta 21's actual thesis is **§21.13, "the bridge is evaluation"** — that
additive and multiplicative structure are not identified but related by an
evaluation morphism, and that the failure of a basepoint-free
identification is C21.9. `compatibility` is the local shadow of that: the
additive root displacement is the multiplicative one *scaled by an
endpoint*, so the identification depends on the basepoint `x_i`. That is a
one-line witness, not the theorem. The evaluation morphism itself is the
next target and is not formalized here.
