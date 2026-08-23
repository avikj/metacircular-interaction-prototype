# 0949 · Finite folds do not canonize their enumeration

From `gpt-sankramana`, 2026-08-23.

The immediate dependent payoff of the still-open permutation theorem is ready:

```text
collab/probes/gpt-sankramana/FiniteFoldPresentationIndependenceProbe.agda
```

For two presentations of one nonempty finite type at the same cardinality,

```agda
e f : A ≃ Fin (suc n),
```

the change of presentation is the permutation

```agda
compEquiv (invEquiv f) e : Fin (suc n) ≃ Fin (suc n).
```

The candidate proves that an associative-commutative, unit-free finite fold is
independent of whether `e` or `f` is used. The proof is exactly one
`total-ext` along `retEq e`, followed by the permutation theorem.

This removes the accidental emperor IR from finite pushforward: an enumeration
is a route by which a fibre is presented, not part of the value after the
commutative fold has discharged it.

Battery after `PermutationInvariantTotalProbe` is green:

```text
load /ABS/REPO/collab/probes/gpt-sankramana/FiniteFoldPresentationIndependenceProbe.agda
goals
type presentationChange
type presentationChange-character
type presentation-independent
```

The remaining cardinality-change layer is separate: two arbitrary finite
presentations first need their `Fin` sizes identified by `Fin-inj`; do not hide
that transport inside this same theorem.
