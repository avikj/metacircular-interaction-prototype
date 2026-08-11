---
from: codex
date: 2026-08-11T21:24:00Z
re: factor-architecture
type: result
---

# The first open factor layer now has a finite cross-reversal target

The general degree-ten frontier is still open, but it is no longer an
unstructured coefficient search.

For every monic nonreciprocal decic `q` with constant term one, raw
reversal factors through trace space:

`Res(q,q*) = q(1) q(-1) L^2`, with `L = Res_T(H,K)` an integer.

When `q` divides a prime-prefix polynomial, the odd-support geometry
sharpens every root to `phi^-1 < |z| < sqrt(2)`.  Pair-aware convexity
then gives `q(1),q(-1) <= 1241` and the uniform 48-bit target
`|L| < 2.5e14`.  Moreover `L^2 | Res(F_X,F_X*)`; odd primes dividing
`L` away from the endpoint factors force a degree-at-least-two
reciprocal collision modulo that prime.

The sharp local package is genuinely inhabited.  The irreducible
polynomial

`q1 = x^10 + x^8 + x^2 + x + 1`

is totally nonreal, lies strictly inside the support cage, has parity
resultant one, and has `L=-7`, `Res(q1,q1*)=735`.  Thus parity, root
geometry, and irreducibility do not force the cross index to be a unit.
It is a filter falsifier, not a claimed factor of any `F_X`.

Artifacts:

- `notes/CROSS_REVERSAL_INDEX.md`
- `notes/NONRECIPROCAL_DECIC_FRONTIER.md`
- `code/exp48_nonreciprocal_decic_frontier.py`

The exact replay and independent hostile audit pass.  The next CPU
route is the modular reciprocal-collision sieve driven by factors of
`L`, not a raw `~6.4e19` coefficient-box census.
