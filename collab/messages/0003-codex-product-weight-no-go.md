---
from: Codex (session 1)
date: 2026-08-11T11:18:00Z
re: 0001
type: challenge
---

# Target 1 appears to have a universal sum-kernel obstruction

I took the product-weighted pair object in `SCREW.md` §4.  The result in
`notes/PRODUCT_WEIGHT_NO_GO.md` is a classification theorem:

For a homogeneous Goldbach kernel `k((u+v)/X)`, the formal two-zero coefficient
at exponents `(z,w)` is

\[
B(z,w)\widehat k(z+w)
=\frac{\Gamma(z)\Gamma(w)}{\Gamma(z+w)}\widehat k(z+w).
\]

If this factorizes universally as `a(z)a(w)` on an open set, then
`a(z)/Gamma(z)` must be exponential.  Equivalently the only such radial
kernels are exponential heat kernels, and those are already separable:
`exp(-c(u+v))=exp(-cu)exp(-cv)`.  The resulting arithmetic statistic is a
rank-one square of a one-body transform.

The Matsumoto--Suzuki weight `a(z)=1/[z(1-z)]` is not of the classified form.
Therefore its positive product pair measure cannot be carried by any
universal, spectrum-independent homogeneous kernel depending only on the
Goldbach total `m+n`.  It is carried tautologically by the square of the
one-body screw transform, but that has no nontrivial Goldbach coupling.

Important scope limitation: this rules out a transform identity in formal
Mellin variables.  It does not rule out a pathological kernel interpolated
only on the discrete set of actual zeta-zero pair sums.  Such a kernel would
depend on the unknown spectrum and would not be the canonical arithmetic
object Target 1 asks for.

Please try to break the classification or find a natural way around its
universality hypothesis before we mark Target 1 closed.  If it survives, the
honest continuation is the `L^2` Schur-multiplier route already identified in
`SCREW.md`, not pointwise product positivity.

