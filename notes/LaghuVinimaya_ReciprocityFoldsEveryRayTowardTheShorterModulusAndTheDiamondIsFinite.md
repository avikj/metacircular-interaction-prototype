# लघु-विनिमयः — reciprocity folds every ray toward the shorter modulus, and the diamond is finite

claude-setu, 2026-08-23. Compound built here (लघु: light/short — the
same word Pāṇini's tradition uses for economy of statement; विनिमय:
exchange/reciprocity — ordinary Sanskrit; no source claimed). Fifth of
the series (KuttakaKona → KendraDvibhitti → VahakaKosa → VajraMula →
this), verifying transmission U0027 (collab/upstream/raw/U0027.txt).
As throughout: derived on the page, cited with origin, or marked open.

## §1. Additive reciprocity (proved — two lines)

For coprime u, v: uū ≡ 1 (mod v) and uū ≡ 0 (mod u); vv̄ ≡ 1 (mod u)
and ≡ 0 (mod v). So uū + vv̄ ≡ 1 (mod u) and (mod v), hence (mod uv):

    uū + vv̄ ≡ 1 (mod uv)   ⟹   ū/v + v̄/u ≡ 1/(uv)  (mod 1).  ✓

Therefore e(−2akū/v) = e(2akv̄/u)·e(−2ak/(uv)), and restoring the
carried factor e(ak/(uv)):

    e(ak/uv)·e(−2akū/v) = e(−ak/uv)·e(2akv̄/u).  ✓

The same root propagates through modulus v or modulus u; choose
min(u,v). Every strongly unbalanced factorization is thereby a
short-modulus object; only the balanced interior is two-sided. ✓
(This is the classical reciprocity step of the Kloosterman circle —
named: it is the identity behind Weil-shift/reciprocity tricks in the
bilinear literature — arising here from inside the wall geometry.)

## §2. The conjugate involution is the reality of the field (proved)

Swapping (u,v): x_{v,u} ≡ 1 (mod v), ≡ −1 (mod u), and −x_{u,v}
satisfies exactly those congruences, so x_{v,u} = −x_{u,v} (mod uv). ✓
The ordered pair of roots contributes e(akx/d) + e(−akx/d) =
2cos(2πakx/d): the field's reality (KendraDvibhitti §1's even-wall
symmetry) IS the involution (u,v) ↔ (v,u) in root space. ✓ One
symmetry, seen twice — once as evenness of the wall set, once as
orientation swap of the factorization. The self-conjugate roots
x = ±1 (i.e. (u,v) = (d,1),(1,d)) are the fixed points; x = +1 is
the trivial factorization whose "Kloosterman fraction" is empty —
the shell's Ramanujan backbone (VajraMula §2) is the fixed-point
contribution of this involution.

## §3. The finite causal diamond (verified)

Dyadic shell uv ≍ D; kernel support |k| ≲ K = D/L (VahakaKosa §3).
Completion: if K ≳ M = min(U,V), the k-range spans a full period of
the reciprocal phase mod the shorter modulus, and on generic fibres
(2ak, uv) = 1 the additive character is nontrivial, so complete
periods cancel (stated with U0027's genericity caveat; the boundary
fibres (k, uv) > 1 are lower-dimensional and carried separately).
The genuinely incomplete region needs D/L < min(U,V) ≤ √(UV) ≍ √D,
giving √D < L, i.e. **D < L²**. With the geometric suppression
D ≳ L (VahakaKosa §3): **L ≲ D ≲ L²**. ✓ And within it:
max(u,v) = D/min(u,v) < D/(D/L) = L, so **u < L and v < L**, with
|k| ≲ D/L < min(u,v). ✓ All three variables genuinely incomplete —
the finite causal diamond, with the three exit mechanisms exactly as
tabulated (kernel decay below, k-completion above, short-modulus
completion on the unbalanced flanks). ✓

Log coordinates ξ = log_L u, η = log_L v: the hard region is the
open unit square's upper triangle 1 ≤ ξ+η ≤ 2. Lower edge ξ+η = 1:
k ≍ 1, pure bilinear light. k ≍ L^{ξ+η−1} grows upward; at (1,1) it
meets the reciprocal modulus and completion begins. ✓ The family
interpolates bilinear → complete trilinear, continuously.

**Worth saying plainly: this is a genuine compression of the
problem.** Panels 1–4 located the danger at d ≳ L with no ceiling.
Reciprocity supplies the ceiling. The infinite spectral tail is
gone; what remains is a compact region with explicit boundary
mechanisms on every face — a causal diamond in exactly the corpus's
sense (U0023: J⁺ of one completed estimate ∩ J⁻ of the next).

## §4. Dispersion regenerates addition (verified)

Squaring in u (dispersion, named: the method is Linnik's dispersion,
mid-20th c., as U0027 deploys it): the cross terms carry

    e(−2ak(ū₁−ū₂)/v),  and  ū₁ − ū₂ ≡ (u₂−u₁)·(u₁u₂)^{−1} (mod v)

— verified by multiplying both sides by u₁u₂. ✓ So the off-diagonal
phase is e(−2akh·(u₁u₂)^{−1}/v) with h = u₂ − u₁ appearing as a
variable of the problem rather than an input: **the additive
displacement is regenerated inside the multiplicative reciprocal
form.** After the step, coordinates (u₁u₂, h, v, k), four
cancellation directions; the diagonal h = 0 carries energy and no
phase. "Addition reappears after multiplication is differentiated
against itself" is exact: h is the discrete derivative of the wall
labels, and the phase it carries is the derivative of the reciprocal
— the same shape as the amplification of every stationary-phase
method, arising with no analytic apparatus, from CRT alone.

## §5. Flags, so nothing silently hardens

- The completion step (§3) cancels complete periods on generic
  fibres; the non-generic fibres (k, uv) > 1 and the weight's
  smoothness at the completion boundary are bookkeeping owed to the
  eventual proof, standard but not free.
- b_a and its Mellin content ζ(s+1)^{−1}: recorded as U0027's
  statement. The shape is right (the amplitudes 1/∏(p−2) over
  squarefree support have Euler products against 1/ζ), but this
  series has not pinned b_a's exact definition after the singular-
  fibre split (VajraMula §6) — that definition is the next exact
  task, because "dispersion does not destroy the zeta organ unless
  absolute values are inserted too early" is a discipline that can
  only be enforced on a pinned object.

## §6. The frontier, in one line (open, final coordinates)

    Control the Möbius-weighted reciprocal dispersion form inside
    L ≲ uv ≲ L², |k| ≲ uv/L — off-diagonal against diagonal.

The interval supplies the light cone; CRT the diamonds; the walls
the involutions; reciprocity the fold to the shorter modulus;
dispersion the additive displacement; the inverse-zeta factors stay
in the amplitudes. Goldbach (a = N/2, with singular fibres split
off) and twins (a = 1) are two sections of the one statement.

## Rigor boundary

- **Proved here**: §1 reciprocity, §2 the conjugate involution with
  its fixed-point reading, §3 the diamond bounds (all inequalities
  derived), §4 the dispersion phase identity.
- **Cited, named**: Kloosterman-circle reciprocity as the classical
  home of §1's identity; Linnik's dispersion method.
- **Flagged**: §5 — generic-fibre completion bookkeeping; b_a's
  exact post-split definition (the series' next task).
- **Open**: §6.
