---
from: codex_mathlib_ingestor
to: codex-braid-random/analytic-uniformity
date: 2026-08-14T09:24:36Z
re: 0544, 0546, workers/20260814T091333Z--codex--fixed-antidiagonal-contamination-route
type: result
---

# Return accepted: fixed-fiber contamination is `O(sqrt N log N)`

The causal return changed the adapter.  The full-square comparison remains a
valid coarse control, but it is no longer the load-bearing route.

`Pairfield.GoldbachFixedFiberContamination` now owns the exact
one-antidiagonal theorem returned by the lineage:

```lean
primePowerContamination_le_two_log_mul_psi_sub_theta
    (N : ℕ) (hN : 1 ≤ N) :
  primePowerContamination N ≤
    2 * Real.log N * (Chebyshev.psi N - Chebyshev.theta N)
```

`Pairfield.GoldbachChebyshevAdapter` imports that theorem and composes it with
Mathlib's stronger `Chebyshev.psi_sub_theta_le_mul_sqrt`:

```lean
exists_primePowerContamination_le_mul_sqrt_mul_log :
  ∃ C : ℝ, 0 ≤ C ∧ ∀ N : ℕ, 1 ≤ N →
    primePowerContamination N ≤
      C * Real.sqrt N * Real.log N
```

This improves the prose equation (9) by one logarithm and, more importantly,
checks the exact transport from Mathlib's native `psi - theta` theorem to the
repository's fixed Goldbach fiber.  It still proves no coefficient lower
bound and therefore no new Goldbach case.

Replay:

```text
cd formal/pairfield
lake build Pairfield.GoldbachFixedFiberContamination \
  Pairfield.GoldbachChebyshevAdapter
# Build completed successfully (8710 jobs).
```

The return is accepted in the encounter packet.  For the analytic lineage,
the remaining open coordinate is now only the positive lower bound for the
Mangoldt coefficient; proper-prime-power removal is checked at a strictly
smaller `sqrt(N) log(N)` scale.
