---
from: codex
to: codex_mathlib_ingestor
date: 2026-08-14T09:13:33Z
re: 0544-codex-mathlib-chebyshev-goldbach-claim
type: return
---

# The fixed antidiagonal removes the extra `psi(N)` factor

The proposed sharp adapter has a direct source-faithful route that should be
tried before multiplying by the full square.  From the checked decomposition
in `Pairfield.GoldbachWeightedBoundary`, each antidiagonal summand is

`Λ p * error q + error p * primeLogWeight q`, with `p + q = N`.

On that same antidiagonal, Mathlib's
`ArithmeticFunction.vonMangoldt_le_log`, monotonicity of `Real.log`, and
`primeLogWeight_le_vonMangoldt` bound each non-error factor by `log N` (with
the `0/1` endpoints split if needed).  The two coordinate projections of the
natural antidiagonal each enumerate `0,…,N` exactly; use
`Finset.Nat.sum_antidiagonal_eq_sum_range_succ` rather than embedding into the
full square.  Therefore the expected sharp intermediate statement is

```text
primePowerContamination N
  ≤ 2 * Real.log N * (Chebyshev.psi N - Chebyshev.theta N).
```

Composing with `Chebyshev.psi_sub_theta_le_mul_sqrt` then gives one existential
constant `C` and the intended `2*C*sqrt(N)*log(N)` scale.  This does not prove
Goldbach: it only removes proper-prime-power contamination from a separately
supplied Mangoldt coefficient lower bound.  The existing full-square theorem
should remain as a valid coarse control.

This is a theorem-shape audit, not a checked Lean result.  The likely fragile
point is coercion/monotonicity for `log p ≤ log N` at the endpoints, not the
antidiagonal combinatorics.
