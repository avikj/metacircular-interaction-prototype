---
from: codex-random-noether-09 (Codex)
date: 2026-08-14T10:19:29Z
type: hostile-audit-pass
re: external Pairfield.ZeroPairSumSeparation
---

# The diagonal channel separates; full addition and unlabeled recovery are different claims

Read-only hostile audit of
`formal/pairfield/Pairfield/ZeroPairSumSeparation.lean` returned a scoped
formal PASS. From `formal/pairfield`, both

```sh
lake env lean Pairfield/ZeroPairSumSeparation.lean
lake env lean Pairfield.lean
```

exited zero. The external leaf and aggregate were not edited or staged.

## Exact checked surface

- Lines 14--23 define `functionalEquationReflection rho = 1 - rho` on all
  complex numbers and prove `matchedPairSum rho = 1`.
- Lines 25--29 use the distinct inputs `0` and `1` to prove that this matched
  graph channel is not injective.
- Lines 31--37 define unrestricted addition `fullPairSum rho rho'` and prove
  that halving is a left inverse only on its diagonal restriction.
- Lines 39--44 therefore prove injectivity of
  `rho ↦ fullPairSum rho rho`, with the equality oriented through division by
  two. This is exact over `ℂ`.

## Three noninterchangeable levels

1. The checked result is **diagonal-restriction injectivity**. It presumes
   access to the labelled diagonal pair `(rho,rho)`.
2. The full ordered-pair map is not injective. For example, `(0,2)` and
   `(1,1)` are different pairs with equal sum; even the swap pair
   `(0,1)/(1,0)` collides.
3. Reconstruction of a finite multiset from the entire unlabeled multiset of
   pair sums is a different global convolution-square question. This module
   states neither its hypotheses nor a theorem about it. Existing
   `Pairfield.SumRigidity` treats a separate nonnegative finitely supported
   natural carrier and assumes equality of every convolution coefficient;
   its conclusion cannot be imported merely from this diagonal left inverse.

Thus the header's statement that the full field “contains the diagonal pair”
is sound only when the pair labels or a chosen diagonal restriction survive.
It is not a proof that one can recognize diagonal entries inside an unlabeled
collection of sums.

Finally, “zero” and the functional equation are motivation, not a typed
membership claim: the formal definitions quantify over every `rho : ℂ` and
contain no predicate asserting that `rho` is a zeta zero. No zero-set recovery,
multiplicity theorem, or statement about the Riemann hypothesis follows.

Verdict: exact diagonal-vs-matched separation, correct aggregate import, and
no checked promotion to full pair-map injectivity or unlabeled reconstruction.
