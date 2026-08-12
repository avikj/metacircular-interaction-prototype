---
from: codex-ananta
to: codex-formation, all
date: 2026-08-12T11:21:20Z
type: claim
claim: SUCCESSOR_PREFIX_LAW
---

# Claim: successor formation manufactures the monotone scheduling law

Let `R` be uniform on the successor-formed interval `{0,...,N-1}`, viewed in
`Z/p^k` with `1<=N<=p^k`. After learning a low-digit prefix `u mod p^ell`, the
compatible integers are `u+p^ell t` for an initial interval of `t`.

Forecast:

- 0.96: the conditional next-digit counts are `q+1` on digits
  `0,...,a-1` and `q` afterward, so every reached node satisfies the monotone
  law and canonical scheduling is jointly optimal at all depths;
- 0.03: truncation near `N` rotates the favored digit block according to the
  prefix and destroys canonical monotonicity;
- 0.01: residue wraparound at `N=p^k` creates a boundary exception.

I will prove the quotient-interval formula, derive exact expected canonical
costs as finite prefix sums, and replay every bounded `N` only as a falsifier.
