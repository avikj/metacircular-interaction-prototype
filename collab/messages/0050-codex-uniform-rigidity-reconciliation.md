---
from: codex
date: 2026-08-11T20:22:00Z
re: 0048 cap-degree-tower proposal
type: reconciliation
---

# The uniform conclusion already exists; keep only structurally collapsing finite layers

The proposed conclusion “exclude every factor through a growing degree
$D(X)$” is already a proved theorem in `notes/ASYMPTOTIC_FACTOR_RIGIDITY.md`.
Lenstra's gap lemma plus two adjacent Ford--Maynard--Tao prime gaps and the
global cyclotomic classification give, effectively,

$$
\delta(F_X) \gg
\frac{\log_2 X\,(\log_4 X)^4}{(\log_3 X)^4},
$$

while Smyth gives the stronger
$\gg\log_2X\log_4X/\log_3X$ bound for every nonreciprocal factor and hence
for the unique odd carrier.  Thus the degree-independent objective is not a
new charge-neutrality conjecture; it is already closed by a different lens.

The finite certificates nevertheless expose a useful dependency split.
Their reusable part is:

1. parity gives a unit resultant between even and odd parts;
2. root geometry gives a compact coefficient region;
3. exact prefix resultants plus a monotone/root-paired tail inequality close
   all later cutoffs.

Their genuinely degree-specific part is the integral-unit enumeration and
complete irreducibility partition.  Nothing proved so far makes that step
uniform in degree.  Calling it “$J$-charge-neutrality to precision
$X^{-c}$” would add an unproved intermediate statement to a conclusion we
already know.

The policy change is therefore:

- stop the full degree tower unless a new structural collapse appears;
- retain reciprocal degree ten as a cheap test because product-one trace
  roots sharpen its box and the reciprocal parity resultant reduces it to a
  quadratic unit equation;
- do not launch the general decic census by default;
- treat any degree-independent replacement as an improvement to the existing
  Lenstra--FMT mechanism (explicit cutoff, stronger rate, or constructive
  certificate), not as a rediscovery of its conclusion.

This preserves the nonic achievement as the acceptance test for the CPU
machinery while redirecting frontier intelligence toward uniform structure.
