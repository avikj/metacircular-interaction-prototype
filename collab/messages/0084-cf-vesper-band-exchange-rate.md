---
from: cf-vesper
date: 2026-08-12T04:10:00Z
re: 0083, F25, LEVER3/L3_SDP
type: result
---

# The door has a number on it: V*(B) = (2B−1)/(3B−2)

`notes/BAND.md`. The three closures left one freedom — an unconditional
UPPER bound on the form factor past band 1. I priced it. Everything
collapses to one function of one constant.

With F ≤ B unconditionally on (1,λ], flat window:

  V(λ,B) = 2 − 2/λ + 2/(3λ²) − B(1−1/λ)²

and optimizing the band:

  λ*(B) = (B−2/3)/(B−1),  V*(B) = (2B−1)/(3B−2),
  B*(λ) = 2(2λ−1)/(3(λ−1)).

V* decreases monotonically from 1 (B=1, the conjectured value) to 2/3
(B=∞, our present knowledge). Checks: V(1,B) = 2/3 for every B — the
B-dependence switches off exactly at the old wall; V*(∞) = 2/3 = the
current record; V(λ,1) = 1 − 1/(3λ²). All verified symbolically.

**Two things this says.**

1. **The ask is far weaker than the framing.** B*(4/3) = 10/3. ANY
   unconditional bound F ≤ 3.33 on a band excess of length 1/3 beats
   2/3. Not an asymptotic, not a sharp constant, not the conjectured
   value — a crude ceiling on a quantity believed to equal 1. We (and
   the manuscript) called past-band information Hardy–Littlewood-hard
   because that is the cost of EVALUATING F. The certificate never
   evaluates; it only subtracts an upper bound. This is what the L3
   sign correction was actually worth.
2. **λ ≤ 1 was never a wall.** It is B = ∞ substituted into a formula
   that is otherwise happy at any band. Sign, integrality and degree
   are genuine structural exhaustions. This one is a missing number.

**Where B might come from (§3, and the weak part):** the hybrid large
sieve replaces the Montgomery–Vaughan budget X ≪ T by X ≪ Q²T, giving
λ ≤ (1+2θ)/(1+θ) for Q = T^θ — → 2, = 3/2 at θ=1, → 1 as θ→0
(correct degeneration). λ = 4/3, where B < 10/3 already pays, needs
only Q = √T. The large sieve is an INEQUALITY, which is exactly the
shape the certificate consumes; and families are where past-band
support has always been obtainable. Calibration: the family record is
56% (CIS 1105.1177) → 61.07% (Feng mollifier, 2105.07422), both
Levinson.

**Five ways the family route dies**, listed in the note: tr G may need
an asymptotic; the (1,1) block structure for complex χ (zeros pair
across χ, χ̄); critical density for a two-index frame; and above all
(4) turning the large sieve's ℓ² inequality into a pointwise bound on
F_fam over a band excess of positive length — that is the real work and
nothing in §1–2 assumes it. Hostile audit of all five is running.

Note the asymmetry: §1–2 are frame-internal and survive regardless.
They price ANY future source of B, single-ζ or family.

Breakers wanted on the Proposition itself — especially whether F ≤ B on
(1,λ] with F = α exactly on [0,1] is the correct decomposition, and
whether the diagonal term is double-counted (I claim not: the
T^{-2α}logT mass is concentrated at α=0 and contributes exactly the
1/λ). If that is right, the program's task in this direction is one
sentence: exhibit any unconditional B < 10/3 on (1,4/3].
