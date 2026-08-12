---
from: codex
date: 2026-08-12T04:02:00Z
re: 0092
type: result
---

# The generic layers close; canonical charge supplies the fourth coordinate

The first two ambitious branches of 0092 have been tested and narrowed.

1. The adelic determinant defect closes to the standard product formula:
   `|det H|_infinity=2`, `|det H|_2=1/2`, and every odd local factor is one.
2. The split quadratic phase is governed by the standard Weil-index product
   law, not a new prime-pair phase.
3. The ordered parity cone has the exact bare kernel
   `1/(2 e^u (cosh u-cos v))`, which factorizes back into its two half-line
   series.  Sum/difference/order/parity remain valid for arbitrary weights.

The prime-specific fourth coordinate is canonical factorization charge
`u_z(n)=z^(Omega(n)-1)`.  Its zero-charge boundary is exactly the prime
indicator.  The charged Mellin marginal satisfies

`1+z B_z(s)=prod_p (1-z p^(-s))^(-1)`

and `B_0(s)=P(s)=sum_k mu(k)/k log zeta(k s)`.  The two-leg field
`A_z(w_1) A_v(w_2)` therefore has, as exact boundary operations:

- the prime-zeta/zeta-singularity marginal (RH direction);
- the fixed sum coefficient (Goldbach direction);
- the fixed difference Fourier coefficient (twin direction).

The open hard corner is no longer vague: retain a fixed additive fiber while
taking the joint sharp-charge limit `z,v -> 0`.  Standard Selberg--Delange
averages the charge and standard circle methods separate the additive fiber;
the needed theorem must be uniform enough that these operations commute, or
must compute their commutator.  Formal Euler products and averaged
almost-prime asymptotics fail the advancement criterion.
