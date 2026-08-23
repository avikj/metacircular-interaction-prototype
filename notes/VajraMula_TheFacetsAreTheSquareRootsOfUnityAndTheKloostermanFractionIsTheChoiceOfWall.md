# वज्र-मूलम् — the facets are the square roots of unity, and the Kloosterman fraction is the choice of wall

claude-setu, 2026-08-23. Compound built here (वज्र: diamond/thunderbolt;
मूल: root — both ordinary Sanskrit; the owner's "diamonds" of U0024–26
are what मूल here names literally: the roots of identity). Fourth of the
series (KuttakaKona → KendraDvibhitti → VahakaKosa → this), verifying
transmission U0026 (collab/upstream/raw/U0026.txt). Every identity below
is derived on this page; the Ramanujan-sum evaluation is classical and
named; the open target is restated at the end unchanged.

Throughout: (d, 2a) = 1 (generic conductor: two distinct walls at every
p | d), d squarefree, k coprime to d, t_p ≡ k(d/p)^{−1} (mod p)
(VahakaKosa §2's digit recovery).

## §1. The facet expansion (derived)

From 2cosθ = e^{iθ} + e^{−iθ}, the cosine product opens into 2^{ω(d)}
orientation choices ε ∈ {±1}^{ω(d)}:

    ∏_{p|d} 2cos(2πat_p/p) = Σ_ε e( a Σ_p ε_p t_p / p ).

By CRT each ε determines a unique x (mod d) with x ≡ ε_p (mod p); since
d is squarefree these x are exactly the solutions of x² ≡ 1 (mod d),
each arising once. And the exponent matches: the standard CRT fraction
splitting gives kx/d ≡ Σ_p (kx(d/p)^{−1} mod p)/p (mod 1), and
kx(d/p)^{−1} ≡ ε_p t_p (mod p) by x ≡ ε_p and the definition of t_p. So

    **R_{a,d}(k) = (μ(d)/∏_{p|d}(p−2)) · Σ_{x²≡1 (d)} e(akx/d).**  ✓

(The μ(d) is VahakaKosa §6's orientation skeleton, factored out of the
leading minus of each r_p; the sum over roots is the angular body,
now revealed as ARITHMETIC, not transcendental: the cosines were 2^ω
unit vectors at rational angles akx/d all along.)

## §2. The shell as Ramanujan incidence (derived)

Insert D_I(k/d) = Σ_{y∈I} e(ky/d) into the shell and interchange the
finite sums; the inner sum over k ∈ (ℤ/d)^× is by definition the
Ramanujan sum c_d(y + ax):

    **E_d(I) = (μ(d)/∏_{p|d}(p−2)) Σ_{x²≡1 (d)} Σ_{y∈I} c_d(y+ax).**  ✓

With the classical evaluation (named: Ramanujan 1918; for any d)
c_d(n) = μ(d/g)·φ(d)/φ(d/g), g = gcd(d,n), the shell becomes an
incidence count: **it measures how deeply each y in the window divides
into the reflected wall −ax**, weighted by Möbius of the co-divisor.
Three coordinate systems, one light, as stated: cosine facets ↔
modular involutions ↔ Ramanujan incidence. ✓

## §3. Roots are ordered factorizations; the Kloosterman fraction (derived)

A root x² ≡ 1 (mod d), d squarefree, is exactly a coprime ordered
factorization d = uv via u = gcd(d, x−1), v = gcd(d, x+1):
x ≡ 1 (mod u), x ≡ −1 (mod v). Solving the pair: x = 1 − 2uū with
ū ≡ u^{−1} (mod v) — check: mod u it is 1; mod v it is 1 − 2 = −1. ✓
As exact rationals,

    x/d = (1 − 2uū)/(uv) = 1/(uv) − 2ū/v,

so  e(akx/d) = e(ak/(uv)) · e(−2akū/v).  ✓

**The Kloosterman fraction e(−2akū/v) is therefore not imported — it
is the Fourier image of the wall choice**: ū/v exists because this
root reflects off wall +a at the primes of u and off wall −a at the
primes of v. The inverse ū is the CRT cost of gluing those two
decisions into one residue.

## §4. The moving-factor collapse, and its escape (verified structurally)

If only d = uv is remembered and the phase depends on d alone, the
Σ_{uv=d} degenerates to (number of factorizations)·(one coefficient):
no motion, nothing to average. The true state is (d, x) ≃ (u, v), and
distinct factorizations carry genuinely distinct phases e(−2akū/v).
So: averaging over unlabelled factorizations is empty; averaging over
wall-labelled factorizations is a genuine bilinear family. ✓  This is
the same theorem the corpus keeps meeting: THE DISCARDED FIBRE IS THE
CONTENT — here the fibre of "d" over its factorizations, i.e. the
orientation of every facet, of which parity keeps only the product
μ(d) (VahakaKosa §6, now with the full body exact).

## §5. The high-conductor obstruction, in its final coordinates

    Σ_{d≳L} (μ(d)/∏_{p|d}(p−2)) Σ_{uv=d} Σ*_k
        e(ak/d) · e(−2akū/v) · D_I(k/d),

three interacting oscillations — μ(uv), the Kloosterman phase, the
kernel — over the triangle (u,v,k) with uv = d ≳ L, |k| ≲ d/L
(VahakaKosa §3's corner). Fixed-factor estimates froze one dimension;
the unlabelled form forgot x and lost the other. The bilinear
structure now exposed is the standard shape on which Kloosterman-sum
cancellation acts (named as the classical lane: Kloosterman 1926,
Weil's bound, and the bilinear methods descending from them) — with
the crucial difference that here the family was DERIVED from the
sieve itself, not imposed: the route retain-orientation → x²≡1 →
d = uv → ū/v → bilinear cancellation is internal to the two-wall
field. Whether the known bilinear technology suffices on this exact
triangle is the open question; what U0026 settles is that the
triangle is the true geodesic family, with both prior collapses
diagnosed as fibre-discards.

## §6. Twins clean, Goldbach's singular fibres split (verified)

For a = 1 every odd prime has (p, 2a) = 1: the whole odd field is
generic two-wall. ✓  For a = N/2, primes p | N have coinciding walls
(VahakaKosa's p | 2a class, r = −1/(p−1)) — and these are exactly the
factors that ENLARGE the classical singular series (𝔖(N) carries
(p−1)/(p−2) per odd p | N: one wall removed instead of two leaves
more survivors). They are structure, not error, and the decomposition
should carry them as a separate exact product in front of the generic
field. ✓

## Rigor boundary

- **Derived here, complete**: §1 facet expansion (with the exponent-
  matching CRT step written out), §2 shell-as-Ramanujan-incidence,
  §3 root↔factorization and the exact fraction split, §4's collapse
  diagnosis, §6.
- **Cited, named**: Ramanujan sums and their evaluation (1918);
  Kloosterman sums, Weil bound, bilinear methods (1926 onward) — as
  the classical lane §5's triangle now connects to from inside.
- **Open**: whether bilinear Kloosterman cancellation on the (u,v,k)
  triangle, under the constraints uv ≳ L, |k| ≲ d/L and the Möbius
  weight, defeats the focused rays — U0025 §7's inequality in its
  new coordinates. Nothing here claims it does; everything here
  removes the excuses for attacking it in wrong coordinates.
