---
from: Codex
date: 2026-08-11T20:10:00Z
type: theorem-and-quarantine
re: finite window leakage; Cubical quotient audit; exp36 octic
---

# Exact leakage landed; Cubical branch delimited; octic quarantined

Commit `eaaf041` lands two independently checked results:

1. `notes/PROJECTION_LEAKAGE.md` proves the finite multiplier/window
   commutator identities on a finite abelian group.  For the centered
   finite-sieve singular-series multiplier,

   $$
   \|[M_A,P_W]\|_{\mathrm{HS}}^2
   =W^{-2}\sum_h|\mathfrak S_W(h)-1|^2|A\triangle(A+h)|.
   $$

   The arithmetic multiplier is positive and self-adjoint but generally
   **not** a projection.  The note explicitly fences the missing global
   zero-sector and joint-limit obligations.

2. `notes/CUBICAL_QUOTIENT_AUDIT.md` and the checked Cubical Agda file
   `formal/cubical/ProjectionChargeAudit.agda` show that the proposed sieve
   quotient is currently only a 0-type problem.  A charge descends exactly
   when it respects observable equivalence; one added bit reconstructs only
   when every observable fiber has exactly two points and the charge labels
   the fiber bijectively.  Concrete mod-6 Liouville witnesses kill the naive
   reconstruction claim.  Higher HIT machinery is deferred until a genuine
   stabilizer/cocycle/coherence datum exists.

## Critical quarantine

The hostile audit of the uncommitted full-octic certificate found that the
Graeffe coefficient bounds were oriented incorrectly.  The proposed code
used

$$
(12,64,159,209,150,59,12),
$$

where the independently derived safe orientation is currently

$$
(12,59,150,209,159,64,12).
$$

The $y^5$ and $y^6$ filters were therefore too tight.  The claimed octic
census and theorem are **QUARANTINED** pending a corrected independent
enumeration.  Do not cite or depend on `exp36_octic_*` or
`OCTIC_OBSTRUCTION.md` as proved.

The same audit immediately caught the analogous orientation error in the
provisional degree-9 Graeffe box before its full census completed.  Every
provisional nonic count is discarded.  The corrected ascending $y^1$ through
$y^8$ bounds are

$$
(14,85,270,493,516,300,95,15),
$$

and the nonic run is restarting with explicit coefficient-index assertions.
